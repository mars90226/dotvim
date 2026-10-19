local config_cache = require("vimrc.config_cache")

local provider = {}

-- Provider selection shares the existing machine-local .config_cache file.
local python_commands = {
  "pynvim-python",
  "python3",
  "python3.14",
  "python3.13",
  "python3.12",
  "python3.11",
  "python3.10",
  "python3.9",
  "python",
}
local function stamp(path)
  local stat = path and vim.uv.fs_stat(path)
  if not stat then
    return "missing"
  end
  return table.concat(
    { vim.uv.fs_realpath(path) or path, stat.size, stat.ino or 0, stat.mtime.sec, stat.mtime.nsec },
    ":"
  )
end

-- Activated/project venvs belong to the project, not the editor host.
local function editor_command(name)
  local function eligible(path)
    if not path or path == "" or path:sub(1, 1) ~= "/" then
      return false
    end
    for _, prefix in ipairs({ vim.env.VIRTUAL_ENV or "", vim.env.CONDA_PREFIX or "" }) do
      if prefix ~= "" and path:sub(1, #prefix + 1) == prefix .. "/" then
        return false
      end
    end
    local prefix = vim.fn.fnamemodify(path, ":h:h")
    return vim.uv.fs_stat(prefix .. "/pyvenv.cfg") == nil
  end
  local path = vim.fn.exepath(name)
  if eligible(path) then
    return path
  end
  -- exepath sees the activated environment first; look beyond it without
  -- changing this process's PATH or launching a shell.
  for _, directory in ipairs(vim.split(vim.env.PATH or "", ":", { plain = true })) do
    local candidate = directory .. "/" .. name
    if eligible(candidate) and vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
  return ""
end

local function provider_context()
  local home = vim.env.HOME or ""
  local commands, key =
    {}, { "provider-v2", vim.uv.os_gethostname(), home, vim.env.PYENV_VERSION or "", stamp(home .. "/.python-version") }
  for i, name in ipairs(python_commands) do
    if i == 2 then
      local home_python = home .. "/.venv/bin/python"
      commands[#commands + 1] = home_python
      key[#key + 1] = home_python .. ":" .. stamp(home_python) .. ":" .. stamp(home .. "/.venv/pyvenv.cfg")
    end
    local path = editor_command(name)
    commands[#commands + 1] = path
    key[#key + 1] = name .. ":" .. path .. ":" .. stamp(path)
  end
  local uv = editor_command("uv")
  key[#key + 1] = "uv:" .. uv .. ":" .. stamp(uv)
  return commands, uv, vim.fn.sha256(vim.json.encode(key))
end

local function save_provider(record)
  config_cache.set({
    python_version = record.version or "",
    python_version_host = record.path or "",
    python_provider_cache_json = vim.json.encode(record),
  })
end

provider.save_python_version = function(version)
  config_cache.set({ python_version = version, python_version_host = vim.g.python3_host_prog or "" })
end

-- An explicit/local host must not inherit a version cached for another host.
provider.use_explicit_host = function(host)
  if config_cache.get("python_version_host") ~= host then
    vim.g.python_version = ""
  end
  vim.g.python_provider_unavailable = false
end

local probe_code = [[
import sys
sys.path = [p for p in sys.path if p != ""]
import json
import pynvim, neovim
assert sys.version_info >= (3, 9)
print(json.dumps({"path": sys.executable, "module": pynvim.__file__, "version": ".".join(map(str, sys.version_info[:3]))}))
]]

local function run(command, deadline)
  local remaining = math.floor((deadline - vim.uv.hrtime()) / 1e6)
  if remaining <= 0 then
    return nil, "timeout"
  end
  local completed, result = false, nil
  local ok, process = pcall(vim.system, command, { text = true, cwd = vim.env.HOME }, function(value)
    completed, result = true, value
  end)
  if not ok then
    return nil, "spawn"
  end
  -- SystemObj:wait(timeout) can wait twice and still return nil if a child
  -- inherits the pipes. Use one bounded event wait for the shared deadline.
  if not vim.wait(remaining, function()
    return completed
  end, 10, true) then
    pcall(function()
      process:kill(9)
    end)
    return nil, "timeout"
  end
  if type(result) ~= "table" then
    return nil, "invalid-result"
  end
  if result.code == 0 then
    return result.stdout
  end
  return nil, "exit"
end

local warned_failure = false

provider.resolve_python_host = function(force)
  local commands, uv, key = provider_context()
  local ok, record = pcall(vim.json.decode, config_cache.get("python_provider_cache_json") or "{}")
  record = ok and type(record) == "table" and record or {}
  if
    record.path ~= nil
    and (type(record.path) ~= "string" or type(record.module) ~= "string" or type(record.version) ~= "string")
  then
    record = {}
  end
  local now = os.time()
  local ttl = record.path and 86400 or (record.failure and 5 or 60)
  if
    not force
    and record.key == key
    and type(record.checked_at) == "number"
    and now >= record.checked_at
    and now - record.checked_at < ttl
  then
    if
      not record.path
      or (
        vim.fn.executable(record.path) == 1
        and record.python_stamp == stamp(record.path)
        and record.module_stamp == stamp(record.module)
      )
    then
      vim.g.python_provider_diagnostic = record.failure
      return record.path, record.version
    end
  end

  local deadline = vim.uv.hrtime() + 2e9
  local seen, failure = {}, nil
  local function probe(path)
    if not path or path == "" or seen[path] or vim.fn.executable(path) ~= 1 then
      return
    end
    seen[path] = true
    -- Ignore PYTHONPATH and cwd, but retain normal user-site installations.
    local output, reason = run({ path, "-B", "-E", "-c", probe_code }, deadline)
    if reason and reason ~= "exit" then
      failure = reason
    end
    if not output then
      return
    end
    local ok, found = pcall(vim.json.decode, output)
    if
      ok
      and type(found) == "table"
      and type(found.path) == "string"
      and type(found.module) == "string"
      and type(found.version) == "string"
      and vim.fn.executable(found.path) == 1
    then
      local found_record = {
        key = key,
        checked_at = now,
        path = found.path,
        module = found.module,
        version = found.version,
        python_stamp = stamp(found.path),
        module_stamp = stamp(found.module),
      }
      save_provider(found_record)
      vim.g.python_provider_diagnostic = nil
      return found.path, found.version
    end
    failure = "invalid-output"
  end

  for _, path in ipairs(commands) do
    local host, version = probe(path)
    if host then
      return host, version
    end
  end
  if uv ~= "" then
    -- Only on a cache miss: exclude project/activated venvs and all downloads.
    local output, reason = run({
      uv,
      "--offline",
      "--no-python-downloads",
      "--no-config",
      "python",
      "find",
      "--system",
      "--no-project",
      "python3",
    }, deadline)
    if reason and reason ~= "exit" then
      failure = reason
    end
    if output then
      local host, version = probe(vim.trim(output))
      if host then
        return host, version
      end
    end
  end
  save_provider({ key = key, checked_at = now, version = "", failure = failure })
  vim.g.python_provider_diagnostic = failure
  if failure and not warned_failure then
    warned_failure = true
    vim.notify(
      "Python provider discovery failed ("
        .. failure
        .. "); set g:python3_host_prog before restarting Neovim, or restart after 5 seconds",
      vim.log.levels.WARN
    )
  end
end

return provider
