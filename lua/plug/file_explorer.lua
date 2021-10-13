local file_explorer = {}

file_explorer.startup = function(use)
  -- NOTE: Add :packadd for every Defx plugins as workaround of neovim nightly
  -- bug that doesn't load Defx properly.
  -- ref: https://github.com/Shougo/defx.nvim/issues/314

  use {
    'Shougo/defx.nvim',
    run = ':UpdateRemotePlugins',
    setup = function()
      vim.cmd [[packadd defx.nvim]]
    end,
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/defx.vim')
      vim.fn['vimrc#source']('vimrc/plugins/defx_after.vim')
    end
  }

  use {
      'kristijanhusak/defx-git',
      setup = function()
        vim.cmd [[packadd defx-git]]
      end
  }

  use {
      'kristijanhusak/defx-icons',
      setup = function()
        vim.cmd [[packadd defx-icons]]
      end
  }

  use 'Shougo/neossh.vim'
end

return file_explorer
