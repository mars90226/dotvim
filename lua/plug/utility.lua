local utils = require('vimrc.utils')

local utility = {}

utility.startup = function(use)
  use {
    'simnalamburt/vim-mundo',
    cmd = {'MundoToggle'},
    keys = {utils.t'<F9>'},
    config = function()
      if vim.fn.has('python3') == 1 then
        vim.g.mundo_prefer_python3 = 1
      end

      nnoremap('<F9>', ':MundoToggle<CR>')
    end
  }

  use {
    'tpope/vim-unimpaired',
    event = 'VimEnter',
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
    config = function()
      nmap('gA', '<Plug>(characterize)')
    end
  }

  use {
    'junegunn/vim-peekaboo',
    config = function()
      vim.g.peekaboo_window = 'vertical botright ' .. vim.fn.float2nr(vim.go.columns * 0.3) .. 'new'
      vim.g.peekaboo_delay = 400
    end
  }

  use {
    'gu-fan/colorv.vim',
    cmd = {'ColorV', 'ColorVName', 'ColorVView'},
    keys = {utils.t'<Leader>vv', utils.t'<Leader>vn', utils.t'<Leader>vw'},
    config = function()
      nnoremap('<Leader>vv', ':ColorV<CR>', 'silent')
      nnoremap('<Leader>vn', ':ColorVName<CR>', 'silent')
      nnoremap('<Leader>vw', ':ColorVView<CR>', 'silent')
    end
  }

  use {
    'airblade/vim-rooter',
    cmd = {'Rooter'},
    keys = {utils.t'<Leader>r'},
    config = function()
      vim.g.rooter_manual_only = 1
      vim.g.rooter_cd_cmd = 'lcd'
      vim.g.rooter_patterns = {'Cargo.toml', '.git/', 'package.json'}

      nnoremap('<Leader>r', ':Rooter<CR>')
    end
  }

  use {
    'vimwiki/vimwiki',
    branch = 'dev',
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
      vim.cmd [[autocmd!]]
      vim.cmd [[autocmd FileType vimwiki call vimrc#vimwiki#settings()]]
      vim.cmd [[autocmd FileType vimwiki call vimrc#vimwiki#mappings()]]
      vim.cmd [[autocmd VimEnter *.wiki  VimwikiManualAllFolding]]
      vim.cmd [[augroup END]]
    end
  }
  use 'jceb/vim-orgmode'
  use 'vimoutliner/vimoutliner'

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

  use {
    'thinca/vim-qfreplace',
    config = function()
      vim.cmd [[augroup qfreplace_settings]]
      vim.cmd [[autocmd!]]
      vim.cmd [[autocmd FileType qf call vimrc#qfreplace#mappings()]]
      vim.cmd [[augroup END]]
    end
  }

  use {
    'romainl/vim-qf',
    config = function()
      -- Don't auto open quickfix list because it make vim-dispatch not able to
      -- restore 'makeprg' after make.
      -- https://github.com/tpope/vim-dispatch/issues/254
      vim.g.qf_auto_open_quickfix = 0
    end
  }

  -- cfilter
  vim.cmd [[packadd cfilter]]

  use {'arthurxavierx/vim-caser', event = 'VimEnter'}

  use {
    'machakann/vim-highlightedyank',
    config = function()
      vim.g.highlightedyank_highlight_duration = 200
    end
  }

  use {
    'junegunn/goyo.vim',
    config = function()
      nnoremap('<Leader>gy', ':Goyo<CR>')
    end
  }

  use {
    'junegunn/limelight.vim',
    config = function()
      nnoremap('<Leader><C-L>', ':Limelight!!<CR>')
    end
  }

  use {
    'tpope/vim-dispatch',
    event = 'VimEnter',
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/dispatch.vim')
    end
  }

  -- See https://www.reddit.com/r/vim/comments/bwp7q3/code_execution_vulnerability_in_vim_811365_and/
  -- and https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md for more details
  use 'ciaranm/securemodelines'

  -- Do not lazy load vim-scriptease, as it breaks :Breakadd/:Breakdel
  use 'tpope/vim-scriptease'

  use 'tyru/open-browser.vim'

  use {
    'glacambre/firenvim',
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
    config = function()
      vim.cmd [[command! Suda edit suda://%]]
    end
  }

  use {
    'simeji/winresizer',
    config = function()
      vim.g.winresizer_start_key = '<Leader>R'
    end
  }

  -- Disabled by default, enable to profile
  -- Plug 'norcalli/profiler.nvim'

  use {'tpope/vim-dadbod', cmd = {'DB'}}
  use {'tpope/vim-abolish', cmd = {'Abolish', 'Subvert', 'S'}}
  use {'will133/vim-dirdiff', cmd = {'DirDiff'}}
  use {'AndrewRadev/linediff.vim', cmd = {'Linediff'}}
  use {'Shougo/vimproc.vim', run = 'make'}
  use {'Shougo/vinarise.vim', cmd = {'Vinarise'}}
  use {'alx741/vinfo', cmd = {'Vinfo'}}
  use 'mattn/webapi-vim'
  use 'kopischke/vim-fetch'
  use 'Valloric/ListToggle'
  use 'tpope/vim-eunuch'
  use {'DougBeney/pickachu', cmd = {'Pick'}}
  use {'tweekmonster/helpful.vim', cmd = {'HelpfulVersion'}}
  use {'tweekmonster/startuptime.vim', cmd = {'StartupTime'}}
  use 'gyim/vim-boxdraw'
  use 'lambdalisue/reword.vim'
  use 'lpinilla/vim-codepainter'
  use 'nicwest/vim-http'
  use 'kristijanhusak/vim-carbon-now-sh'

  -- nvim-gdb
  -- Disabled for now as neovim's neovim_gdb.vim seems not exists
  -- if vim.fn.has("nvim") == 1 then
    -- use {'sakhnik/nvim-gdb', run = './install.sh'}
  -- end
end

return utility