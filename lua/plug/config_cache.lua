local my_config_cache = require("vimrc.config_cache")

local config_cache = {}

config_cache.setup = function()
  vim.cmd([[command! UpdateConfigCache lua require('vimrc.config_cache').update()]])

  my_config_cache.init()
  my_config_cache.read()
end

return config_cache
