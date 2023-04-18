local choose = {}

choose.disabled_plugins = {}

choose.disable_plugin = function(plugin)
  if choose.disabled_plugins[plugin] == nil then
    choose.disabled_plugins[plugin] = true
  end
end

choose.disable_plugins = function(plugins)
  for _, plugin in ipairs(plugins) do
    choose.disable_plugin(plugin)
  end
end

choose.enable_plugin = function(plugin)
  choose.disabled_plugins[plugin] = nil
end

choose.clear_disabled_plugins = function()
  choose.disabled_plugins = {}
end

choose.is_disabled_plugin = function(plugin)
  return choose.disabled_plugins[plugin] ~= nil
end

choose.is_enabled_plugin = function(plugin)
  return choose.disabled_plugins[plugin] == nil
end

choose.print_disabled_plugins = function()
  vim.print(choose.disabled_plugins)
end

return choose
