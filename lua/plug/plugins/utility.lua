local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local utility = {
  -- Store
  {
    "alex-popov-tech/store.nvim",
    dependencies = {
      "OXY2DEV/markview.nvim", -- optional, for pretty readme preview / help window
    },
    cmd = "Store",
    keys = {
      { "<Leader>ps", "<cmd>Store<cr>", desc = "Open Plugin Store" },
    },
    opts = {
      -- optional configuration here
    },
  },

  -- Undo Tree
  {
    "XXiaoA/atone.nvim",
    cmd = "Atone",
    keys = {
      { "<F9>", "<Cmd>Atone toggle<CR>", desc = "Toggle Atone undo tree" },
    },
    opts = {},
  },
  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
    keys = {
      { "<Space><F9>", "<Cmd>UndotreeToggle<CR>", desc = "Toggle undo tree" },
    },
  },

  {
    "tpope/vim-characterize",
    keys = {
      { "gA", "<Plug>(characterize)", desc = "Show character info under cursor" },
    },
  },

  -- Colors
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccConvert", "CccHighlighterToggle", "CccHighlighterEnable", "CccHighlighterDisable" },
    keys = {
      { "<Leader>vv", [[<Cmd>CccPick<CR>]], desc = "Ccc - Pick" },
    },
    config = function()
      vim.go.termguicolors = true
      require("ccc").setup({})
    end,
  },

  -- Colorizer
  -- NOTE: Cannot lazy load on key, first buffer doesn't have color highlight
  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufRead", "BufNewFile" },
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

  -- Project
  {
    "ahmedkhalf/project.nvim",
    cond = choose.is_enabled_plugin("project.nvim"),
    event = { "VeryLazy" },
    config = function()
      require("project_nvim").setup({
        -- Manual mode doesn't automatically change your root directory, so you have
        -- the option to manually do so using `:ProjectRoot` command.
        manual_mode = true,
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        ignore_lsp = { "none-ls" },
        -- What scope to change the directory, valid options are
        -- * global (default)
        -- * tab
        -- * win
        scope_chdir = "win",
      })
      if choose.is_enabled_plugin("telescope.nvim") then
        require("telescope").load_extension("projects")
      end

      vim.keymap.set("n", "<Leader>pr", "<Cmd>ProjectRoot<CR>")
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
  -- TODO: Check if not working on Windows
  {
    "nvim-neorg/neorg",
    cond = choose.is_enabled_plugin("neorg"),
    ft = { "norg" },
    cmd = { "Neorg" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("vimrc.plugins.neorg").setup()
    end,
  },

  -- TODO: May cause stuck in some complex Markdown files
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = { "markdown" },
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    ---@module 'obsidian'
    ---@type obsidian.config.ClientOpts
    opts = {
      -- TODO: Add secret vaults
      -- TODO: Do not show error if vault not found
      workspaces = {
        {
          name = "notes",
          path = "~/vaults/notes",
        },
      },
      notes_subdir = "pages",
      daily_notes = {
        folder = "journals",
        template = "pages/templates/daily.md",
      },
      legacy_commands = false, -- Suppress warning about legacy commands
    },
    cmd = { "Obsidian" },
    keys = {
      { "<Space>b<Space>", [[:Obsidian<Space>]], desc = "Obsidian" },
    },
    config = function(_, opts)
      vim.opt.conceallevel = 2 -- conceal all text by default
      require("obsidian").setup(opts)
    end,
  },

  {
    "powerman/vim-plugin-AnsiEsc",
    cmd = { "AnsiEsc" },
    keys = {
      { "coa", "<Cmd>AnsiEsc<CR>", desc = "Convert ANSI escape sequences to highlighted text" },
    },
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

  -- Project-local config
  -- TODO: Replace vim-localvimrc with 'exrc' option
  {
    "embear/vim-localvimrc",
    init = function()
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
  -- NOTE: Also as dependency of nvim-lspconfig
  {
    "folke/neoconf.nvim",
    cmd = "Neoconf",
    opts = {},
  },

  -- Quickfix
  { "kevinhwang91/nvim-bqf", ft = { "qf" } },
  { "thinca/vim-qfreplace", ft = { "qf" } },
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

  -- Focus
  {
    "hoschi/yode-nvim",
    keys = {
      { "<Leader>yc", [[<Cmd>YodeCreateSeditorFloating<CR>]], desc = "Yode - create editor in float" },
      { "<Leader>yr", [[<Cmd>YodeCreateSeditorReplace<CR>]], desc = "Yode - create editor in current window" },
    },
    config = function()
      require("yode-nvim").setup({})

      vim.keymap.set("n", "<Leader>bd", [[:YodeBufferDelete<CR>]])

      vim.keymap.set("n", "<C-W>r", [[<Cmd>YodeLayoutShiftWinDown<CR>]])
      vim.keymap.set("n", "<C-W>R", [[<Cmd>YodeLayoutShiftWinUp<CR>]])
      vim.keymap.set("n", "<C-W>J", [[<Cmd>YodeLayoutShiftWinBottom<CR>]])
      vim.keymap.set("n", "<C-W>K", [[<Cmd>YodeLayoutShiftWinTop<CR>]])

      -- For no gap between floating windows
      vim.go.showtabline = 2
    end,
  },

  -- Code Runner
  {
    "tpope/vim-dispatch",
    cmd = { "Make", "Copen", "Dispatch", "Start", "Spawn" },
    keys = {
      { "<Leader>dq", [[<Cmd>Copen<CR>]], desc = "Open vim-dispatch build result in quickfix" },
    },
    config = function()
      -- TODO Check if disabling tmux is good
      -- As currently, it break tmux zoom.
      -- But using Job makes closing vim while git push failed
      vim.g.dispatch_no_tmux_make = 1
    end,
  },
  {
    "stevearc/overseer.nvim",
    version = "v1.6.0",
    cmd = {
      "OverseerOpen",
      "OverseerToggle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
    },
    keys = {
      { "<Space>ro", [[<Cmd>OverseerToggle<CR>]], desc = "Overseer toggle" },
      { "<Space>rr", [[<Cmd>OverseerRun<CR>]], desc = "Overseer run" },
      { "<Space>r;", [[<Cmd>OverseerRunCmd<CR>]], desc = "Overseer run cmd" },
      { "<Space>rn", [[<Cmd>OverseerBuild<CR>]], desc = "Overseer build" },
      { "<Space>rq", [[<Cmd>OverseerQuickAction<CR>]], desc = "Overseer quick action" },
      { "<Space>rt", [[<Cmd>OverseerTaskAction<CR>]], desc = "Overseer task action" },
    },
    config = function()
      require("vimrc.plugins.overseer").setup()
    end,
  },
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    keys = {
      -- Open compiler
      { "<Leader>pc", "<Cmd>CompilerOpen<CR>", silent = true, desc = "Comiler.nvim - open compiler" },
      {
        "<Leader>pl",
        "<Cmd>CompilerStop<CR>" .. "<Cmd>CompilerRedo<CR>",
        silent = true,
        desc = "Compiler.nvim - redo last selected option",
      }, -- Stop to dispose all tasks before redo
      {
        "<Leader>pv",
        "<Cmd>CompilerToggleResults<CR>",
        silent = true,
        desc = "Compiler.nvim - toggle compiler results",
      },
    },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},
  },

  -- Test
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter", -- TODO: Check nvim-treesitter enabled?

      -- Adapters
      "nvim-neotest/neotest-plenary",
      "alfaix/neotest-gtest",
    },
    cmd = { "Neotest" },
    keys = {
      {
        "<Leader>tt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "neotest - Run File",
      },
      {
        "<Leader>tT",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "neotest - Run All Test Files",
      },
      {
        "<Leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "neotest - Run Nearest",
      },
      {
        "<Leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "neotest - Run Last",
      },
      {
        "<Leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "neotest - Toggle Summary",
      },
      {
        "<Leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "neotest - Show Output",
      },
      {
        "<Leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "neotest - Toggle Output Panel",
      },
      {
        "<Leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "neotest - Stop",
      },
      {
        "<Leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "neotest - Toggle Watch",
      },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-plenary"),
          require("neotest-gtest").setup({}),
        },
      })
    end,
  },

  -- Browse
  -- TODO: Replace with browse.nvim
  {
    "tyru/open-browser.vim",
    cond = choose.is_enabled_plugin("open-browser.vim"),
    event = { "VeryLazy" },
  },
  {
    "axieax/urlview.nvim",
    cmd = { "UrlView" },
    keys = {
      { "<Leader>uu", [[<Cmd>UrlView buffer picker=telescope<CR>]], desc = "view buffer URLs" },
      { "<Leader>po", [[<Cmd>UrlView lazy picker=telescope<CR>]], desc = "view plugin URLs" },
    },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local urlview = require("vimrc.plugins.urlview")
      local has_secret_urlview, secret_urlview = pcall(require, "secret.urlview")

      require("urlview").setup({
        default_action = plugin_utils.get_browser(),
      })
      urlview.setup()

      if has_secret_urlview then
        secret_urlview.setup()
      end
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
    keys = {
      { "<C-W><C-R>", desc = "Start winresizer" },
    },
    init = function()
      vim.g.winresizer_start_key = "<C-W><C-R>"
    end,
  },
  {
    "sindrets/winshift.nvim",
    cmd = { "WinShift" },
    keys = {
      { "<C-W><C-M>", [[<Cmd>WinShift<CR>]], desc = "Start winshift" },
      { "<C-W>m", [[<Cmd>WinShift<CR>]], desc = "Start winshift" },
      { "<C-W>X", [[<Cmd>WinShift swap<CR>]], desc = "Start winshift swap" },
    },
  },

  -- Todo
  -- NOTE: Cannot lazy load on key, first buffer doesn't have TODO highlight
  {
    "folke/todo-comments.nvim",
    cond = choose.is_enabled_plugin("todo-comments.nvim"),
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        -- Search & highlight keywords with author
        -- Ref: https://github.com/folke/todo-comments.nvim/issues/10#issuecomment-2446101986
        -- TODO: Use builtin support after this PR merged: https://github.com/folke/todo-comments.nvim/issues/332
        search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
        highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
      })

      vim.keymap.set("n", "<F8>", "<Cmd>TodoTrouble<CR>")
      vim.keymap.set("n", "<Space><F8>", "<Cmd>TodoTelescope<CR>")
      -- Currently, it's impossible to type <C-F1> ~ <C-F12> using wezterm + tmux.
      -- wezterm with 'xterm-256color' + tmux with 'screen-256color' will
      -- generate keycode for <C-F1> ~ <C-F12> that recognized by neovim as <F25> ~ <F36>.
      vim.keymap.set("n", "<C-F8>", "<Cmd>TodoFzfLua<CR>")
      vim.keymap.set("n", "<F32>", "<Cmd>TodoFzfLua<CR>")
      vim.keymap.set("n", "[X", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })
      vim.keymap.set("n", "]X", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })
    end,
  },

  -- Regex
  {
    "OXY2DEV/patterns.nvim",
    cmd = { "Patterns" },
    keys = {
      { "<Leader>er", [[<Cmd>Patterns explain<CR>]], desc = "Patterns - explain" },
      { "<Leader>ek", [[<Cmd>Patterns hover<CR>]], desc = "Patterns - hover" },
    },
  },

  {
    "gennaro-tedesco/nvim-jqx",
    cond = plugin_utils.is_executable("jq"),
    ft = { "json", "yaml" },
  },

  -- Profile
  {
    "stevearc/profile.nvim",
    config = function()
      require("vimrc.plugins.profile").setup()
    end,
  },

  -- Translate
  {
    "askfiy/smart-translate.nvim",
    cmd = { "Translate" },
    dependencies = {
      "askfiy/http.nvim", -- a wrapper implementation of the Python aiohttp library that uses CURL to send requests.
    },
    opts = {
      default = {
        cmds = {
          target = "zh-TW",
        },
      },
    },
    keys = {
      { "<Leader>ta", mode = { "n" }, [[viw:Translate<CR>]], desc = "Translate word" },
      { "<Leader>ta", mode = { "x" }, [[:Translate<CR>]], desc = "Translate visual selection" },
    },
  },

  -- Color Column
  {
    "Bekaboo/deadcolumn.nvim",
    cond = choose.is_enabled_plugin("deadcolumn.nvim"),
    event = { "VeryLazy" },
    init = function()
      -- NOTE: Monitor this
      vim.opt.textwidth = 100
      vim.opt.colorcolumn = "+2"
    end,
    config = function()
      local palette = require("gruvbox").palette

      require("deadcolumn").setup({
        blending = {
          colorcode = palette.dark0,
          hlgroup = { "OpaqueNormal", "bg" },
        },
      })
    end,
  },

  -- Diff
  {
    "AndrewRadev/linediff.vim",
    cmd = { "Linediff" },
    keys = {
      { "<M-d>l", mode = { "n" }, [[V:Linediff<CR>]], desc = "Linediff current line" },
      { "<M-d>l", mode = { "x" }, [[:Linediff<CR>]], desc = "Linediff visual selection" },
    },
    config = function() end,
  },
  { "will133/vim-dirdiff", cmd = { "DirDiff" } },

  -- RESTful
  -- NOTE: Require 'hurl' to be installed
  {
    "jellydn/hurl.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = "hurl",
    opts = {
      -- Show debugging info
      debug = false,
      -- Show notification on run
      show_notification = false,
      -- Show response in popup or split
      mode = "split",
      -- Default formatter
      formatters = {
        json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
        html = {
          "prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
          "--parser",
          "html",
        },
        -- TODO: Install tidy through mason.nvim
        xml = {
          "tidy", -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
          "-xml",
          "-i",
          "-q",
        },
      },
      -- Default mappings for the response popup or split views
      mappings = {
        close = "q", -- Close the response popup or split view
        next_panel = "<C-N>", -- Move to the next response popup window
        prev_panel = "<C-P>", -- Move to the previous response popup window
      },
    },
    keys = {
      -- Run API request
      { "<Leader>uA", "<cmd>HurlRunner<CR>", desc = "Hurl - Run All requests" },
      { "<Leader>ua", "<cmd>HurlRunnerAt<CR>", desc = "Hurl - Run Api request" },
      { "<Leader>ue", "<cmd>HurlRunnerToEntry<CR>", desc = "Hurl - Run Api request to entry" },
      { "<Leader>uE", "<cmd>HurlRunnerToEnd<CR>", desc = "Hurl - Run Api request from current entry to end" },
      { "<Leader>um", "<cmd>HurlToggleMode<CR>", desc = "Hurl - Toggle Mode" },
      { "<Leader>uv", "<cmd>HurlVerbose<CR>", desc = "Hurl - Run Api in verbose mode" },
      { "<Leader>uV", "<cmd>HurlVeryVerbose<CR>", desc = "Hurl - Run Api in very verbose mode" },
      -- Run Hurl request in visual mode
      { "<Leader>ua", ":HurlRunner<CR>", desc = "Hurl - Runner", mode = "v" },
    },
  },
  {
    {
      "mistweaverco/kulala.nvim",
      keys = {
        { "<Leader>Ks", desc = "Send request" },
        { "<Leader>Ka", desc = "Send all requests" },
        { "<Leader>Kb", desc = "Open scratchpad" },
      },
      ft = { "http", "rest" },
      opts = {
        global_keymaps = true,
        global_keymaps_prefix = "<Leader>K",
        kulala_keymaps_prefix = "",
      },
    },
  },

  -- DB
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
    },
    cmd = { "DB", "DBUI" },
  },
  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
    cmd = { "Dbee" },
    config = function()
      require("dbee").setup({
        sources = {
          require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
          require("dbee.sources").FileSource:new(vim.fn.stdpath("cache") .. "/dbee/persistence.json"),
        },
      })
    end,
  },

  -- Draw
  -- TODO: Add key mappings
  {
    "LudoPinelli/comment-box.nvim",
    cond = not utils.is_light_vim_mode(),
  },

  -- Image
  -- -- TODO: Disabled as currently only don't show image but has the space.
  -- -- Tried: In tmux & outside of tmux in wezterm.
  -- -- Related issue: https://github.com/3rd/image.nvim/issues/99
  -- {
  --   "3rd/image.nvim",
  --   enabled = false,
  --   config = function()
  --     require("image").setup({})
  --   end,
  -- },
  {
    -- support for image pasting
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- recommended settings
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
        -- required for Windows users
        use_absolute_path = true,
      },
    },
    keys = {
      { "<Space>pi", "<Cmd>PasteImage<CR>", desc = "Paste image from system clipboard" },
    },
  },

  -- TUI
  {
    'jrop/tuis.nvim',
    keys = {
      { "<Leader>m,", function() require("tuis").choose() end, desc = "Choose Morph UI" },
    },
  },

  -- Meta
  {
    "noamsto/resolved.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {},
  },

  -- Do not lazy load vim-scriptease, as it breaks :Breakadd/:Breakdel
  -- TODO: Check if lazy load works
  {
    "tpope/vim-scriptease",
    cmd = { "PP", "Messages", "Verbose", "Time", "Scriptnames" },
  },
  {
    "tpope/vim-abolish",
    cmd = { "Abolish", "Subvert", "S" },
    keys = {
      { "cr", desc = "Coercion cursor word" },
    },
  },
  "kopischke/vim-fetch",
  {
    "Valloric/ListToggle",
    cmd = { "QToggle", "LToggle" },
    keys = {
      { "<Leader>q", desc = "Toggle quickfix" },
      { "<Leader>l", desc = "Toggle location list" },
    },
  },
  {
    "tpope/vim-eunuch",
    cmd = {
      "Remove",
      "Unlink",
      "Delete",
      "Copy",
      "Duplicate",
      "Move",
      "Rename",
      "Chmod",
      "Mkdir",
      "Cfind",
      "Lfind",
      "Clocate",
      "Llocate",
      "SudoEdit",
      "SudoWrite",
      "Wall",
      "W",
    },
  },
  { "tweekmonster/helpful.vim", cmd = { "HelpfulVersion" } },
  { "dstein64/vim-startuptime", cmd = { "StartupTime" } },
  { "kristijanhusak/vim-carbon-now-sh", cmd = { "CarbonNowSh" } },
  { "taybart/b64.nvim", cmd = { "B64Encode", "B64Decode" } },
}

return utility
