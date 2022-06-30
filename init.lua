require("vimrc.profile").setup()

vim.fn["vimrc#source"]("plug/plugin_config_cache.vim")
vim.fn["vimrc#source"]("vimrc/basic.vim")
vim.fn["vimrc#source"]("plug/plugin_choose.vim")

local auto_packer = require("plug.auto_packer")

-- Plugin Settings Begin
require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- TODO: Monitor if any plugins break by module resolution cache
  use("lewis6991/impatient.nvim")

  -- Mapping utility
  use("b0o/mapx.nvim")
  local has_mapx, mapx = pcall(require, "mapx")
  if has_mapx and mapx.globalized ~= true then
    mapx.setup({ global = true })
  end

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
  require("plug.job").startup(use)
  require("plug.cli").startup(use)
  require("plug.tui").startup(use)
  require("plug.clipboard").startup(use)
  require("plug.last").startup(use)

  auto_packer.check_sync()
end)

require("vimrc.mapping").setup()

vim.fn["vimrc#source"]("vimrc/settings.vim")
require("vimrc.filetype").setup()
require("vimrc.syntax").setup()
require("vimrc.diagraphs").setup()
vim.fn["vimrc#source"]("vimrc/mappings.vim")
require("vimrc.float").setup()
vim.fn["vimrc#source"]("vimrc/terminal.vim")
vim.fn["vimrc#source"]("vimrc/autocmd.vim")
