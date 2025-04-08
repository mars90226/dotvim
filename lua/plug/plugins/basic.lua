local secret = require("vimrc.secret")
local plugin_utils = require("vimrc.plugin_utils")

local basic = vim.tbl_filter(function(plugin_spec)
  return plugin_spec ~= nil
end, {
  {
    "folke/lazy.nvim",
    priority = 10000,
  },
  plugin_utils.check_condition({
    dir = secret.config.dir,
    lazy = false,
    priority = 1001,
  }, secret.is_enabled()),
})

return basic
