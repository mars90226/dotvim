local git = {
  -- vim-fugitive
  {
    "tpope/vim-fugitive",
    event = { "VeryLazy" },
    config = function()
      require("vimrc.plugins.fugitive").setup()
    end,
  },
  {
    "shumphrey/fugitive-gitlab.vim",
    dependencies = { "tpope/vim-fugitive" },
    event = { "VeryLazy" },
  },
  {
    "tommcdo/vim-fubitive",
    dependencies = { "tpope/vim-fugitive" },
    event = { "VeryLazy" },
  },
  {
    "tpope/vim-rhubarb",
    dependencies = { "tpope/vim-fugitive" },
    event = { "VeryLazy" },
  },
  {
    "idanarye/vim-merginal",
    dependencies = { "tpope/vim-fugitive" },
    branch = "develop",
    cmd = { "Merginal" },
    config = function()
      local merginal_augroup_id = vim.api.nvim_create_augroup("merginal_settings", {})
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        group = merginal_augroup_id,
        pattern = "Merginal:branchList:*",
        callback = function()
          vim.fn["vimrc#merginal#settings"]()
        end,
      })
    end,
  },

  {
    "junegunn/gv.vim",
    dependencies = { "tpope/vim-fugitive" },
    cmd = { "GV", "GVA", "GVD", "GVDA", "GVDE", "GVEA" },
    keys = {
      { "<Space>gv",      ":call vimrc#gv#open({})<CR>",                                     desc = "GV open" },
      { "<Space>gV",      ":call vimrc#gv#open({'all': v:true})<CR>",                        desc = "GV open all branches" },
      { "<Leader>gv",     ":call vimrc#gv#show_file('%', {})<CR>",                           desc = "GV show current file" },
      { "<Leader>gV",     ":call vimrc#gv#show_file('%', {'author': g:company_domain})<CR>", desc = "GV show current file with company domain" },
      { "<Leader>g<C-V>", ":call vimrc#gv#show_file('%', {'author': g:company_email})<CR>",  desc = "GV show current file with company email" },
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
    end,
  },

  -- NOTE: Do not use vim-flog on large code base, it's very slow in git view
  {
    "rbong/vim-flog",
    dependencies = { "tpope/vim-fugitive" },
    cmd = { "Flog", "Flogsplit" },
    keys = {
      { "<Space>gf",      ":call vimrc#flog#open({})<CR>",                                     desc = "Flog open" },
      { "<Space>gF",      ":call vimrc#flog#open({'all': v:true})<CR>",                        desc = "Flog open all branches" },
      { "<Leader>gf",     ":call vimrc#flog#show_file('%', {})<CR>",                           desc = "Flog show current file" },
      { "<Leader>gF",     ":call vimrc#flog#show_file('%', {'author': g:company_domain})<CR>", desc = "Flog show current file with company domain" },
      { "<Leader>g<C-F>", ":call vimrc#flog#show_file('%', {'author': g:company_email})<CR>",  desc = "Flog show current file with company email" },
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
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("vimrc.plugins.gitsigns").setup()

      -- TODO: Move to gruvbox.nvim config
      -- ref: GruvboxFg4
      vim.cmd([[highlight GitSignsCurrentLineBlame ctermfg=243 guifg=#7c6f64]])
    end,
  },

  {
    "codeindulgence/vim-tig",
    cmd = { "Tig" },
    keys = {
      -- Add '' to open tig main view
      { [[\tr]], [[:Tig ''<CR>]], desc = "Tig - open main view" },
      { [[\tt]], [[:tabnew <Bar> Tig ''<CR>]], desc = "Tig - open main view in tab" },
      { [[\ts]], [[:new    <Bar> Tig ''<CR>]], desc = "Tig - open main view in split" },
      { [[\tv]], [[:vnew   <Bar> Tig ''<CR>]], desc = "Tig - open main view in vertical split" },

      -- Add non-follow version as --follow will include many merge commits
      { [[\tl]], [[:TigLogFileSplit!<CR>]], desc = "Tig - open log view for current file without follow in split" },
      { [[\tL]], [[:TigLogFileSplit! --follow<CR>]], desc = "Tig - open log view for current file in split" },
      { [[\t<C-L>]], [[:execute 'TigLogSplit! $(git log --format=format:%H --follow -- ' . expand('%:p') . ')'<CR>]], desc = "Tig - open log view" },
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
    keys = {
      {
        "<Space>gd",
        function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd([[DiffviewOpen]])
          else
            vim.cmd([[DiffviewClose]])
          end
        end,
        desc = "Diffview toggle"
      },

      -- TODO: Add mapping for author filter & current file
      { "<Space>gh", "<Cmd>DiffviewFileHistory<CR>",       desc = "Diffview file history" },
      { "<Space>gH", "<Cmd>DiffviewFileHistory --all<CR>", desc = "Diffview file history all branches" },
    },
    config = function()
      require("diffview").setup({
        file_panel = {
          win_config = {
            width = vim.g.left_sidebar_width,
          }
        }
      })

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
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = { "Neogit" },
    keys = { "<Leader>gn" },
    config = function()
      require("neogit").setup({
        integrations = {
          telescope = true,
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
      nmap("[v", "<Plug>(git-conflict-prev-conflict)")
      nmap("]v", "<Plug>(git-conflict-next-conflict)")
    end,
  },

  -- GitLab
  {
    "harrisoncramer/gitlab.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
      enabled = true,
    },
    build = function() require("gitlab.server").build(true) end, -- Builds the Go binary
    -- TODO: Fill complete gitlab.nvim keys
    keys = { "glrr", "gls", "glrm" },
    config = function()
      require("vimrc.plugins.gitlab").setup()
    end,
  },
}

return git
