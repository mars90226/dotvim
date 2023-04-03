pcall(require, "impatient")

require("vimrc.profile").setup()

-- Basic
require("plug.config_cache").setup()
require("vimrc.basic").setup()
require("plug.basic").setup()
require("plug.plugin_choose").setup()

-- Lazy
require("plug.auto_lazy").setup()
require("lazy").setup("plug.plugins")

-- Core
require("core.mapping").setup()
require("core.setting").setup()
require("core.filetype").setup()
require("core.syntax").setup()
require("core.digraph").setup()
require("core.float").setup()
require("core.terminal").setup()
require("core.autocmd").setup()
require("core.job").setup()
require("core.cli").setup()
require("core.tui").setup()
require("core.clipboard").setup()
require("core.termdebug").setup()
