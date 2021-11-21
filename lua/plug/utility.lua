local plugin_utils = require('vimrc.plugin_utils')
local utils = require('vimrc.utils')

local utility = {}

utility.startup = function(use)
  local use_builtin = function(plugin_spec)
    plugin_utils.use_builtin(use, plugin_spec)
  end

  -- Undo Tree
  use {
    'mbbill/undotree',
    cmd = {'UndotreeToggle'},
    keys = {'<F9>'},
    config = function()
      nnoremap('<F9>', ':UndotreeToggle<CR>')
    end
  }
  -- NOTE: vim-mundo is slow, but featureful
  use {
    'simnalamburt/vim-mundo',
    cmd = {'MundoToggle'},
    keys = {'<Space><F9>'},
    config = function()
      if vim.fn.has('python3') == 1 then
        vim.g.mundo_prefer_python3 = 1
      end

      nnoremap('<Space><F9>', ':MundoToggle<CR>')
    end
  }

  use {
    'tpope/vim-unimpaired',
    event = {'FocusLost', 'CursorHold', 'CursorHoldI'},
    config = function()
      -- Ignore [a, ]a, [A, ]A for ale
      vim.g.nremap = {['[a'] = '', [']a'] = '', ['[A'] = '', [']A'] = ''}

      nnoremap([[\[a]],  ':previous<CR>')
      nnoremap([[\]a]],  ':next<CR>')
      nnoremap([[\[A]],  ':first<CR>')
      nnoremap([[\]A]],  ':last<CR>')

      nmap([[\[u]],  '<Plug>unimpaired_url_encode')
      nmap([[\[uu]], '<Plug>unimpaired_line_url_encode')
      nmap([[\]u]],  '<Plug>unimpaired_url_decode')
      nmap([[\]uu]], '<Plug>unimpaired_line_url_decode')

      nnoremap('coc', ':set termguicolors!<CR>')
      nnoremap('coe', ':set expandtab!<CR>')
      nnoremap('com', ':set modifiable!<CR>')
      nnoremap('coo', ':set readonly!<CR>')
      nnoremap('cop', ':set paste!<CR>')
      nnoremap('yoa', ':setlocal autoread!<CR>')
    end
  }

  use {
    'tpope/vim-characterize',
    key = {'gA'},
    config = function()
      nmap('gA', '<Plug>(characterize)')
    end
  }

  -- Registers
  use 'tversteeg/registers.nvim'

  use {
    'gu-fan/colorv.vim',
    cmd = {'ColorV', 'ColorVName', 'ColorVView'},
    keys = {'<Leader>vv', '<Leader>vn', '<Leader>vw'},
    requires = { 'mattn/webapi-vim' },
    config = function()
      nnoremap('<Leader>vv', ':ColorV<CR>', 'silent')
      nnoremap('<Leader>vn', ':ColorVName<CR>', 'silent')
      nnoremap('<Leader>vw', ':ColorVView<CR>', 'silent')
    end
  }

  use {
    'airblade/vim-rooter',
    cmd = {'Rooter'},
    keys = {'<Leader>r'},
    config = function()
      vim.g.rooter_manual_only = 1
      vim.g.rooter_cd_cmd = 'lcd'
      vim.g.rooter_patterns = {'Cargo.toml', '.git/', 'package.json'}

      nnoremap('<Leader>r', ':Rooter<CR>')
    end
  }

  -- Note Taking
  use {
    'vimwiki/vimwiki',
    branch = 'dev',
    ft = {'vimwiki'},
    setup = function()
      vim.cmd [[augroup vimwiki_filetypedetect]]
      vim.cmd [[  autocmd!]]
      vim.cmd [[  autocmd BufRead,BufNewFile *.wiki setfiletype vimwiki]]
      vim.cmd [[augroup END]]
    end,
    config = function()
      -- disable vimwiki on markdown file
      vim.g.vimwiki_ext2syntax = { ['.wiki'] = 'default' }
      -- disable <Tab> & <S-Tab> mappings in insert mode
      vim.g.vimwiki_key_mappings = {
        lists_return = 1,
        table_mappings = 0,
      }
      -- Toggle after vim
      vim.g.vimwiki_folding = 'expr:quick'

      vim.cmd [[command! VimwikiToggleFolding    call vimrc#vimwiki#toggle_folding()]]
      vim.cmd [[command! VimwikiToggleAllFolding call vimrc#vimwiki#toggle_all_folding()]]
      vim.cmd [[command! VimwikiManualFolding    call vimrc#vimwiki#manual_folding()]]
      vim.cmd [[command! VimwikiManualAllFolding call vimrc#vimwiki#manual_all_folding()]]
      vim.cmd [[command! VimwikiExprFolding      call vimrc#vimwiki#expr_folding()]]
      vim.cmd [[command! VimwikiExprAllFolding   call vimrc#vimwiki#expr_all_folding()]]

      vim.cmd [[augroup vimwiki_settings]]
      vim.cmd [[  autocmd!]]
      vim.cmd [[  autocmd FileType vimwiki call vimrc#vimwiki#settings()]]
      vim.cmd [[  autocmd FileType vimwiki call vimrc#vimwiki#mappings()]]
      vim.cmd [[  autocmd VimEnter *.wiki  VimwikiManualAllFolding]]
      vim.cmd [[augroup END]]
    end
  }

  use {
    'nvim-neorg/neorg',
    ft = {'org'},
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('neorg').setup {
        -- Tell Neorg what modules to load
        load = {
          ["core.defaults"] = {}, -- Load all the default modules
          ["core.norg.concealer"] = {}, -- Allows for use of icons
          ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
              workspaces = {
                my_workspace = "~/neorg"
              }
            }
          }
        },
      }
    end
  }

  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      -- Currently, there's no way to differentiate tab and space.
      -- The only way to differentiate is to disable indent-blankline.nvim
      -- temporarily.
      nnoremap('<Space>il', ':IndentBlanklineToggle<CR>')
      nnoremap('<Space>ir', ':IndentBlanklineRefresh<CR>')

      require('vimrc.plugins.indent_blankline')
    end
  }

  use {
    'powerman/vim-plugin-AnsiEsc',
    cmd = {'AnsiEsc'},
    keys = {'coa'},
    config = function()
      nnoremap('coa', ':AnsiEsc<CR>')
    end
  }

  use {
    'farmergreg/vim-lastplace',
    config = function()
      vim.g.lastplace_ignore = 'gitcommit,gitrebase,sv,hgcommit'
      vim.g.lastplace_ignore_buftype = 'quickfix,nofile,help,terminal'
      vim.g.lastplace_open_folds = 0
    end
  }

  use {
    'embear/vim-localvimrc',
    config = function()
      -- NOTE: Avoid lazy load error with upvalues (captured values)
      local utils = require('vimrc.utils')

      -- Be careful of malicious localvimrc
      vim.g.localvimrc_sandbox = 0

      vim.g.localvimrc_whitelist = {vim.env.HOME..'/.vim', vim.env.HOME..'/.tmux', vim.env.HOME..'/test'}

      if vim.g.localvimrc_secret_whitelist ~= nil then
        vim.g.localvimrc_whitelist = utils.table_concat(vim.g.localvimrc_whitelist, vim.g.localvimrc_secret_whitelist)
      end

      if vim.g.localvimrc_local_whitelist ~= nil then
        vim.g.localvimrc_whitelist = utils.table_concat(vim.g.localvimrc_whitelist, vim.g.localvimrc_local_whitelist)
      end
    end
  }

  use { 'kevinhwang91/nvim-bqf', ft = {'qf'} }

  use {
    'thinca/vim-qfreplace',
    ft = {'qf'},
    config = function()
      vim.cmd [[augroup qfreplace_settings]]
      vim.cmd [[  autocmd!]]
      vim.cmd [[  autocmd FileType qf call vimrc#qfreplace#mappings()]]
      vim.cmd [[augroup END]]
    end
  }

  use {
    'romainl/vim-qf',
    ft = {'qf'},
    config = function()
      -- Don't auto open quickfix list because it make vim-dispatch not able to
      -- restore 'makeprg' after make.
      -- https://github.com/tpope/vim-dispatch/issues/254
      vim.g.qf_auto_open_quickfix = 0
    end
  }

  use {'arthurxavierx/vim-caser', event = {'FocusLost', 'CursorHold', 'CursorHoldI'}}

  use {
    'machakann/vim-highlightedyank',
    config = function()
      vim.g.highlightedyank_highlight_duration = 200
    end
  }

  -- Focus
  use {
    'Pocco81/TrueZen.nvim',
    cmd = {'TZAtaraxis', 'TZFocus', 'TZMinimalist'},
    keys = {'<Leader>za', '<Leader>zc', '<Leader>zm'},
    config = function()
      nnoremap('<Leader>za', [[<Cmd>TZAtaraxis<CR>]])
      nnoremap('<Leader>zc', [[<Cmd>TZFocus<CR>]])
      nnoremap('<Leader>zm', [[<Cmd>TZMinimalist<CR>]])
    end
  }

  use {
    "folke/twilight.nvim",
    cmd = {'Twilight'},
    keys = {'<Leader><C-L>'},
    config = function()
      require("twilight").setup {}

      nnoremap('<Leader><C-L>', ':Twilight<CR>')
    end
  }

  use {
    'tpope/vim-dispatch',
    event = {'FocusLost', 'CursorHold', 'CursorHoldI'},
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/dispatch.vim')
    end
  }

  -- See https://www.reddit.com/r/vim/comments/bwp7q3/code_execution_vulnerability_in_vim_811365_and/
  -- and https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md for more details
  use 'ciaranm/securemodelines'

  -- Do not lazy load vim-scriptease, as it breaks :Breakadd/:Breakdel
  -- TODO: Check if lazy load works
  use {
    'tpope/vim-scriptease',
    cmd = {'PP', 'Messages', 'Verbose', 'Time'}
  }

  use 'tyru/open-browser.vim'

  use {
    'glacambre/firenvim',
    disable = true,
    run = function() vim.fn['firenvim#install'](0) end
  }

  -- Colorizer
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      vim.go.termguicolors = true

      require'colorizer'.setup()
    end
  }

  use {
    'lambdalisue/suda.vim',
    cmd = {'Suda'},
    setup = function()
      vim.cmd [[command! Suda edit suda://%]]
    end
  }

  use {
    'simeji/winresizer',
    cmd = {'WinResizerStartResize'},
    keys = {'<Leader>R'},
    setup = function()
      vim.g.winresizer_start_key = '<Leader>R'
    end
  }

  use {
    'folke/todo-comments.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    cmd = {'TodoQuickFix', 'TodoLocList', 'TodoTrouble', 'TodoTelescope'},
    keys = {'<F8>', '<Space><F8>'},
    config = function()
      require("todo-comments").setup {}

      nnoremap('<F8>', '<Cmd>TodoTrouble<CR>')
      nnoremap('<Space><F8>', '<Cmd>TodoTelescope<CR>')
    end
  }

  -- FIXME: Show error when using execute() with :GFiles -co --exclude-standard in Defx
  use {'winston0410/cmd-parser.nvim', disable = true}
  use {
    'winston0410/range-highlight.nvim',
    disable = true,
    require = { 'winston0410/cmd-parser.nvim' },
    config = function()
      require'range-highlight'.setup{}
    end
  }

  -- FIXME: Make fugitive commit move to wrong window
  use {
    'luukvbaal/stabilize.nvim',
    disable = true,
    config = function()
      require('stabilize').setup()
    end
  }

  use {
    'antoinemadec/FixCursorHold.nvim',
    config = function()
      vim.go.updatetime = 4000 -- default
      vim.g.cursorhold_updatetime = 300
    end
  }

  -- Disabled by default, enable to profile
  -- Plug 'norcalli/profiler.nvim'

  use {'tpope/vim-dadbod', cmd = {'DB'}}
  use {'tpope/vim-abolish', cmd = {'Abolish', 'Subvert', 'S'}}
  use {'will133/vim-dirdiff', cmd = {'DirDiff'}}
  use {'AndrewRadev/linediff.vim', cmd = {'Linediff'}}
  use {'Shougo/vinarise.vim', cmd = {'Vinarise'}}
  use {'alx741/vinfo', cmd = {'Vinfo'}}
  use 'kopischke/vim-fetch'
  use {
    'Valloric/ListToggle',
    cmd = {'QToggle', 'LToggle'},
    keys = {'<Leader>q', '<Leader>l'}
  }
  use 'tpope/vim-eunuch'
  use {'DougBeney/pickachu', cmd = {'Pick'}}
  use {'tweekmonster/helpful.vim', cmd = {'HelpfulVersion'}}
  use {'tweekmonster/startuptime.vim', cmd = {'StartupTime'}}
  use {
    'gyim/vim-boxdraw',
    keys = {'+o', '+O', '+c', '+-', '+_'}
  }
  use 'lambdalisue/reword.vim'
  use {
    'lpinilla/vim-codepainter',
    keys = {'<F2>', '<F3>'},
  }
  use {'nicwest/vim-http', cmd = {'Http', 'Http!'}}
  use {'kristijanhusak/vim-carbon-now-sh', cmd = {'CarbonNowSh'}}

  -- builtin Termdebug plugin
  use_builtin {
    'neovim/termdebug',
    cmd = {'Termdebug', 'TermdebugCommand'},
    config = function()
      -- Mappings
      nnoremap('<Leader>dd', [[:Termdebug<Space>]])
      nnoremap('<Leader>dD', [[:TermdebugCommand<Space>]])

      nnoremap('<Leader>dr', [[:Run<Space>]])
      nnoremap('<Leader>da', [[:Arguments<Space>]])

      nnoremap('<Leader>db', [[<Cmd>Break<CR>]])
      nnoremap('<Leader>dC', [[<Cmd>Clear<CR>]])

      nnoremap('<Leader>ds', [[<Cmd>Step<CR>]])
      nnoremap('<Leader>do', [[<Cmd>Over<CR>]])
      nnoremap('<Leader>df', [[<Cmd>Finish<CR>]])
      nnoremap('<Leader>dc', [[<Cmd>Continue<CR>]])
      nnoremap('<Leader>dS', [[<Cmd>Stop<CR>]])

      -- `:Evaluate` evaluate cursor variable and show result in floating window
      -- which may not be large enough to contain all result
      nnoremap('<Leader>de', [[:Evaluate<Space>]])
      xnoremap('<Leader>de', [[<Cmd>Evaluate]])
      -- `:Evaluate variable` show result in echo
      nnoremap('<Leader>dk', [[<Cmd>execute 'Evaluate '.expand('<cword>')<CR>]])
      nnoremap('<Leader>dK', [[<Cmd>execute 'Evaluate '.expand('<cWORD>')<CR>]])

      nnoremap('<Leader>dg', [[<Cmd>Gdb<CR>]])
      nnoremap('<Leader>dp', [[<Cmd>Program<CR>]])
      nnoremap('<Leader>dO', [[<Cmd>Source<CR>]])

      nnoremap('<Leader>d,', [[<Cmd>call TermDebugSendCommand(input('Gdb command> '))<CR>]])
    end
  }

  -- nvim-gdb
  -- Disabled for now as neovim's neovim_gdb.vim seems not exists
  -- if vim.fn.has("nvim") == 1 then
    -- use {'sakhnik/nvim-gdb', run = './install.sh'}
  -- end
end

return utility
