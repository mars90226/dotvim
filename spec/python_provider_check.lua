-- Run from the checkout with nvim -u NONE -i NONE -n --headless -l spec/python_provider_check.lua.
vim.opt.runtimepath:prepend(vim.fn.getcwd())
local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
local saved = {
  home = vim.env.HOME,
  system = vim.system,
  exepath = vim.fn.exepath,
  hostname = vim.uv.os_gethostname,
  path = vim.env.PATH,
  virtual_env = vim.env.VIRTUAL_ENV,
  conda = vim.env.CONDA_PREFIX,
  has = vim.fn.has,
  notify = vim.notify,
}
local checks = 0
local function expect(value, message)
  assert(value, message)
  checks = checks + 1
end
local function file(path, text, executable)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  vim.fn.writefile(vim.split(text, "\n", { plain = true }), path)
  if executable then
    vim.uv.fs_chmod(path, 493)
  end
  return path
end
local forbidden = { "vimrc.python_provider", "vimrc.check", "vimrc.plugin_utils", "vimrc.config_snapshot" }
for _, name in ipairs(forbidden) do
  package.preload[name] = function()
    error("Storage loaded domain module " .. name)
  end
end
package.preload["vimrc.utils"] = function()
  return {
    get_vim_home = function()
      return root .. "/storage"
    end,
  }
end
vim.fn.mkdir(root .. "/storage", "p")
vim.system = function()
  error("Storage spawned a process")
end
local cache = require("vimrc.config_cache")
cache.init(function(initializing)
  return { marker = initializing and "initial" or "updated", enabled = true }
end)
cache.read()
expect(cache.get("marker") == "initial", "generic initialization")
vim.fn.writefile({ "let g:unrelated = 17" }, cache.path, "a")
expect(cache.set({ marker = "it's portable", enabled = false }), "generic subset update")
vim.g.marker, vim.g.enabled = nil, nil
cache.read()
expect(cache.get("marker") == "it's portable" and cache.get("enabled") == false, "generic serialization")
expect(vim.g.unrelated == 17, "unrelated field preserved")
cache.update()
expect(cache.get("marker") == "updated", "registered collector refresh")
for _, name in ipairs(forbidden) do
  package.preload[name] = nil
end
package.preload["vimrc.utils"], package.loaded["vimrc.utils"] = nil, nil
local check = require("vimrc.check")
local os_name = "Linux test"
check.get_os = function()
  return os_name
end
check.get_distro = function()
  return "test"
end
local basic = require("plug.basic")
local setup = require("plug.config_cache").setup
local mapping, responses, calls, home = {}, {}, {}, nil
local hostname = "fixture-machine"
vim.uv.os_gethostname = function()
  return hostname
end
vim.fn.exepath = function(name)
  return mapping[name] or ""
