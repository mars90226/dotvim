require("vimrc.profile").setup()

-- Basic
require("plug.config_cache").setup()
require("vimrc.basic").setup()
require("plug.basic").setup()
require("plug.plugin_choose").setup()

-- Lazy
require("plug.auto_lazy").setup()
require("vimrc.plugins.lazy").setup()

-- Core
require("core").setup()
