local utils = require("vimrc.utils")

local git = {
  -- vim-fugitive
  {
    "tpope/vim-fugitive",
    config = function()
      require("vimrc.plugins.fugitive").setup()
    end,
  },
  {
    "shumphrey/fugitive-gitlab.vim",
    event = { "VeryLazy" },
  },
  {
    "tommcdo/vim-fubitive",
    event = { "VeryLazy" },
  },
  {
    "tpope/vim-rhubarb",
    event = { "VeryLazy" },
  },
  {
    "idanarye/vim-merginal",
    branch = "develop",
    cmd = { "Merginal" },
    config = function()
      vim.cmd([[augroup merginal_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd BufEnter Merginal:branchList:* call vimrc#merginal#settings()]])
      vim.cmd([[augroup END]])
    end,
  },

  {
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
    end,
  },

  -- NOTE: Do not use vim-flog on large code base, it's very slow in git view
  {
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
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("vimrc.plugins.gitsigns").setup()

      -- ref: GruvboxFg4
      vim.cmd([[highlight GitSignsCurrentLineBlame ctermfg=243 guifg=#7c6f64]])
    end,
  },

  {
    "codeindulgence/vim-tig",
    cmd = { "Tig" },
    keys = {
      [[\tr]],
      [[\tt]],
      [[\ts]],
      [[\tv]],
      [[\tl]],
      [[\tL]],
      [[\t<C->L]],
    },
    dependencies = { "rbgrouleff/bclose.vim" },
    config = function()
      require("vimrc.plugins.tig").setup()
    end,
  },

  {
    "rhysd/git-messenger.vim",
    cmd = { "GitMessenger" },
    keys = { "<Leader>gm" },
    config = function()
      nmap("<Leader>gm", "<Plug>(git-messenger)")
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = { "<Space>gd", "<Space>gh", "<Space>gH" },
    config = function()
      nnoremap("<Space>gd", function()
        if next(require("diffview.lib").views) == nil then
          vim.cmd([[DiffviewOpen]])
        else
          vim.cmd([[DiffviewClose]])
        end
      end, { desc = "Diffview toggle" })

      -- TODO: Add mapping for author filter & current file
      nnoremap("<Space>gh", "<Cmd>DiffviewFileHistory<CR>")
      nnoremap("<Space>gH", "<Cmd>DiffviewFileHistory --all<CR>")

      vim.cmd([[augroup diffview_settings]])
      vim.cmd([[  autocmd!]])
      -- diffview.nvim use nvim_buf_set_name() to change buffer name to
      -- corresponding file, so use BufFilePost event
      -- diffview buffer pattern: "^diffview/(\d+_)?(\w{7})_.*$"
      --                                     ^index ^sha    ^filename
      vim.cmd(
        [[  autocmd BufFilePost diffview/\(\d\\\{1,\}_\)\\\{0,1\}\w\\\{7\}_* call vimrc#diffview#buffer_mappings()]]
      )
      vim.cmd([[augroup END]])
    end,
  },

  {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    cmd = { "Neogit" },
    key = { "<Leader>gn" },
    config = function()
      require("neogit").setup({
        integrations = {
          diffview = true,
        }
      })

      nnoremap("<Leader>gn", "<Cmd>Neogit<CR>")
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    cmd = { "GitConflictRefresh", "GitConflictNextConflict", "GitConflictPrevConflict" },
    keys = { "<Leader>cr", "]v", "[v" },
    config = function()
      require("git-conflict").setup({
        default_mappings = false,
      })

      nnoremap("<Leader>cr", [[<Cmd>GitConflictRefresh<CR>]])
      nmap("<Leader>co", "<Plug>(git-conflict-ours)")
      nmap("<Leader>ct", "<Plug>(git-conflict-theirs)")
      nmap("<Leader>cb", "<Plug>(git-conflict-both)")
      nmap("<Leader>c0", "<Plug>(git-conflict-none)")

      -- TODO: Use [x, ]x and handle conflict with unimpaired
      nmap("]v", "<Plug>(git-conflict-prev-conflict)")
      nmap("[v", "<Plug>(git-conflict-next-conflict)")
    end,
  },
}

return git
