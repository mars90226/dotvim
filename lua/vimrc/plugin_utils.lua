local plugin_utils = {}

plugin_utils.check_condition = function(plugin_spec, condition)
  if condition then
    return plugin_spec
  else
    return nil
  end
end

-- For builtin plugin
plugin_utils.builtin_installer = function(_)
  local async = require('packer.async').sync
  local result = require('packer.result')

  return async(function()
    return result.ok()
  end)
end

plugin_utils.builtin_updater = function(_)
  local async = require('packer.async').sync
  local result = require('packer.result')

  return async(function()
    return result.ok()
  end)
end

plugin_utils.use_builtin = function(use, plugin_spec)
  plugin_spec.url = '' -- FIXME: According to document, this is not needed
  plugin_spec.installer = plugin_utils.builtin_installer
  plugin_spec.updater = plugin_utils.builtin_updater

  use(plugin_spec)
end

plugin_utils.config_installer = plugin_utils.builtin_installer
plugin_utils.config_updater = plugin_utils.builtin_updater

plugin_utils.use_config = function(use, plugin_spec)
  plugin_spec.url = '' -- FIXME: According to document, this is not needed
  plugin_spec.installer = plugin_utils.config_installer
  plugin_spec.updater = plugin_utils.config_updater

  use(plugin_spec)
end

return plugin_utils
