local utils = require("vimrc.utils")

local git = {}

git.startup = function(use)
  -- vim-fugitive
  use({
    "tpope/vim-fugitive",
    -- TODO: vim-fugitive drop obsolete functions and break gv.vim & vim-flog
    commit = "92c73bb0507338441733198d630a1fe5e7fdac3a",
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/fugitive.vim")
    end,
  })
  use("shumphrey/fugitive-gitlab.vim")
  use("tommcdo/vim-fubitive")
  use("tpope/vim-rhubarb")
  use({
    "idanarye/vim-merginal",
    branch = "develop",
    config = function()
      vim.cmd([[augroup merginal_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd BufEnter Merginal:branchList:* call vimrc#merginal#settings()]])
      vim.cmd([[augroup END]])
    end,
  })

  use({
    "junegunn/gv.vim",
    cmd = { "GV", "GVA", "GVD", "GVDA", "GVDE", "GVEA" },
    keys = {
      "<Space>gv",
      "<Space>gV",
      "<Leader>gv",
      "<Leader>gV",
      "<Leader>g<C-V>",
    },
    config = function()
      vim.cmd([[command! -bang -nargs=* GVA GV<bang> --all <args>]])

      -- GV with company filter
      -- TODO: Add complete function, need to get gv.vim script id to use
      -- s:gvcomplete as complete function
      vim.cmd("command! -nargs=* GVD  GV --author=" .. (vim.g.company_domain or "") .. " <args>")
      vim.cmd("command! -nargs=* GVDA GV --author=" .. (vim.g.company_domain or "") .. " --all <args>")
      vim.cmd("command! -nargs=* GVE  GV --author=" .. (vim.g.company_email or "") .. " <args>")
      vim.cmd("command! -nargs=* GVEA GV --author=" .. (vim.g.company_email or "") .. " --all <args>")

      nnoremap("<Space>gv", ":call vimrc#gv#open({})<CR>")
      nnoremap("<Space>gV", ":call vimrc#gv#open({'all': v:true})<CR>")

      nnoremap("<Leader>gv", ":call vimrc#gv#show_file('%', {})<CR>")
      nnoremap("<Leader>gV", ":call vimrc#gv#show_file('%', {'author': g:company_domain})<CR>")
      nnoremap("<Leader>g<C-V>", ":call vimrc#gv#show_file('%', {'author': g:company_email})<CR>")

      vim.cmd([[augroup gv_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd FileType GV call vimrc#gv#mappings()]])
      vim.cmd([[augroup END]])
    end,
  })

  -- NOTE: Do not use vim-flog on large code base, it's very slow in git view
  use({
    "rbong/vim-flog",
    cmd = { "Flog", "Flogsplit" },
    keys = {
      "<Space>gf",
      "<Space>gF",
      "<Leader>gf",
      "<Leader>gF",
      "<Leader>g<C-F>",
    },
    config = function()
      vim.cmd([[command! -nargs=* Floga Flog -all <args>]])

      -- GV with company filter
      vim.cmd(
        "command! -complete=customlist,flog#complete -nargs=* Flogd  Flog -author="
          .. (vim.g.company_domain or "")
          .. " <args>"
      )
      vim.cmd(
        "command! -complete=customlist,flog#complete -nargs=* Flogda Flog -author="
          .. (vim.g.company_domain or "")
          .. " -all <args>"
      )
      vim.cmd(
        "command! -complete=customlist,flog#complete -nargs=* Floge  Flog -author="
          .. (vim.g.company_email or "")
          .. " <args>"
      )
      vim.cmd(
        "command! -complete=customlist,flog#complete -nargs=* Flogea Flog -author="
          .. (vim.g.company_email or "")
          .. " -all <args>"
      )

      nnoremap("<Space>gf", ":call vimrc#flog#open({})<CR>")
      nnoremap("<Space>gF", ":call vimrc#flog#open({'all': v:true})<CR>")

      nnoremap("<Leader>gf", ":call vimrc#flog#show_file('%', {})<CR>")
      nnoremap("<Leader>gF", ":call vimrc#flog#show_file('%', {'author': g:company_domain})<CR>")
      nnoremap("<Leader>g<C-F>", ":call vimrc#flog#show_file('%', {'author': g:company_email})<CR>")

      vim.cmd([[augroup flog_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd FileType floggraph call vimrc#flog#mappings()]])
      vim.cmd([[augroup END]])
    end,
  })

  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("vimrc.plugins.gitsigns")

      -- ref: GruvboxFg4
      vim.cmd([[highlight GitSignsCurrentLineBlame ctermfg=243 guifg=#7c6f64]])
    end,
  })

  use({
    "codeindulgence/vim-tig",
    cmd = { "Tig", "Tig!" },
    keys = {
      [[\tr]],
      [[\tt]],
      [[\ts]],
      [[\tv]],
    },
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/tig.vim")
    end,
  })

  use({
    "rhysd/git-messenger.vim",
    cmd = { "GitMessenger" },
    keys = { "<Leader>gm" },
    config = function()
      nmap("<Leader>gm", "<Plug>(git-messenger)")

      vim.cmd([[augroup git_messenger_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd FileType gitmessengerpopup call vimrc#git_messenger#mappings()]])
      vim.cmd([[augroup END]])
    end,
  })

  use({
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    config = function()
      vim.cmd([[augroup diffview_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd FileType DiffviewFiles call vimrc#diffview#mappings()]])
      vim.cmd([[  autocmd FileType DiffviewFileHistory call vimrc#diffview#history_mappings()]])
      -- diffview.nvim use nvim_buf_set_name() to change buffer name to
      -- corresponding file, so use BufFilePost event
      -- diffview buffer pattern: "^diffview/(\d+_)?(\w{7})_.*$"
      --                                     ^index ^sha    ^filename
      vim.cmd(
        [[  autocmd BufFilePost diffview/\(\d\\\{1,\}_\)\\\{0,1\}\w\\\{7\}_* call vimrc#diffview#buffer_mappings()]]
      )
      vim.cmd([[augroup END]])
    end,
  })

  use({
    "TimUntersberger/neogit",
    disable = true,
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neogit").setup({})
    end,
  })

  -- TODO: experimental
  use({
    "ipod825/igit.nvim",
    -- FIXME: "igit" filetype syntax not work
    disable = true,
    requires = { "nvim-lua/plenary.nvim", "ipod825/libp.nvim" },
    config = function()
      require("igit").setup()
    end,
  })

  use({
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup({
        default_mappings = false,
      })

      nmap("<Leader>co", "<Plug>(git-conflict-ours)")
      nmap("<Leader>ct", "<Plug>(git-conflict-theirs)")
      nmap("<Leader>cb", "<Plug>(git-conflict-both)")
      nmap("<Leader>c0", "<Plug>(git-conflict-none)")

      -- TODO: Use [x, ]x and handle conflict with unimpaired
      nmap("]v", "<Plug>(git-conflict-prev-conflict)")
      nmap("[v", "<Plug>(git-conflict-next-conflict)")
    end,
  })
end

return git
