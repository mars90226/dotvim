require("vimrc.profile")

vim.fn["vimrc#source"]("plug/plugin_config_cache.vim")
vim.fn["vimrc#source"]("vimrc/basic.vim")
vim.fn["vimrc#source"]("vimrc/config.vim")
vim.fn["vimrc#source"]("plug/plugin_choose.vim")

local auto_packer = require("plug.auto_packer")

-- Plugin Settings Begin
require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- Mapping utility
  use("b0o/mapx.nvim")
  local mapx = require("mapx")
  if mapx.globalized ~= true then
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

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if auto_packer.packer_bootstrap ~= nil then
    require("packer").sync()
  end
end)

require("vimrc.mapping").setup()

vim.fn["vimrc#source"]("vimrc/settings.vim")
vim.fn["vimrc#source"]("vimrc/indent.vim")
vim.fn["vimrc#source"]("vimrc/search.vim")
vim.fn["vimrc#source"]("vimrc/syntax.vim")
vim.fn["vimrc#source"]("vimrc/digraphs.vim")
vim.fn["vimrc#source"]("vimrc/mappings.vim")
vim.fn["vimrc#source"]("vimrc/float.vim")
vim.fn["vimrc#source"]("vimrc/terminal.vim")
vim.fn["vimrc#source"]("vimrc/autocmd.vim")
vim.fn["vimrc#source"]("vimrc/workaround.vim")
