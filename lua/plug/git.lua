local utils = require('vimrc.utils')

local git = {}

git.startup = function(use)
  -- vim-fugitive
  use {
    'tpope/vim-fugitive',
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/fugitive.vim')
    end
  }
  use 'shumphrey/fugitive-gitlab.vim'
  use 'tommcdo/vim-fubitive'
  use 'tpope/vim-rhubarb'
  use {
    'idanarye/vim-merginal',
    branch = 'develop',
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/merginal.vim')
    end
  }

  use {
    'junegunn/gv.vim',
    cmd = {'GV'},
    keys = {
      utils.t'<Space>gv',
      utils.t'<Space>gV',
      utils.t'<Leader>gv',
      utils.t'<Leader>gV',
      utils.t'<Leader>g<C-V>',
    },
    config = function()
      -- GV with company filter
      -- TODO: Add complete function, need to get gv.vim script id to use
      -- s:gvcomplete as complete function
      vim.cmd('command! -nargs=* GVD  GV --author='..(vim.g.company_domain or '')..' <args>')
      vim.cmd('command! -nargs=* GVDA GV --author='..(vim.g.company_domain or '')..' --all <args>')
      vim.cmd('command! -nargs=* GVE  GV --author='..(vim.g.company_email or '')..' <args>')
      vim.cmd('command! -nargs=* GVEA GV --author='..(vim.g.company_email or '')..' --all <args>')

      nnoremap('<Space>gv', ":call vimrc#gv#open({})<CR>")
      nnoremap('<Space>gV', ":call vimrc#gv#open({'all': v:true})<CR>")

      nnoremap('<Leader>gv',     ":call vimrc#gv#show_file('%', {})<CR>")
      nnoremap('<Leader>gV',     ":call vimrc#gv#show_file('%', {'author': g:company_domain})<CR>")
      nnoremap('<Leader>g<C-V>', ":call vimrc#gv#show_file('%', {'author': g:company_email})<CR>")

      vim.cmd [[augroup gv_settings]]
      vim.cmd [[autocmd!]]
      vim.cmd [[autocmd FileType GV call vimrc#gv#mappings()]]
      vim.cmd [[augroup END]]
    end
  }

  use {
    'rbong/vim-flog',
    cmd = {'Flog', 'Flogsplit'},
    keys = {
      utils.t'<Space>gf',
      utils.t'<Space>gF',
      utils.t'<Leader>gf',
      utils.t'<Leader>gF',
      utils.t'<Leader>g<C-F>',
    },
    config = function()
      vim.cmd [[command! -nargs=* Floga Flog -all <args>]]

      -- GV with company filter
      vim.cmd('command! -complete=customlist,flog#complete -nargs=* Flogd  Flog -author='..(vim.g.company_domain or '')..' <args>')
      vim.cmd('command! -complete=customlist,flog#complete -nargs=* Flogda Flog -author='..(vim.g.company_domain or '')..' -all <args>')
      vim.cmd('command! -complete=customlist,flog#complete -nargs=* Floge  Flog -author='..(vim.g.company_email or '')..' <args>')
      vim.cmd('command! -complete=customlist,flog#complete -nargs=* Flogea Flog -author='..(vim.g.company_email or '')..' -all <args>')

      nnoremap('<Space>gf', ":call vimrc#flog#open({})<CR>")
      nnoremap('<Space>gF', ":call vimrc#flog#open({'all': v:true})<CR>")

      nnoremap('<Leader>gf',     ":call vimrc#flog#show_file('%', {})<CR>")
      nnoremap('<Leader>gF',     ":call vimrc#flog#show_file('%', {'author': g:company_domain})<CR>")
      nnoremap('<Leader>g<C-F>', ":call vimrc#flog#show_file('%', {'author': g:company_email})<CR>")

      vim.cmd [[augroup flog_settings]]
      vim.cmd [[autocmd!]]
      vim.cmd [[autocmd FileType floggraph call vimrc#flog#mappings()]]
      vim.cmd [[augroup END]]
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('vimrc.plugins.gitsigns')
    end
  }

  use {
    'codeindulgence/vim-tig',
    cmd = {'Tig', 'Tig!'},
    keys = {
      [[\tr]],
      [[\tt]],
      [[\ts]],
      [[\tv]],
    },
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/tig.vim')
    end
  }

  use {
    'rhysd/git-messenger.vim',
    cmd = {'GitMessenger'},
    keys = {utils.t'<Leader>gm'},
    config = function()
      nmap('<Leader>gm', '<Plug>(git-messenger)')

      vim.cmd [[augroup git_messenger_settings]]
      vim.cmd [[autocmd!]]
      vim.cmd [[autocmd FileType gitmessengerpopup call vimrc#git_messenger#mappings()]]
      vim.cmd [[augroup END]]
    end
  }

  use {
    'sindrets/diffview.nvim',
    config = function()
      vim.cmd [[augroup diffview_settings]]
      vim.cmd [[autocmd!]]
      vim.cmd [[autocmd FileType DiffviewFiles call vimrc#diffview#mappings()]]
      -- diffview.nvim use nvim_buf_set_name() to change buffer name to
      -- corresponding file, so use BufFilePost event
      -- diffview buffer pattern: "^diffview/(\d+_)?(\w{7})_.*$"
      --                                     ^index ^sha    ^filename
      vim.cmd [[autocmd BufFilePost diffview/\(\d\\\{1,\}_\)\\\{0,1\}\w\\\{7\}_* call vimrc#diffview#buffer_mappings()]]
      vim.cmd [[augroup END]]
    end
  }
end

return git
