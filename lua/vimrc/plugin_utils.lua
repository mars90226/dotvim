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

return plugin_utils
