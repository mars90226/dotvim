local my_config_cache = require("vimrc.config_cache")

local config_cache = {}

config_cache.setup = function()
  vim.cmd([[command! UpdateConfigCache lua require('vimrc.config_cache').update()]])

  my_config_cache.init(require("vimrc.config_snapshot").collect)
  my_config_cache.read()
  require("vimrc.plugin_utils").is_executable_cache =
    vim.json.decode(my_config_cache.get("is_executable_cache_json") or "{}")
end

return config_cache
