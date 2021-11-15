local utils = require('vimrc.utils')

local languages = {}

languages.startup = function(use)
  -- filetype
  use {
    'sheerun/vim-polyglot',
    disable = true,
    setup = function()
      -- Avoid conflict with vim-go, must after vim-go loaded
      vim.g.polyglot_disabled = {'go'}
    end
  }
  use {'leafo/moonscript-vim', ft = {'moon'}}
  use {
    'plasticboy/vim-markdown',
    ft = { 'markdown' },
    require = { 'godlygeek/tabular' }
  }

  -- Highlighing
  -- nvim-treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/nvim_treesitter.vim')
      require('vimrc.plugins.nvim_treesitter')
    end
    }
  use 'nvim-treesitter/nvim-treesitter-refactor'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'nvim-treesitter/playground'
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use 'mfussenegger/nvim-ts-hint-textobject'
  use 'RRethy/nvim-treesitter-textsubjects'

  use 'jackguo380/vim-lsp-cxx-highlight'

  -- Context
  use {
    'romgrk/nvim-treesitter-context',
    config = function()
      nnoremap('<F6>', ':TSContextToggle<CR>')
    end
  }

  use {
    'mattn/emmet-vim',
    event = {'FocusLost', 'CursorHold', 'CursorHoldI'},
    config = function()
      vim.g.user_emmet_leader_key = '<C-E>'
    end
  }

  use {
    'mars90226/cscope_macros.vim',
    keys = {'<F11>', '<Space><F11>'},
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/cscope.vim')
    end
  }

  -- Lint
  use {
    'w0rp/ale',
    disable = true,
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/ale.vim')
    end
  }

  -- Markdown preview
  -- FIXME: Seems not correctly installed using packer.nvim
  use {
    'euclio/vim-markdown-composer',
    ft = {'markdown'},
    run = 'cargo build --release',
    config = function()
      -- Manually execute :ComposerStart instead
      vim.g.markdown_composer_autostart = 0
    end
  }

  use {
    'fatih/vim-go',
    ft = {'go'},
    run = ':GoUpdateBinaries',
    config = function()
      vim.g.go_decls_mode = 'fzf'

      -- TODO Add key mappings for vim-go commands
    end
  }

  use {
    'rhysd/rust-doc.vim',
    ft = {'rust'},
    config = function()
      vim.g['rust_doc#define_map_K'] = 0
      vim.g['rust_doc#vim_open_cmd'] = 'RustDocOpen'

      vim.cmd [[command! -nargs=1 RustDocOpen call vimrc#rust_doc#open(<f-args>)]]
    end
  }

  use {
    'apeschel/vim-syntax-syslog-ng',
    config = function()
      vim.cmd [[augroup vim_syntax_syslog_ng_settings]]
      vim.cmd [[autocmd!]]
      vim.cmd [[autocmd BufNewFile,BufReadPost syslog-ng.conf       setlocal filetype=syslog-ng]]
      vim.cmd [[autocmd BufNewFile,BufReadPost syslog-ng/*/*.conf   setlocal filetype=syslog-ng]]
      vim.cmd [[autocmd BufNewFile,BufReadPost patterndb.d/*.conf   setlocal filetype=syslog-ng]]
      vim.cmd [[autocmd BufNewFile,BufReadPost patterndb.d/*/*.conf setlocal filetype=syslog-ng]]
      vim.cmd [[augroup END]]
    end
  }

  use {
    'kkoomen/vim-doge',
    run = function() vim.fn['doge#install']() end,
    cmd = {'DogeGenerate', 'DogeCreateDocStandard'},
    keys = {'<Leader><Leader>d'},
    config = function()
      vim.g.doge_mapping = '<Leader><Leader>d'
    end
  }

  use {'rust-lang/rust.vim', ft = {'rust'}}
  use {'mars90226/perldoc-vim', ft = {'perl'}}
  use {'fs111/pydoc.vim', ft = {'python'}}
end

return languages