end
local killed = false
local notifications = {}
vim.notify = function(message)
  notifications[#notifications + 1] = message
end
vim.system = function(command, opts, on_exit)
  calls[#calls + 1] = command
  expect(opts.cwd == home and opts.detach == true, "probe cwd is HOME with private process group")
  if command[1] == mapping.uv then
    expect(
      table
        .concat(command, " ")
        :find("--offline --no-python-downloads --no-config python find --system --no-project python3", 1, true)
        ~= nil,
      "uv safety flags"
    )
  else
    expect(command[2] == "-B" and command[3] == "-E", "probe isolation flags")
  end
  local response = responses[command[1]]
  if response ~= "timeout" then
    if response == "nil" then
      on_exit(nil)
    else
      on_exit(response or { code = 1, stdout = "" })
    end
  end
  return {
    kill = function()
      killed = true
    end,
  }
end
local number = 0
local function fresh(label)
  number = number + 1
  home = root .. "/" .. number .. "-" .. label
  vim.fn.mkdir(home .. "/.vim", "p")
  vim.env.HOME = home
  vim.env.PATH, vim.env.VIRTUAL_ENV, vim.env.CONDA_PREFIX = "", nil, nil
  killed, notifications = false, {}
  cache.path = home .. "/.vim/.config_cache"
  mapping, responses, calls = {}, {}, {}
  hostname, os_name = "fixture-machine", "Linux test"
  package.loaded["vimrc.localconfig"], package.loaded["vimrc.secret"] = nil, nil
  vim.g.python_host_prog, vim.g.python_version, vim.g.python_version_host = nil, "", nil
  vim.g.python_provider_cache_json, vim.g.python_provider_unavailable = nil, nil
end
local function candidate(name)
  local path = file(home .. "/bin/" .. name, "#!/bin/sh\nexit 0", true)
  local module = file(home .. "/lib/" .. name .. "/pynvim/__init__.py", "# fixture", false)
  responses[path] = { code = 0, stdout = vim.json.encode({ path = path, module = module, version = "3.12.9" }) }
  return path, module
end
local function start(explicit)
  calls = {}
  vim.g.python3_host_prog, vim.g.python_provider_unavailable = explicit, nil
  vim.g.loaded_python3_provider = nil -- Reset provider globals; the warning guard remains process-local.
  vim.g.python_provider_cache_json = nil
  setup()
  basic.setup()
  return vim.g.python3_host_prog, #calls
end
local function record(edit)
  local value = vim.json.decode(cache.get("python_provider_cache_json"))
  edit(value)
  cache.set({ python_provider_cache_json = vim.json.encode(value) })
end
fresh("positive")
local host, module = candidate("python3")
mapping.python3 = host
local original_has = vim.fn.has
vim.fn.has = function()
  error("initial snapshot must not query builtin provider")
end
local selected, count = start()
vim.fn.has = original_has
expect(selected == host and count == 1, "cold discovery validates provider")
selected, count = start()
expect(selected == host and count == 0, "warm cache without processes")
expect(vim.g.python_version == "3.12.9", "cached version restored")
vim.fn.has = function()
  error("warm version must not query builtin provider")
end
expect(check.python_version() == "3.12.9", "warm version uses selected cache")
vim.fn.has = original_has
local project = home .. "/project"
file(project .. "/.venv/bin/python", "#!/bin/sh\nexit 1", true)
vim.cmd.cd(project)
selected, count = start()
expect(selected == host and count == 0, "cwd project does not change selection")
record(function(r)
  r.checked_at = os.time() - 86401
end)
selected, count = start()
expect(selected == host and count == 1, "positive expiry revalidates")
file(module, "# changed module contents", false)
selected, count = start()
expect(selected == host and count == 1, "module stamp invalidates")
file(host, "#!/bin/sh\nexit 0 # replaced interpreter", true)
selected, count = start()
expect(selected == host and count == 1, "interpreter stamp invalidates")
record(function(r)
  r.path = home .. "/missing-python"
end)
selected, count = start()
expect(selected == host and count == 1, "missing cached interpreter revalidates")
hostname = "another-machine"
selected, count = start()
expect(selected == host and count == 1, "machine identity invalidates")
-- Activation changes PATH and the first exepath result, but not the editor host.
local project_python = file(home .. "/project/.venv/bin/python3", "#!/bin/sh\nexit 1", true)
file(home .. "/project/.venv/pyvenv.cfg", "home = /fixture", false)
vim.env.PATH = home .. "/project/.venv/bin:" .. home .. "/bin"
vim.env.VIRTUAL_ENV = home .. "/project/.venv"
mapping.python3 = project_python
selected, count = start()
expect(selected == host and count == 0, "activated project venv does not invalidate warm cache")
vim.env.VIRTUAL_ENV = nil
selected, count = start()
expect(selected == host and count == 0, "unactivated project PATH venv is excluded")
mapping.python3 = host
vim.env.PATH = ""
local explicit = candidate("explicit")
selected, count = start(explicit)
expect(selected == explicit and count == 0, "explicit host wins")
expect(vim.g.python_version == "", "different explicit host discards automatic version")
local original_execute = vim.fn.execute
vim.fn.has = function(name)
  return name == "python3" and 1 or 0
end
vim.fn.execute = function()
  return "3.10.1"
end
expect(check.python_version() == "3.10.1", "explicit host version queried")
expect(vim.g.python_version_host == explicit, "version bound to explicit host")
selected, count = start(explicit)
vim.fn.execute = function()
  error("cached explicit version must not query provider")
end
expect(check.python_version() == "3.10.1" and count == 0, "explicit version persists without processes")
vim.fn.execute = function()
  return "3.11.2"
end
expect(check.python_version(true) == "3.11.2", "force queries selected provider")
expect(
  not table.concat(vim.fn.readfile(cache.path), "\n"):find("3.11.2", 1, true),
  "force does not persist outside collector"
)
vim.fn.has, vim.fn.execute = original_has, original_execute
local query = check.python_version
check.python_version = function()
  return "3.12.9"
end
cache.update()
check.python_version = query
selected, count = start()
expect(selected == host and count == 1, "manual refresh invalidates selection")
local samples = {}
for _ = 1, 14 do
  local before = vim.uv.hrtime()
  selected, count = start()
  samples[#samples + 1] = (vim.uv.hrtime() - before) / 1e6
  expect(selected == host and count == 0, "repeated warm startup")
end
fresh("launcher")
host = candidate("launcher")
mapping["pynvim-python"] = host
selected, count = start()
expect(selected == host and count == 1, "pynvim-python discovery")
local project_launcher = file(home .. "/project/.venv/bin/pynvim-python", "#!/bin/sh\nexit 1", true)
file(home .. "/project/.venv/pyvenv.cfg", "home = /fixture", false)
-- This fixture models a stable tool entry outside an environment.
file(home .. "/stable/pynvim-python", "#!/bin/sh\nexit 0", true)
responses[home .. "/stable/pynvim-python"] = responses[host]
mapping["pynvim-python"] = home .. "/stable/pynvim-python"
selected, count = start()
expect(selected == host and count == 1, "new stable launcher revalidates")
vim.env.PATH = home .. "/project/.venv/bin:" .. home .. "/stable"
vim.env.VIRTUAL_ENV = home .. "/project/.venv"
mapping["pynvim-python"] = project_launcher
selected, count = start()
expect(selected == host and count == 0, "project pynvim launcher cannot bypass venv filter")
fresh("relative-path")
host = candidate("stable-python")
local project_python = file(home .. "/project/python3", "#!/bin/sh\nexit 0", true)
vim.cmd.cd(home .. "/project")
vim.env.PATH = ".:" .. home .. "/absolute"
file(home .. "/absolute/python3", "#!/bin/sh\nexit 0", true)
responses[home .. "/absolute/python3"] = responses[host]
mapping.python3 = project_python
selected, count = start()
expect(selected == host and count == 1, "relative PATH entry cannot become editor host")
fresh("dedicated-venv")
host = candidate("dedicated-host")
local dedicated = file(home .. "/editor-python/bin/python3", "#!/bin/sh\nexit 0", true)
file(home .. "/editor-python/pyvenv.cfg", "home = /fixture", false)
mapping.python3 = dedicated
responses[dedicated] = responses[host]
selected, count = start()
expect(selected == host and count == 1, "unactivated dedicated named venv remains discoverable")
fresh("home-venv")
host, module = candidate("venv")
file(home .. "/.venv/bin/python", "#!/bin/sh\nexit 0", true)
responses[home .. "/.venv/bin/python"] = responses[host]
selected, count = start()
expect(selected == host and count == 1, "HOME venv discovery")
fresh("uv")
host = candidate("managed")
mapping.python3 = candidate("without-pynvim")
responses[mapping.python3] = { code = 1, stdout = "" }
mapping.uv = file(home .. "/bin/uv", "#!/bin/sh\nexit 0", true)
responses[mapping.uv] = { code = 0, stdout = host .. "\n" }
selected, count = start()
expect(selected == host and count == 3, "uv fallback and validation")
selected, count = start()
expect(selected == host and count == 0, "uv cache hit without processes")
fresh("negative")
mapping.python3 = candidate("missing-package")
responses[mapping.python3] = { code = 1, stdout = "" }
selected, count = start()
expect(selected == nil and count == 1, "no invalid fallback host")
expect(vim.g.loaded_python3_provider == 0, "failed discovery suppresses builtin fallback")
expect(vim.g.python_provider_diagnostic == "not-found", "missing import has a diagnostic")
expect(#notifications == 1 and notifications[1]:find("pynvim", 1, true), "missing import warns with dependency reason")
selected, count = start()
expect(selected == nil and count == 0, "short negative cache")
expect(check.python_version() == "" and #calls == 0, "version honors negative cache")
vim.fn.has = function()
  error("unavailable provider must not invoke native detection, including force")
end
expect(check.python_version(true) == "", "force honors unavailable provider")
cache.update()
expect(vim.g.python_version == "", "manual refresh honors unavailable provider")
vim.fn.has = original_has
selected, count = start()
expect(selected == nil and count == 1, "manual refresh retries on next startup")
record(function(r)
  r.checked_at = os.time() - 61
end)
selected, count = start()
expect(selected == nil and count == 1, "negative cache expires")
host = candidate("new-launcher")
mapping["pynvim-python"] = host
selected, count = start()
expect(selected == host and count == 1, "later installation discovered")
fresh("empty-wrapper")
mapping.python3 = candidate("empty")
responses[mapping.python3] = { code = 0, stdout = "" }
selected, count = start()
expect(
  selected == nil and vim.g.python_provider_diagnostic == "not-found",
  "empty wrapper output is not a successful probe"
)
fresh("invalid-result")
mapping.python3 = candidate("nil-result")
responses[mapping.python3] = "nil"
selected, count = start()
expect(selected == nil and count == 1, "nil result cannot crash startup")
expect(vim.g.python_provider_diagnostic == "invalid-result", "failed probe diagnosed")
expect(#notifications == 0, "failure notification is once per real Neovim process")
fresh("timeout")
mapping.python3 = candidate("slow")
responses[mapping.python3] = "timeout"
local timeout_start = vim.uv.hrtime()
selected, count = start()
local elapsed = (vim.uv.hrtime() - timeout_start) / 1e6
expect(selected == nil and count == 1 and killed and elapsed < 2400, "single two-second deadline and kill")
expect(vim.g.python_provider_diagnostic == "timeout", "timeout distinguished from unavailable")
expect(#notifications == 0, "failure warning only once in this Neovim process")
selected, count = start()
expect(selected == nil and count == 0, "failed probe briefly cached")
record(function(r)
  r.checked_at = os.time() - 6
end)
responses[mapping.python3] = { code = 1, stdout = "" }
selected, count = start()
expect(selected == nil and count == 1, "failure cache expires after five seconds")
fresh("disabled")
mapping.python3 = candidate("unused-disabled")
setup()
vim.g.loaded_python3_provider = 0
vim.g.python3_host_prog = nil
basic.setup()
expect(#calls == 0 and vim.g.python_provider_unavailable, "user-disabled provider skips discovery")
fresh("malformed")
host = candidate("python3")
mapping.python3 = host
cache.set({ python_provider_cache_json = "not json" })
selected, count = start()
expect(selected == host and count == 1, "malformed JSON rediscovered")
cache.set({ python_provider_cache_json = '{"path":null,"module":1}' })
selected, count = start()
expect(selected == host and count == 1, "malformed record rediscovered")
fresh("local-override")
host = candidate("local")
file(home .. "/.vim_local.lua", "vim.g.python3_host_prog = " .. vim.inspect(host), false)
selected, count = start()
expect(selected == host and count == 0, "machine-local override wins")
fresh("platform")
os_name = "Darwin test"
mapping.python3 = candidate("unused")
selected, count = start()
expect(selected == nil and count == 0, "other platform retains native discovery")
os_name = "Linux synology test"
selected, count = start(mapping.python3)
expect(selected == mapping.python3 and count == 0, "Synology explicit host preserved")
local plugin_utils = require("vimrc.plugin_utils")
local kernel = plugin_utils.get_kernel_version
plugin_utils.get_kernel_version = function()
  return plugin_utils.KERNEL_VERSIONS.SYNOLOGY_DSM_7 + 1
end
selected, count = start()
expect(selected == "/bin/python3" and count == 0, "new DSM default preserved")
plugin_utils.get_kernel_version = function()
  return plugin_utils.KERNEL_VERSIONS.SYNOLOGY_DSM_7 - 1
end
selected, count = start()
expect(selected == "/usr/local/bin/python3" and count == 0, "old DSM default preserved")
plugin_utils.get_kernel_version = kernel
-- Run the actual probe against a disposable, offline venv with fixture modules.
fresh("real-probe")
local python = vim.fn.executable("/usr/bin/python3") == 1 and "/usr/bin/python3" or saved.exepath("python3")
vim.system = saved.system
local created = vim
  .system({ python, "-B", "-E", "-m", "venv", "--without-pip", home .. "/.venv" }, { text = true })
  :wait(10000)
expect(created and created.code == 0, "offline fixture venv created")
local site = vim.fn.glob(home .. "/.venv/lib/python*/site-packages")
file(home .. "/json.py", 'raise RuntimeError("HOME module must not shadow stdlib")', false)
local pynvim = file(site .. "/pynvim/__init__.py", "# offline probe fixture", false)
file(site .. "/neovim/__init__.py", "# offline probe fixture", false)
selected, count = start()
expect(selected == home .. "/.venv/bin/python", "actual probe selects interpreter")
expect(vim.g.python_version:match("^3%.%d+%.%d+$") ~= nil, "actual probe parses version")
vim.fn.delete(pynvim)
selected, count = start()
expect(selected == nil and vim.g.python_provider_unavailable, "actual import failure rejects provider")
-- Exercise the real private-group timeout used for subprocess-based launchers.
fresh("real-wrapper-timeout")
local pidfile = home .. "/child.pid"
local wrapper = file(
  home .. "/bin/python3",
  "#!/usr/bin/python3 -B\nimport subprocess\nchild = subprocess.Popen(['/usr/bin/python3', '-B', '-c', 'import time; time.sleep(30)'])\nopen("
    .. string.format("%q", pidfile)
    .. ", 'w').write(str(child.pid))\nchild.wait()",
  true
)
mapping.python3 = wrapper
local before_timeout = vim.uv.hrtime()
selected, count = start()
expect(selected == nil and (vim.uv.hrtime() - before_timeout) / 1e6 < 2500, "real wrapper timeout stays bounded")
expect(vim.g.python_provider_diagnostic == "timeout", "real wrapper timeout diagnosed")
local child_pid = tonumber(vim.fn.readfile(pidfile)[1])
local stopped = vim.wait(1000, function()
  if not vim.uv.fs_stat("/proc/" .. child_pid .. "/stat") then
    return true
  end
  local line = vim.fn.readfile("/proc/" .. child_pid .. "/stat")[1]
  return line:match("%)%s+(%a)") == "Z"
end, 10)
expect(stopped, "wrapper interpreter child has stopped after group kill")
vim.env.HOME, vim.system, vim.fn.exepath, vim.uv.os_gethostname =
  saved.home, saved.system, saved.exepath, saved.hostname
vim.env.PATH, vim.env.VIRTUAL_ENV, vim.env.CONDA_PREFIX = saved.path, saved.virtual_env, saved.conda
vim.fn.has, vim.notify = saved.has, saved.notify
local integration = vim.env.PYTHON_PROVIDER_TEST_HOST
if integration and integration ~= "" then
  vim.g.loaded_python3_provider = nil
  vim.g.python3_host_prog = integration
  vim.cmd("python3 import pynvim")
  vim.cmd('python3 vim.vars["provider_spec_rpc"] = "OK"')
  expect(vim.g.provider_spec_rpc == "OK", "real provider RPC")
end
local warm = {}
for i = 3, #samples do
  warm[#warm + 1] = samples[i]
end
table.sort(warm)
print(
  string.format(
    "PASS provider/cache: %d assertions; warm %.3f ms; RPC %s; fixtures %s",
    checks,
    (warm[6] + warm[7]) / 2,
    integration and "passed" or "not requested",
    root
  )
)
vim.cmd("qa!")
