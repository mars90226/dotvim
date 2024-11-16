local choose = require("vimrc.choose")
local utils = require("vimrc.utils")

local plugin_utils = {}

plugin_utils.is_executable_cache = {}

-- Utils
plugin_utils.check_condition = function(plugin_spec, condition, default)
  if condition then
    return plugin_spec
  else
    return default
  end
end

plugin_utils.source = function(path)
  vim.cmd('source ' .. path)
end

plugin_utils.source_in_vim_home = function(path)
  plugin_utils.source(utils.get_vim_home() .. "/" .. path)
end

-- Plugin check
plugin_utils.is_executable = function(executable)
  -- NOTE: Cannot update vim global variables here (vim.g) due to neovim's limitation?
  -- Use lua local variable instead
  if plugin_utils.is_executable_cache[executable] == nil then
    plugin_utils.is_executable_cache[executable] = vim.fn.executable(executable) == 1
  end
  return plugin_utils.is_executable_cache[executable]
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

plugin_utils.check_enabled_plugin = function(plugin_spec, plugin, default)
  return plugin_utils.check_condition(plugin_spec, choose.is_enabled_plugin(plugin), default)
end

plugin_utils.check_executable = function(plugin_spec, executable, default)
  return plugin_utils.check_condition(plugin_spec, plugin_utils.is_executable(executable), default)
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

plugin_utils.get_dictionary = function()
  if vim.g.loaded_dictionary then
    return vim.g.dictionary_path
  end

  local dictionary_path = "/usr/share/dict/words"
  vim.g.dictionary_path = plugin_utils.file_readable(dictionary_path) and dictionary_path or nil
  return vim.g.dictionary_path
end

plugin_utils.KERNEL_VERSIONS = {
  SYNOLOGY_DSM_7 = 40000
}

return plugin_utils
