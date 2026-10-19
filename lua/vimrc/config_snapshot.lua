local check = require("vimrc.check")
local plugin_utils = require("vimrc.plugin_utils")

local snapshot = {}

-- Application values for the existing config snapshot, including manual refresh.
snapshot.collect = function(initializing)
  local os = check.get_os(true)
  local distro = check.get_distro(true)
  -- Select a host before the first provider/version query on a new machine.
  local version = initializing and (vim.g.python_version or "") or check.python_version(true)
  return {
    os = os,
    distro = distro,
    python_version = version,
    python_version_host = vim.g.python_version_host or "",
    is_executable_cache_json = vim.json.encode(plugin_utils.is_executable_cache or {}),
    -- A manual snapshot refresh invalidates discovery for the next startup.
    python_provider_cache_json = "{}",
  }
end

return snapshot
