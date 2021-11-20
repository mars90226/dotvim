local file_explorer = {}

file_explorer.startup = function(use)
  use {
    'Shougo/defx.nvim',
    run = ':UpdateRemotePlugins',
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/defx.vim')
      vim.fn['vimrc#source']('vimrc/plugins/defx_after.vim')
    end
  }
  use 'kristijanhusak/defx-git'
  use 'kristijanhusak/defx-icons'

  -- TODO: Replace this
  use 'Shougo/neossh.vim'
end

return file_explorer
