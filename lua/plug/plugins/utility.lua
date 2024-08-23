local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local utility = {
  -- Undo Tree
  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
    keys = {
      { "<F9>", "<Cmd>UndotreeToggle<CR>", desc = "Toggle undo tree" },
    },
  },
  -- NOTE: vim-mundo is slow, but is more feature-rich
  {
    "simnalamburt/vim-mundo",
    cmd = { "MundoToggle" },
    keys = {
      { "<Space><F9>", "<Cmd>MundoToggle<CR>", desc = "Toggle mundo tree" },
    },
    config = function()
      if vim.fn.has("python3") == 1 then
        vim.g.mundo_prefer_python3 = 1
      end
    end,
  },

  {
    "tpope/vim-characterize",
    keys = {
      { "gA", "<Plug>(characterize)", desc = "Show character info under cursor" },
    },
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
    keys = {
      {
        "<Leader>cT",
        mode = { "n" },
        [[<Cmd>Colortils picker black<CR>]],
        desc = "Open color picker",
      },
      {
        "<Leader>cT",
        mode = { "x" },
        [[:<C-U>execute 'Colortils picker '..vimrc#utility#get_visual_selection()<CR>]],
        desc = "Open color picker with visual selection",
      },
    },
    config = function()
      require("colortils").setup({
        mappings = {
          replace_default_format = "<M-CR>",
          replace_choose_format = "g<M-CR>",
        },
      })
    end,
  },

  -- Project
  {
    "ahmedkhalf/project.nvim",
    cond = not utils.is_light_vim_mode(),
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
      require("telescope").load_extension("projects")

      nnoremap("<Leader>pr", "<Cmd>ProjectRoot<CR>")
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
  -- TODO: Migrate to rocks.nvim
  -- NOTE: rocks.nvim installation script is outside of lazy.nvim & manual installation steps are tedious.
  -- TODO: Check https://vhyrro.github.io/posts/neorg-and-luarocks/
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
    "folke/zen-mode.nvim",
    cmd = { "ZenMode", "ZenModeCopy" },
    keys = {
      { "<Leader>zm", [[<Cmd>ZenMode<CR>]], desc = "Zen mode" },
      { "<Leader>zc", [[<Cmd>ZenModeCopy<CR>]], desc = "Zen mode copy" },
    },
    config = function()
      require("zen-mode").setup({
        plugins = {
          twilight = { enabled = false }, -- twilight.nvim with treesitter in zen-mode.nvim is extremely slow
        },
      })

      vim.api.nvim_create_user_command("ZenModeCopy", function()
        vim.cmd([[ZenMode]])
        vim.wo.number = false
        vim.wo.statuscolumn = ""
        vim.wo.winbar = ""
        vim.wo.list = not vim.wo.list
        require("vimrc.lsp").toggle_show_diagnostics()
        vim.cmd([[IndentBlanklineToggle]])
        vim.cmd([[TwilightDisable]])
        vim.cmd([[BlockOff]])
      end, {})
    end,
  },
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = {
      { "<Leader><C-L>", ":Twilight<CR>", desc = "Twilight toggle" },
    },
  },
  {
    "hoschi/yode-nvim",
    keys = {
      { "<Leader>yc", [[<Cmd>YodeCreateSeditorFloating<CR>]], desc = "Yode - create editor in float" },
      { "<Leader>yr", [[<Cmd>YodeCreateSeditorReplace<CR>]], desc = "Yode - create editor in current window" },
    },
    config = function()
      require("yode-nvim").setup({})

      nnoremap("<Leader>bd", [[:YodeBufferDelete<CR>]])

      nnoremap("<C-W>r", [[<Cmd>YodeLayoutShiftWinDown<CR>]])
      nnoremap("<C-W>R", [[<Cmd>YodeLayoutShiftWinUp<CR>]])
      nnoremap("<C-W>J", [[<Cmd>YodeLayoutShiftWinBottom<CR>]])
      nnoremap("<C-W>K", [[<Cmd>YodeLayoutShiftWinTop<CR>]])

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
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      -- TODO Check if disabling tmux is good
      -- As currently, it break tmux zoom.
      -- But using Job makes closing vim while git push failed
      vim.g.dispatch_no_tmux_make = 1
    end,
  },
  {
    "stevearc/overseer.nvim",
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
      { "<Space>ro", [[<Cmd>OverseerToggle<CR>]], desc = "Overseer toggle" },
      { "<Space>rr", [[<Cmd>OverseerRun<CR>]], desc = "Overseer run" },
      { "<Space>rR", [[<Cmd>OverseerRunCmd<CR>]], desc = "Overseer run cmd" },
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
    keys = { "<Leader>cc", "<Leader>cC", "<Leader>cl" },
    dependencies = { "stevearc/overseer.nvim" },
    config = function()
      require("compiler").setup({})

      -- Open compiler
      vim.api.nvim_set_keymap("n", "<Leader>cc", "<Cmd>CompilerOpen<CR>", { noremap = true, silent = true })

      -- Redo last selected option
      vim.api.nvim_set_keymap(
        "n",
        "<Leader>cl",
        "<Cmd>CompilerStop<CR>" -- (Optional, to dispose all tasks before redo)
          .. "<Cmd>CompilerRedo<CR>",
        { noremap = true, silent = true }
      )

      -- Toggle compiler results
      vim.api.nvim_set_keymap("n", "<Leader>cv", "<Cmd>CompilerToggleResults<CR>", { noremap = true, silent = true })
    end,
  },

  -- Do not lazy load vim-scriptease, as it breaks :Breakadd/:Breakdel
  -- TODO: Check if lazy load works
  { "tpope/vim-scriptease", cmd = { "PP", "Messages", "Verbose", "Time", "Scriptnames" } },

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
      { "<Leader>ul", [[<Cmd>UrlView lazy picker=telescope<CR>]], desc = "view plugin URLs" },
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

  -- Colorizer
  -- NOTE: Cannot lazy load on key, first buffer doesn't have color highlight
  {
    "NvChad/nvim-colorizer.lua",
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
    cond = not utils.is_light_vim_mode(),
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({})

      nnoremap("<F8>", "<Cmd>TodoTrouble<CR>")
      nnoremap("<Space><F8>", "<Cmd>TodoTelescope<CR>")
      nnoremap("[X", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })
      nnoremap("]X", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })
    end,
  },

  {
    "bennypowers/nvim-regexplainer",
    cmd = { "RegexplainerToggle" },
    keys = {
      { "<Leader>er", desc = "Toggle regexplainer" },
    },
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
    "gennaro-tedesco/nvim-jqx",
    cond = vim.fn.executable("jq") == 1,
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
    "uga-rosa/translate.nvim",
    cmd = { "Translate" },
    keys = {
      { "<Leader>tr", mode = { "n" }, [[viw:Translate ZH-TW<CR>]], desc = "Translate word" },
      { "<Leader>tr", mode = { "x" }, [[:Translate ZH-TW<CR>]], desc = "Translate visual selection" },
    },
  },

  -- Color Column
  {
    "Bekaboo/deadcolumn.nvim",
    cond = not utils.is_light_vim_mode(),
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
  -- TODO: Migrate to kulala.nvim
  -- TODO: Check if not working on Windows
  -- TODO: Migrate to rocks.nvim
  -- NOTE: rocks.nvim installation script is outside of lazy.nvim & manual installation steps are tedious.
  -- TODO: rest.nvim is back again with v3, may try out
  {
    "rest-nvim/rest.nvim",
    enabled = false,
    dependencies = { { "nvim-lua/plenary.nvim" } },
    ft = { "http" },
    config = function()
      require("rest-nvim").setup({})

      nnoremap("<Leader>rr", [[<Plug>RestNvim]], "nowait")
      nnoremap("<Leader>rp", [[<Plug>RestNvimPreview]], "nowait")
      nnoremap("<Leader>rl", [[<Plug>RestNvimLast]], "nowait")
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

  -- Draw
  -- TODO: Add key mappings
  {
    "LudoPinelli/comment-box.nvim",
    cond = not utils.is_light_vim_mode(),
  },

  -- Big file
  {
    "LunarVim/bigfile.nvim",
    config = function()
      -- default config
      require("bigfile").setup({
        filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
        pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
        features = { -- features to disable
          "indent_blankline",
          "illuminate",
          "lsp",
          "treesitter",
          "syntax",
          "matchparen",
          "vimopts",
          "filetype",
        },
      })
    end,
  },

  -- Image
  -- TODO: Disabled as currently only don't show image but has the space.
  -- Tried: In tmux & outside of tmux in wezterm.
  -- Related issue: https://github.com/3rd/image.nvim/issues/99
  {
    "3rd/image.nvim",
    enabled = false,
    config = function()
      require("image").setup({})
    end,
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
  { "tweekmonster/startuptime.vim", cmd = { "StartupTime" } },
  { "lambdalisue/reword.vim", event = { "CmdlineEnter" } },
  { "nicwest/vim-http", cmd = { "Http" } },
  { "kristijanhusak/vim-carbon-now-sh", cmd = { "CarbonNowSh" } },
  { "taybart/b64.nvim", cmd = { "B64Encode", "B64Decode" } },

  -- nvim-gdb
  -- Disabled for now as neovim's neovim_gdb.vim seems not exists
  -- {
  --   'sakhnik/nvim-gdb',
  --   build = './install.sh',
  --   cond = vim.fn.has("nvim") == 1,
  -- }
}

return utility
