local my_plugin_config_cache = require("vimrc.plugin_config_cache")

local plugin_config_cache = {}

plugin_config_cache.setup = function()
  vim.cmd([[command! UpdatePluginConfigCache lua require('vimrc.plugin_config_cache').update()]])

  my_plugin_config_cache.init()
  my_plugin_config_cache.read()
end

return plugin_config_cache
