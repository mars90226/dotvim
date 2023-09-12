local utility = {
  -- Undo Tree
  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
    keys = { "<F9>" },
    config = function()
      nnoremap("<F9>", ":UndotreeToggle<CR>")
    end,
  },
  -- NOTE: vim-mundo is slow, but featureful
  {
    "simnalamburt/vim-mundo",
    cmd = { "MundoToggle" },
    keys = { "<Space><F9>" },
    config = function()
      if vim.fn.has("python3") == 1 then
        vim.g.mundo_prefer_python3 = 1
      end

      nnoremap("<Space><F9>", ":MundoToggle<CR>")
    end,
  },

  {
    "tpope/vim-unimpaired",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    keys = {
      "yo",
      "[<Space>",
      "]<Space>",
    },
    init = function()
      vim.g.nremap = {
        -- url encode/decode
        ["[u"] = [[\[u]],
        ["]u"] = [[\]u]],
        ["[uu"] = [[\[uu]],
        ["]uu"] = [[\]uu]],
        -- xml encode/decode
        ["[x"] = [[\[x]],
        ["]x"] = [[\]x]],
        ["[xx"] = [[\[xx]],
        ["]xx"] = [[\]xx]],
      }
    end,
    config = function()
      local utils = require("vimrc.utils")

      nnoremap("coc", ":set termguicolors!<CR>")
      nnoremap("coe", ":set expandtab!<CR>")
      nnoremap("com", ":set modifiable!<CR>")
      nnoremap("coo", ":set readonly!<CR>")
      nnoremap("cop", ":set paste!<CR>")
      nnoremap("yoa", ":setlocal autoread!<CR>")

      vim.keymap.set("n", "codh", function()
        utils.toggle_list_option_flag(vim.opt.diffopt, "algorithm:histogram")
      end, { noremap = true })
    end,
  },

  {
    "tpope/vim-characterize",
    keys = { "gA" },
    config = function()
      nmap("gA", "<Plug>(characterize)")
    end,
  },

  -- Registers
  {
    "tversteeg/registers.nvim",
    event = { "VeryLazy" },
  },

  -- Colors
  -- TODO: Change ColorV global leader to avoid key mapping conflict
  {
    "gu-fan/colorv.vim",
    cmd = { "ColorV", "ColorVName", "ColorVView" },
    keys = { "<Leader>vv", "<Leader>vn", "<Leader>vw" },
    dependencies = { "mattn/webapi-vim" },
    config = function()
      nnoremap("<Leader>vv", ":ColorV<CR>", "silent")
      nnoremap("<Leader>vn", ":ColorVName<CR>", "silent")
      nnoremap("<Leader>vw", ":ColorVView<CR>", "silent")
    end,
  },
  {
    "nvim-colortils/colortils.nvim",
    cmd = { "Colortils" },
    keys = { "<Leader>ct" },
    config = function()
      require("colortils").setup({
        mappings = {
          replace_default_format = "<M-CR>",
          replace_choose_format = "g<M-CR>",
        },
      })

      nnoremap("<Leader>ct", [[<Cmd>Colortils picker black<CR>]])
      xnoremap("<Leader>ct", [[:<C-U>execute 'Colortils picker '..vimrc#utility#get_visual_selection()<CR>]])
    end,
  },

  -- Project
  {
    "ahmedkhalf/project.nvim",
    event = { "VeryLazy" },
    config = function()
      require("project_nvim").setup({
        -- Manual mode doesn't automatically change your root directory, so you have
        -- the option to manually do so using `:ProjectRoot` command.
        manual_mode = true,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        ignore_lsp = { "null-ls" },
        -- What scope to change the directory, valid options are
        -- * global (default)
        -- * tab
        -- * win
        scope_chdir = "win",
      })
      require("telescope").load_extension("projects")

      nnoremap("<Leader>r", "<Cmd>ProjectRoot<CR>")
    end,
  },

  -- Note Taking
  {
    "vimwiki/vimwiki",
    branch = "dev",
    ft = { "vimwiki", "todo" }, -- NOTE: Add custom todo filetype
    init = function()
      require("vimrc.plugins.vimwiki").pre_setup()
    end,
    config = function()
      require("vimrc.plugins.vimwiki").setup()
    end,
  },

  -- NOTE: require nvim-treesitter
  {
    "nvim-neorg/neorg",
    ft = { "norg" },
    cmd = { "Neorg" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("vimrc.plugins.neorg").setup()
    end,
  },

  {
    "powerman/vim-plugin-AnsiEsc",
    cmd = { "AnsiEsc" },
    keys = { "coa" },
    config = function()
      nnoremap("coa", ":AnsiEsc<CR>")
    end,
  },

  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help", "terminal" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = false,
      })
    end,
  },

  {
    "embear/vim-localvimrc",
    init = function()
      -- NOTE: Avoid lazy load error with upvalues (captured values)
      local utils = require("vimrc.utils")

      -- Be careful of malicious localvimrc
      vim.g.localvimrc_sandbox = 0

      vim.g.localvimrc_whitelist = {
        vim.env.HOME .. "/.vim",
        vim.env.HOME .. "/.tmux",
        vim.env.HOME .. "/test",
      }

      if vim.g.localvimrc_secret_whitelist ~= nil then
        vim.g.localvimrc_whitelist = utils.table_concat(vim.g.localvimrc_whitelist, vim.g.localvimrc_secret_whitelist)
      end

      if vim.g.localvimrc_local_whitelist ~= nil then
        vim.g.localvimrc_whitelist = utils.table_concat(vim.g.localvimrc_whitelist, vim.g.localvimrc_local_whitelist)
      end
    end,
  },

  { "kevinhwang91/nvim-bqf", ft = { "qf" } },

  { "thinca/vim-qfreplace",  ft = { "qf" } },

  {
    "romainl/vim-qf",
    ft = { "qf" },
    config = function()
      -- Don't auto open quickfix list because it make vim-dispatch not able to
      -- restore 'makeprg' after make.
      -- https://github.com/tpope/vim-dispatch/issues/254
      vim.g.qf_auto_open_quickfix = 0
    end,
  },

  {
    "arthurxavierx/vim-caser",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
  },

  -- Focus
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode", "ZenModeCopy" },
    keys = { "<Leader>zm", "<Leader>zc" },
    config = function()
      require("zen-mode").setup({
        plugins = {
          twilight = { enabled = false }, -- twilight.nvim with treesitter in zen-mode.nvim is extremely slow
        }
      })

      vim.api.nvim_create_user_command("ZenModeCopy", function()
        vim.cmd([[ZenMode]])
        vim.wo.number = false
        vim.wo.statuscolumn = ''
        vim.wo.winbar = ''
        vim.wo.list = not vim.wo.list
        require("vimrc.lsp").toggle_show_diagnostics()
        vim.cmd([[IndentBlanklineToggle]])
        vim.cmd([[TwilightDisable]])
        vim.cmd([[BlockOff]])
      end, {})

      nnoremap("<Leader>zm", [[<Cmd>ZenMode<CR>]])
      nnoremap("<Leader>zc", [[<Cmd>ZenModeCopy<CR>]])
    end
  },

  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = { "<Leader><C-L>" },
    config = function()
      require("twilight").setup({})

      nnoremap("<Leader><C-L>", ":Twilight<CR>")
    end,
  },

  -- Code Runner
  {
    "tpope/vim-dispatch",
    cmd = { "Make", "Copen", "Dispatch", "Start", "Spawn" },
    keys = { "<Leader>dq" },
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      -- TODO Check if disabling tmux is good
      -- As currently, it break tmux zoom.
      -- But using Job makes closing vim while git push failed
      vim.g.dispatch_no_tmux_make = 1

      -- Mappings
      nnoremap("<Leader>dq", [[<Cmd>Copen<CR>]])
    end,
  },
  {
    'stevearc/overseer.nvim',
    cmd = {
      "OverseerOpen",
      "OverseerToggle",
      "OverseerRUnCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
    },
    keys = {
      "<Space>ro",
      "<Space>rr",
      "<Space>rR",
      "<Space>rn",
      "<Space>rq",
      "<Space>rt",
    },
    config = function()
      require("overseer").setup()

      nnoremap("<Space>ro", [[<Cmd>OverseerToggle<CR>]])
      nnoremap("<Space>rr", [[<Cmd>OverseerRun<CR>]])
      nnoremap("<Space>rR", [[<Cmd>OverseerRunCmd<CR>]])
      nnoremap("<Space>rn", [[<Cmd>OverseerBuild<CR>]])
      nnoremap("<Space>rq", [[<Cmd>OverseerQuickAction<CR>]])
      nnoremap("<Space>rt", [[<Cmd>OverseerTaskAction<CR>]])
    end,
  },

  -- Do not lazy load vim-scriptease, as it breaks :Breakadd/:Breakdel
  -- TODO: Check if lazy load works
  { "tpope/vim-scriptease", cmd = { "PP", "Messages", "Verbose", "Time", "Scriptnames" } },

  {
    "tyru/open-browser.vim",
    event = { "VeryLazy" },
  },

  -- Colorizer
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      vim.go.termguicolors = true

      require("colorizer").setup({
        filetypes = {
          "*",
          css = { css = true },
          scss = { css = true },
        },
        user_default_options = {
          names = false,
        },
      })
    end,
  },

  {
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
  },

  -- Window Layout
  {
    "simeji/winresizer",
    cmd = { "WinResizerStartResize" },
    keys = { "<C-W><C-R>" },
    init = function()
      vim.g.winresizer_start_key = "<C-W><C-R>"
    end,
  },
  {
    "sindrets/winshift.nvim",
    cmd = { "WinShift" },
    keys = { "<C-W><C-M>", "<C-W>m", "<C-W>X" },
    config = function()
      require("winshift").setup({})

      nnoremap("<C-W><C-M>", [[<Cmd>WinShift<CR>]])
      nnoremap("<C-W>m", [[<Cmd>WinShift<CR>]])
      nnoremap("<C-W>X", [[<Cmd>WinShift swap<CR>]])
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "folke/todo-comments.nvim" },
    config = function()
      require("todo-comments").setup({})

      nnoremap("<F8>", "<Cmd>TodoTrouble<CR>")
      nnoremap("<Space><F8>", "<Cmd>TodoTelescope<CR>")
      nnoremap("[x", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })
      nnoremap("]x", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })
    end,
  },

  -- NOTE: stabilize.nvim is merged into neovim 0.9.0 as `splitkeep` option
  -- Ref: https://github.com/neovim/neovim/pull/19243
  -- TODO: Enable `splitkeep` option when upgrading to neovim 0.9.0
  -- TODO: Remove this comment after raising minimal version requirement of neovim to 0.9.0

  -- Cmdline
  -- TODO: Replace this with noice.nvim
  {
    "VonHeikemen/fine-cmdline.nvim",
    dependencies = { { "MunifTanjim/nui.nvim" } },
    cmd = { "FineCmdline" },
    keys = { "<C-P>" },
    config = function()
      require("vimrc.plugins.fine-cmdline").setup()
    end,
  },

  {
    "hoschi/yode-nvim",
    keys = { "<Leader>yc", "<Leader>yr" },
    config = function()
      require("yode-nvim").setup({})

      noremap("<Leader>yc", [[:YodeCreateSeditorFloating<CR>]])
      noremap("<Leader>yr", [[:YodeCreateSeditorReplace<CR>]])
      nnoremap("<Leader>bd", [[:YodeBufferDelete<CR>]])

      nnoremap("<C-W>r", [[<Cmd>YodeLayoutShiftWinDown<CR>]])
      nnoremap("<C-W>R", [[<Cmd>YodeLayoutShiftWinUp<CR>]])
      nnoremap("<C-W>J", [[<Cmd>YodeLayoutShiftWinBottom<CR>]])
      nnoremap("<C-W>K", [[<Cmd>YodeLayoutShiftWinTop<CR>]])

      -- For no gap between floating windows
      vim.go.showtabline = 2
    end,
  },

  {
    "bennypowers/nvim-regexplainer",
    cmd = { "RegexplainerToggle" },
    keys = { "<Leader>er" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("regexplainer").setup({
        mappings = {
          toggle = "<Leader>er",
        },
      })
    end,
  },

  {
    "axieax/urlview.nvim",
    event = { "VeryLazy" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local urlview = require("vimrc.plugins.urlview")
      local has_secret_urlview, secret_urlview = pcall(require, "secret.urlview")

      require("urlview").setup({
        default_action = vim.fn["vimrc#plugin#check#has_ssh_host_client"]() and "client_open_browser" or "system",
      })
      urlview.setup()

      if has_secret_urlview then
        secret_urlview.setup()
      end

      nnoremap("<Leader>uu", [[<Cmd>UrlView buffer picker=telescope<CR>]], { desc = "view buffer URLs" })
      nnoremap("<Leader>ul", [[<Cmd>UrlView lazy picker=telescope<CR>]], { desc = "view plugin URLs" })
    end,
  },

  {
    "gennaro-tedesco/nvim-jqx",
    cond = vim.fn.executable("jq") == 1,
    event = { "VeryLazy" },
  },

  -- Disabled by default, enable to profile
  -- "norcalli/profiler.nvim"

  {
    "s1n7ax/nvim-window-picker",
    version = "v1.*",
    lazy = true,
    config = function()
      require("window-picker").setup()
    end,
  },
  {
    "lpinilla/vim-codepainter",
    keys = { "<Leader>cp", "<Leader>cn" },
    config = function()
      vim.g.codepainter_default_mappings = 0

      vnoremap("<Leader>cp", [[:<C-U>call codepainter#paintText(visualmode())<CR>]])
      nnoremap("<Leader>cp", [[:<C-U>call codepainter#paintText('')<CR>]])
      nnoremap("<Leader>cn", [[:<C-U>call codepainter#navigate()<CR>]])
    end,
  },

  -- Translate
  -- NOTE: Requires curl 7.76.0. Otherwise, curl do not understand `--fail-with-body` and return exit status 2
  -- TODO: Check for curl version
  {
    "potamides/pantran.nvim",
    cmd = { "Pantran" },
    keys = { "<Leader>pt", "<Leader>ptt" },
    config = function()
      local pantran = require("pantran")

      pantran.setup({
        engines = {
          argos = {
            default_target = "zh",
          },
        },
      })

      local opts = { noremap = true, silent = true, expr = true }
      vim.keymap.set("n", "<Leader>pt", pantran.motion_translate, opts)
      vim.keymap.set("n", "<Leader>ptt", function()
        return pantran.motion_translate() .. "_"
      end, opts)
      vim.keymap.set("x", "<Leader>pt", pantran.motion_translate, opts)
    end,
  },
  {
    "uga-rosa/translate.nvim",
    cmd = { "Translate" },
    keys = { "<Leader>tr" },
    config = function()
      require("translate").setup({})

      nnoremap("<Leader>tr", [[viw:Translate ZH-TW<CR>]])
      xnoremap("<Leader>tr", [[:Translate ZH-TW<CR>]])
    end,
  },

  {
    "Bekaboo/deadcolumn.nvim",
    event = { "VeryLazy" },
    init = function()
      -- NOTE: Monitor this
      vim.opt.textwidth = 100
      vim.opt.colorcolumn = "+2"
    end,
  },

  {
    "AndrewRadev/linediff.vim",
    cmd = { "Linediff" },
    keys = { { "<M-d>l", mode = { "n", "x" } } },
    config = function()
      nnoremap("<M-d>l", [[V:Linediff<CR>]])
      xnoremap("<M-d>l", [[:Linediff<CR>]])
    end,
  },

  -- DB
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
    },
    cmd = { "DB", "DBUI" },
  },

  -- NOTE: Try again after it can add connections interactively
  {
    "kndndrj/nvim-dbee",
    enabled = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
    config = function()
      require("dbee").setup( --[[optional config]])
    end,
  },

  { "tpope/vim-abolish",    cmd = { "Abolish", "Subvert", "S" },                         keys = { "cr" } },
  { "will133/vim-dirdiff",  cmd = { "DirDiff" } },
  { "Shougo/vinarise.vim",  cmd = { "Vinarise" } },
  { "alx741/vinfo",         cmd = { "Vinfo" } },
  "kopischke/vim-fetch",
  {
    "Valloric/ListToggle",
    cmd = { "QToggle", "LToggle" },
    keys = { "<Leader>q", "<Leader>l" },
  },
  { "tpope/vim-eunuch",                 event = { "VeryLazy" } },
  { "DougBeney/pickachu",               cmd = { "Pick" } },
  { "tweekmonster/helpful.vim",         cmd = { "HelpfulVersion" } },
  { "tweekmonster/startuptime.vim",     cmd = { "StartupTime" } },
  { "gyim/vim-boxdraw",                 keys = { "+o", "+O", "+c", "+-", "+_" } },
  { "lambdalisue/reword.vim",           event = { "VeryLazy" } },
  { "nicwest/vim-http",                 cmd = { "Http" } },
  { "kristijanhusak/vim-carbon-now-sh", cmd = { "CarbonNowSh" } },
  { "taybart/b64.nvim",                 cmd = { "B64Encode", "B64Decode" } },

  -- nvim-gdb
  -- Disabled for now as neovim's neovim_gdb.vim seems not exists
  -- {
  --   'sakhnik/nvim-gdb',
  --   build = './install.sh',
  --   cond = vim.fn.has("nvim") == 1,
  -- }
}

return utility
