-- Profile {{{
-- Disabled by default, enable to profile
-- vim.cmd [[profile start /tmp/profile.log]]
-- vim.cmd [[profile file *]]
-- vim.cmd [[profile func *]]
-- }}}

vim.fn['vimrc#source']('plug/plugin_config_cache.vim')
vim.fn['vimrc#source']('vimrc/basic.vim')
vim.fn['vimrc#source']('vimrc/config.vim')
vim.fn['vimrc#source']('plug/plugin_choose.vim')

local packer_bootstrap = require('plug.auto_packer')

-- Plugin Settings Begin
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  -- if packer_bootstrap then
  --   require('packer').sync()
  -- end
end)

-- vim.fn['vimrc#source']('plug/appearance.vim')
-- vim.fn['vimrc#source']('plug/completion.vim')
-- vim.fn['vimrc#source']('plug/file_explorer.vim')
-- vim.fn['vimrc#source']('plug/file_navigation.vim')
-- vim.fn['vimrc#source']('plug/text_navigation.vim')
-- vim.fn['vimrc#source']('plug/text_manipulation.vim')
-- vim.fn['vimrc#source']('plug/text_objects.vim')
-- vim.fn['vimrc#source']('plug/languages.vim')
-- vim.fn['vimrc#source']('plug/git.vim')
-- vim.fn['vimrc#source']('plug/terminal.vim')
-- vim.fn['vimrc#source']('plug/utility.vim')
-- vim.fn['vimrc#source']('plug/last.vim')

-- Post-loaded Plugin Settings
-- vim.fn['vimrc#source']('plug/after.vim')

vim.fn['vimrc#source']('vimrc/settings.vim')
vim.fn['vimrc#source']('vimrc/indent.vim')
vim.fn['vimrc#source']('vimrc/search.vim')
vim.fn['vimrc#source']('vimrc/syntax.vim')
vim.fn['vimrc#source']('vimrc/digraphs.vim')
vim.fn['vimrc#source']('vimrc/mappings.vim')
vim.fn['vimrc#source']('vimrc/float.vim')
vim.fn['vimrc#source']('vimrc/job.vim')
vim.fn['vimrc#source']('vimrc/terminal.vim')
vim.fn['vimrc#source']('vimrc/tui.vim')
vim.fn['vimrc#source']('vimrc/termdebug.vim')
vim.fn['vimrc#source']('vimrc/autocmd.vim')
vim.fn['vimrc#source']('vimrc/workaround.vim')
