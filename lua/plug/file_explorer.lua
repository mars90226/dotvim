local file_explorer = {}

file_explorer.startup = function(use)
  -- NOTE: Add :packadd for every Defx plugins as workaround of neovim nightly
  -- bug that doesn't load Defx properly.
  -- ref: https://github.com/Shougo/defx.nvim/issues/314

  vim.cmd [[packadd defx.nvim]]
  use {
    'Shougo/defx.nvim',
    run = function() vim.cmd [[UpdateRemotePlugins]] end,
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/defx.vim')
      vim.fn['vimrc#source']('vimrc/plugins/defx_after.vim')
    end
  }

  vim.cmd [[packadd defx-git]]
  use 'kristijanhusak/defx-git'

  vim.cmd [[packadd defx-icons]]
  use 'kristijanhusak/defx-icons'

  use 'Shougo/neossh.vim'
end

return file_explorer
