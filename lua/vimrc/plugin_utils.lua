local choose = require("vimrc.choose")

local plugin_utils = {}

-- Utils
plugin_utils.check_condition = function(plugin_spec, condition)
  if condition then
    return plugin_spec
  else
    return nil
  end
end

plugin_utils.source = function(path)
  vim.cmd('source ' .. path)
end

-- Plugin check
plugin_utils.is_executable = function(executable)
  return vim.fn.executable(executable) > 0
end

plugin_utils.file_readable = function(file)
  return vim.fn.filereadable(file) > 0
end

plugin_utils.get_os = function()
  return vim.fn["vimrc#plugin#check#get_os"]()
end

plugin_utils.os_is = function(target_os)
  local os = plugin_utils.get_os()

  return string.match(os, target_os) ~= nil
end

plugin_utils.get_kernel_version = function()
  local os = plugin_utils.get_os()
  local kernel_version = string.sub(string.match(os, "#%d+"), 2)

  return tonumber(kernel_version)
end

plugin_utils.has_linux_build_env = function()
  return vim.fn["vimrc#plugin#check#has_linux_build_env"]() == 1
end

plugin_utils.check_enabled_plugin = function(plugin_spec, plugin)
  return plugin_utils.check_condition(plugin_spec, choose.is_enabled_plugin(plugin))
end

plugin_utils.check_executable = function(plugin_spec, executable)
  return plugin_utils.check_condition(plugin_spec, plugin_utils.is_executable(executable))
end

plugin_utils.has_ssh_host_client = function()
  return vim.fn["vimrc#plugin#check#has_ssh_host_client"]() == 1
end

plugin_utils.has_browser = function()
  return vim.fn["vimrc#plugin#check#has_browser"]() == 1
end

plugin_utils.get_browser = function()
  if plugin_utils.is_executable("open_url.sh") then
    return "open_url.sh"
  elseif plugin_utils.has_ssh_host_client() then
    return "client_open_browser"
  else
    return "system"
  end
end

plugin_utils.KERNEL_VERSIONS = {
  SYNOLOGY_DSM_7 = 40000
}

return plugin_utils
