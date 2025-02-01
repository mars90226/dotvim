local M = {}

-- Cached git version value.
local git_version = "not initialized"

--- Get the operating system.
--- @param force boolean? Optional: force re-detection.
--- @return string The detected OS.
function M.get_os(force)
  force = force or false
  -- Use vim.g.os as the cache.
  if force or not vim.g.os then
    if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
      vim.g.os = "windows"
    elseif vim.fn.has("mac") == 1 then
      vim.g.os = "mac"
    else
      local uname = vim.fn.systemlist("uname -a")
      vim.g.os = uname[1] or ""
    end
  end
  return vim.g.os
end

--- Check if the current operating system matches the given pattern.
--- @param target_os string The target operating system pattern to match.
--- @return boolean True if the current OS contains the pattern, false otherwise.
function M.os_is(target_os)
  local os = M.get_os()
  return string.match(os, target_os) ~= nil
end

--- Get the Linux distribution.
--- @param force boolean? Optional: force re-detection.
--- @return string The detected distro.
function M.get_distro(force)
  force = force or false
  if force or not vim.g.distro then
    if M.get_os():find("windows", 1, true) then
      vim.g.distro = "Windows"
    else
      local lsb = vim.fn.systemlist("lsb_release -is")
      vim.g.distro = lsb[1] or ""
    end
  end
  return vim.g.distro
end

--- Check if Neovim is running inside an nvim terminal.
--- @return boolean
function M.in_nvim_terminal()
  return vim.env.NVIM ~= ""
end

--- Get the Python version.
--- @param force boolean? Optional: force re-detection.
--- @return string The detected Python version (or empty if not found).
function M.python_version(force)
  force = force or false
  if force or not vim.g.python_version then
    local version = ""
    if vim.fn.has("python3") == 1 then
      version = vim.fn.execute("py3 import sys; print(sys.version)")
    elseif vim.fn.has("python") == 1 then
      version = vim.fn.execute("py import sys; print(sys.version)")
    end
    if version ~= "" then
      local parts = vim.split(version, "%s+")
      version = (parts[1] or ""):gsub("^\n", "")
    end
    vim.g.python_version = version
  end
  return vim.g.python_version
end

--- Check whether a Linux build environment is available.
--- @return boolean
function M.has_linux_build_env()
  local os = M.get_os()
  return not os:find("windows", 1, true) and not os:find("synology", 1, true)
end

--- Check if Cargo is available.
--- Relies on an existing `vimrc.plugin_utils.is_executable` function.
--- @return boolean
function M.has_cargo()
  return require("vimrc.plugin_utils").is_executable("cargo") and M.has_linux_build_env()
end

--- Get the git version.
--- Caches the result after the first call.
--- @return string
function M.git_version()
  if git_version == "not initialized" then
    local output = vim.fn.systemlist("git --version")
    git_version = output[1] or ""
    if vim.v.shell_error ~= 0 then
      git_version = "not installed"
    end
  end
  return git_version
end

--- Check if a browser is available.
--- Assumes Synology systems (matching "synology" in OS) have no browser.
--- @return boolean
function M.has_browser()
  return not M.get_os():find("synology", 1, true)
end

--- Check if there is an SSH client host.
--- @return boolean
function M.has_ssh_host_client()
  local host = vim.env.SSH_CLIENT_HOST or ""
  return host ~= ""
end

return M
