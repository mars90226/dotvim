pcall(require, "impatient")

require("vimrc.profile").setup()

require("plug.config_cache").setup()
require("vimrc.basic").setup()
require("plug.basic").setup()
require("plug.plugin_choose").setup()

local auto_packer = require("plug.auto_packer")

-- Plugin Settings Begin
require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- TODO: Monitor if any plugins break by module resolution cache
  use("lewis6991/impatient.nvim")

  require("plug.mapx").startup(use)
  require("plug.appearance").startup(use)
  require("plug.lsp").startup(use)
  require("plug.completion").startup(use)
  require("plug.file_explorer").startup(use)
  require("plug.file_navigation").startup(use)
  require("plug.text_navigation").startup(use)
  require("plug.text_manipulcation").startup(use)
  require("plug.text_objects").startup(use)
  require("plug.languages").startup(use)
  require("plug.git").startup(use)
  require("plug.terminal").startup(use)
  require("plug.lua_dev").startup(use)
  require("plug.utility").startup(use)
  require("plug.last").startup(use)

  -- Compile config for performance
  require("core.plug.mapping").startup(use)
  require("core.plug.setting").startup(use)
  require("core.plug.filetype").startup(use)
  require("core.plug.syntax").startup(use)
  require("core.plug.digraph").startup(use)
  require("core.plug.float").startup(use)
  require("core.plug.terminal").startup(use)
  require("core.plug.autocmd").startup(use)
  require("core.plug.job").startup(use)
  require("core.plug.cli").startup(use)
  require("core.plug.tui").startup(use)
  require("core.plug.clipboard").startup(use)

  auto_packer.check_sync()
end)
