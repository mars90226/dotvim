require("vimrc.profile").setup()

-- Basic
require("plug.config_cache").setup()
require("vimrc.basic").setup()
require("plug.basic").setup()
require("plug.plugin_choose").setup()

-- Lazy
require("plug.auto_lazy").setup()
-- TODO: Move config to lazy.lua
require("lazy").setup("plug.plugins", {
  change_detection = {
    notify = false, -- avoid loads of notification when changing config
  },
  ui = {
    border = "single",
  }
})
-- NOTE: Seems not work in lazy.nvim's config callback
require("vimrc.plugins.lazy").setup()

-- Core
require("core").setup()
