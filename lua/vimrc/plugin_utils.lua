local plugin_utils = {}

-- Utils
plugin_utils.check_condition = function(plugin_spec, condition)
  if condition then
    return plugin_spec
  else
    return nil
  end
end

-- For builtin plugin
plugin_utils.builtin_installer = function(_)
  local async = require("packer.async").sync
  local result = require("packer.result")

  return async(function()
    return result.ok()
  end)
end

plugin_utils.builtin_updater = function(_)
  local async = require("packer.async").sync
  local result = require("packer.result")

  return async(function()
    return result.ok()
  end)
end

plugin_utils.use_builtin = function(use, plugin_spec)
  plugin_spec.url = "" -- FIXME: According to document, this is not needed
  plugin_spec.installer = plugin_utils.builtin_installer
  plugin_spec.updater = plugin_utils.builtin_updater

  use(plugin_spec)
end

plugin_utils.config_installer = plugin_utils.builtin_installer
plugin_utils.config_updater = plugin_utils.builtin_updater

plugin_utils.use_config = function(use, plugin_spec)
  plugin_spec.url = "" -- FIXME: According to document, this is not needed
  plugin_spec.installer = plugin_utils.config_installer
  plugin_spec.updater = plugin_utils.config_updater

  use(plugin_spec)
end

-- Plugin check
plugin_utils.is_enabled_plugin = function(plugin)
  -- TODO: rewrite in Lua
  return vim.fn["vimrc#plugin#is_enabled_plugin"](plugin) == 1
end

plugin_utils.is_executable = function(executable)
  return vim.fn.executable(executable) > 0
end

plugin_utils.file_readable = function(file)
  return vim.fn.filereadable(file) > 0
end

plugin_utils.get_os = function()
  return vim.fn["vimrc#plugin#check#get_os"]()
end

plugin_utils.has_linux_build_env = function()
  return vim.fn["vimrc#plugin#check#has_linux_build_env"]() == 1
end

plugin_utils.check_enabled_plugin = function(plugin_spec, plugin)
  return plugin_utils.check_condition(plugin_spec, plugin_utils.is_enabled_plugin(plugin))
end

plugin_utils.check_executable = function(plugin_spec, executable)
  return plugin_utils.check_condition(plugin_spec, plugin_utils.is_executable(executable))
end

return plugin_utils
