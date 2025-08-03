local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")

local markdown_filetypes = vim.tbl_filter(function(component)
  return component ~= nil
end, {
  "markdown",
  plugin_utils.check_enabled_plugin("Avante", "avante.nvim"),
  plugin_utils.check_enabled_plugin("codecompanion", "codecompanion.nvim"),
})

local languages = {
  -- filetype
  { "rust-lang/rust.vim", ft = { "rust" } },
  { "leafo/moonscript-vim", ft = { "moon" } },
  { "vim-crystal/vim-crystal", ft = { "crystal" } },
  {
    "plasticboy/vim-markdown",
    ft = { "markdown" },
    dependencies = { "godlygeek/tabular", "opdavies/toggle-checkbox.nvim" },
    config = function()
      -- TODO: Find a way to retain folding without confusing diff mode
      vim.g.vim_markdown_folding_disabled = 1

      vim.keymap.set("n", "<Leader>wg", "<Cmd>lua require('toggle-checkbox').toggle()<CR>")
    end,
  },
  { "mtdl9/vim-log-highlighting", ft = { "log" } },
  { "ClockworkNet/vim-apparmor", ft = { "apparmor" } },
  { "chrisbra/csv.vim", ft = { "csv" } },
  {
    "bfredl/nvim-luadev",
    ft = { "lua" },
    cmd = { "Luadev" },
  },
  { "wavded/vim-stylus", ft = "stylus" },
  { "alunny/pegjs-vim", ft = "pegjs" },
  { "moon-musick/vim-logrotate", ft = "logrotate" },
  { "jidn/vim-dbml", ft = "dbml" },

  -- Highlighing
  -- nvim-treesitter
  -- TODO: Move to dedicate place?
  -- TODO: Simplify condition
  {
    "nvim-treesitter/nvim-treesitter",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    build = ":TSUpdate",
    event = { "VeryLazy" },
    config = function()
      require("vimrc.plugins.nvim_treesitter").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "VeryLazy" },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "VeryLazy" },
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    config = function()
      require("ts_context_commentstring").setup({})
    end,
  },

  -- Navigate
  {
    "mfussenegger/nvim-treehopper",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      {
        "m",
        [[<Cmd>lua require("vimrc.plugins.nvim_treesitter").tsht_nodes("m")<CR>]],
        mode = { "o" },
        silent = true,
        desc = "treehopper nodes",
      },
      {
        "m",
        [[:lua require("vimrc.plugins.nvim_treesitter").tsht_nodes("m")<CR>]],
        mode = { "x" },
        silent = true,
        desc = "treehopper nodes",
      },
    },
  },
  -- TODO: It's archived, need to find replacement
  -- Replace with [aaroniktreewalker.nvim A neovim plugin for fast navigation around the abstract syntax tree](https://github.com/aaronik/treewalker.nvim)
  {
    "ziontee113/syntax-tree-surfer",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      -- Normal Mode Swapping:
      -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
      { "vU", mode = { "n" }, desc = "STS swap up" },
      { "vD", mode = { "n" }, desc = "STS swap down" },

      -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
      {
        "vd",
        mode = { "n" },
        desc = "STS swap current node to next",
      },
      {
        "vu",
        mode = { "n" },
        desc = "STS swap current node to previous",
      },

      -- Visual Selection from Normal Mode
      { "vx", mode = { "n" }, desc = "STS select master node" },
      {
        "vn",
        mode = { "n" },
        desc = "STS select current node",
      },

      -- Select Nodes in Visual Mode
      {
        "<M-j>",
        mode = { "x" },
        desc = "STS select next sibling node",
      },
      {
        "<M-k>",
        mode = { "x" },
        desc = "STS select previous sibling node",
      },
      { "<M-h>", mode = { "x" }, desc = "STS select parent node" },
      { "<M-l>", mode = { "x" }, desc = "STS select child node" },

      -- Swapping Nodes in Visual Mode
      { "<M-S-j>", mode = { "x" }, desc = "STS swap to next" },
      { "<M-S-k>", mode = { "x" }, desc = "STS swap to previous" },

      -- Targeted jump
      {
        vim.g.text_navigation_leader .. "r",
        mode = { "n" },
        desc = "STS default targeted jump",
      },
      {
        vim.g.text_navigation_leader .. vim.g.text_navigation_leader,
        mode = { "n" },
        desc = "STS default targeted jump",
      },
      {
        vim.g.text_navigation_leader .. "i",
        mode = { "n" },
        desc = "STS literal targeted jump",
      },

      -- filtered jump
      {
        "<M-s>n",
        mode = { "n" },
        desc = "STS filtered jump forward",
      },
      {
        "<M-s>p",
        mode = { "n" },
        desc = "STS filtered jump backward",
      },
    },
    config = function()
      require("vimrc.plugins.syntax_tree_surfer").setup()
    end,
  },

  -- Highlight arguments
  {
    "m-demare/hlargs.nvim",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "VeryLazy" },
    config = function()
      -- TODO: Move to nvim_treesitter.lua
      local hlargs = require("hlargs")

      hlargs.setup()

      local hlargs_augroup_id = vim.api.nvim_create_augroup("hlargs_settings", {})
      vim.api.nvim_create_autocmd({ "OptionSet" }, {
        group = hlargs_augroup_id,
        pattern = "diff",
        callback = function()
          if vim.api.nvim_get_option_value("diff", {}) then
            hlargs.disable()
          else
            hlargs.enable()
          end
        end,
      })
    end,
  },

  -- Highlight bracket
  {
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "fennel", "query" },
    config = function()
      -- This module contains a number of default definitions
      local rainbow_delimiters = require("rainbow-delimiters")

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          commonlisp = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
        whitelist = { "fennel", "query" },
      }
    end,
  },
  {
    "HampusHauffman/block.nvim",
    cmd = { "Block", "BlockOn", "BlockOff" },
    keys = {
      { "<Leader>bo", "<Cmd>Block<CR>", desc = "Toggle block" },
    },
    opts = {},
  },

  -- Indent
  {
    "yioneko/nvim-yati",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "VeryLazy" },
  },

  -- Refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    cmd = { "Refactor", "RefactoringAddPrintf", "RefactoringAddPrintVar" },
    keys = {
      -- Refactor
      {
        "<Space>re",
        mode = { "x" },
        function()
          require("refactoring").refactor("Extract Function")
        end,
        desc = "Extract Function",
      },
      {
        "<Space>rf",
        mode = { "x" },
        function()
          require("refactoring").refactor("Extract Function To File")
        end,
        desc = "Extract Function To File",
      },
      {
        "<Space>rv",
        mode = { "x" },
        function()
          require("refactoring").refactor("Extract Variable")
        end,
        desc = "Extract Variable",
      },
      {
        "<Space>rI",
        mode = { "n" },
        function()
          require("refactoring").refactor("Inline Function")
        end,
        desc = "Inline Function",
      },
      {
        "<Space>ri",
        mode = { "n", "x" },
        function()
          require("refactoring").refactor("Inline Variable")
        end,
        desc = "Inline Variable",
      },
      {
        "<Space>rb",
        mode = { "n" },
        function()
          require("refactoring").refactor("Extract Block")
        end,
        desc = "Extract Block",
      },
      {
        "<Space>rbf",
        mode = { "n" },
        function()
          require("refactoring").refactor("Extract Block To File")
        end,
        desc = "Extract Block To File",
      },

      -- Telescope refactoring menu
      {
        "<Space>rm",
        mode = { "n", "x" },
        function()
          if choose.is_enabled_plugin("telescope.nvim") then
            require("telescope").extensions.refactoring.refactors()
          else
            vim.notify("telescope.nvim is not loaded", vim.log.levels.WARN, { title = "refactoring.nvim" })
          end
        end,
        desc = "Telescope refactoring",
      },

      -- Debug print
      {
        "<Space>rp",
        mode = { "n" },
        function()
          require("refactoring").debug.printf({ below = true })
        end,
        desc = "Debug print below",
      },
      {
        "<Space>rP",
        mode = { "n" },
        function()
          require("refactoring").debug.printf({ below = false })
        end,
        desc = "Debug print above",
      },

      -- Print var
      {
        "<Space>rk",
        mode = { "n", "x" },
        function()
          require("refactoring").debug.print_var({ below = true })
        end,
        desc = "Print var",
      },
      {
        "<Space>rK",
        mode = { "n", "x" },
        function()
          require("refactoring").debug.print_var({ below = false })
        end,
        desc = "Print var",
      },
      {
        "<Space>rc",
        mode = { "n" },
        function()
          require("refactoring").debug.cleanup({})
        end,
        desc = "Cleanup debug print",
      },
    },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      -- TODO: Extract into setup function
      local refactoring = require("vimrc.plugins.refactoring")
      local has_secret_refactoring, secret_refactoring = pcall(require, "secret.refactoring")
      local config = {}

      if has_secret_refactoring then
        config = vim.tbl_deep_extend("force", config, secret_refactoring.config or {})
      end

      refactoring.setup(config)

      -- Customize Debug Command
      vim.api.nvim_create_user_command("RefactoringAddPrintf", refactoring.add_printf, {})
      vim.api.nvim_create_user_command("RefactoringAddPrintVar", refactoring.add_print_var, {})

      -- load refactoring Telescope extension
      if choose.is_enabled_plugin("telescope.nvim") then
        require("telescope").load_extension("refactoring")
      end
    end,
  },

  -- Swap
  {
    "mizlan/iswap.nvim",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "ISwap", "ISwapWith", "ISwapNode", "ISwapNodeWith", "ISwapNodeWithLeft", "ISwapNodeWithRight" },
    keys = {
      { "<Space>ii", [[<Cmd>ISwap<CR>]], desc = "ISwap" },
      { "<Space>iw", [[<Cmd>ISwapWith<CR>]], desc = "ISwap with" },
      { "<Space>in", [[<Cmd>ISwapNode<CR>]], desc = "ISwap node" },
      { "<Space>im", [[<Cmd>ISwapNodeWith<CR>]], desc = "ISwap node with" },
      { "<Space>i,", [[<Cmd>ISwapNodeWithLeft<CR>]], desc = "ISwap node with left" },
      { "<Space>i.", [[<Cmd>ISwapNodeWithRight<CR>]], desc = "ISwap node with right" },
    },
  },

  -- treesitter parser
  {
    "IndianBoy42/tree-sitter-just",
    ft = { "just" },
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("tree-sitter-just").setup({})

      require("nvim-treesitter.install").ensure_installed({ "just" })
    end,
  },

  -- Context
  {
    "nvim-treesitter/nvim-treesitter-context",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "VeryLazy" },
    config = function()
      -- NOTE: nvim-treesitter config is in nvim_treesitter.lua
      vim.keymap.set("n", "<F6>", function()
        require("vimrc.plugins.nvim_treesitter").toggle_context()
      end, { desc = "Toggle treesitter context" })
      vim.keymap.set("n", "gup", function()
        require("treesitter-context").go_to_context()
      end, { desc = "Go to parent context" })
    end,
  },

  -- TODO: Replace with emmet lsp
  {
    "mattn/emmet-vim",
    keys = {
      { "<M-m>", mode = { "i" }, desc = "Emmet prefix" },
    },
    init = function()
      vim.g.user_emmet_leader_key = "<M-m>"
    end,
  },

  -- Cscope
  {
    "dhananjaylatkar/cscope_maps.nvim",
    cmd = { "Cscope" },
    config = function()
      require("cscope_maps").setup({
        disable_maps = true,
      })
    end,
  },
  {
    "mars90226/cscope_macros.vim",
    keys = {
      { "<F11>", [[<Cmd>lua require("vimrc.cscope").generate_files()<CR>]], desc = "Generate cscope files" },
      { "<Space><F11>", [[<Cmd>lua require("vimrc.cscope").reload()<CR>]], desc = "Reload cscope files" },
    },
  },

  -- Markdown render
  {
    "MeanderingProgrammer/render-markdown.nvim",
    cond = choose.is_enabled_plugin("render-markdown.nvim"),
    ft = markdown_filetypes,
    cmd = { "RenderMarkdownToggle" },
    keys = {
      { "coh", "<Cmd>RenderMarkdownToggle<CR>", mode = { "n" }, desc = "Render markdown" },
    },
    opts = {
      filetypes = markdown_filetypes,
    },
  },
  {
    "OXY2DEV/markview.nvim",
    cond = choose.is_enabled_plugin("markview.nvim"),
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    -- TODO: Disabled Markview on huge file
    ft = markdown_filetypes,
    cmd = { "Markview" },
    keys = {
      { "coh", "<Cmd>Markview<CR>", mode = { "n" }, desc = "Render markdown" },
    },
    -- TODO: Custom based on https://github.com/OXY2DEV/markview.nvim/wiki
    opts = {
      preview = {
        filetypes = markdown_filetypes,
      },
    },
    config = function(_, opts)
      local preset = require("markview.presets")
      opts = vim.tbl_deep_extend("force", {
        markdown = {
          headings = preset.headings.arrowed,
        }
      }, opts or {})

      require("markview").setup(opts)
    end,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app & npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_open_to_the_world = 1

      -- NOTE: markdown-preview.nvim will detect wsl and use Windows start to
      -- execute browser. Currently, open_url.sh exists only in WSL and cannot
      -- be called from Windows.
      if vim.fn.has("wsl") ~= 1 and plugin_utils.is_executable("open_url.sh") then
        vim.g.mkdp_browser = "open_url.sh"
      end
    end,
  },
  {
    "ellisonleao/glow.nvim",
    ft = { "markdown" },
    cmd = { "Glow" },
    config = function()
      require("glow").setup({
        border = "rounded",
        width_ratio = vim.g.float_width_ratio,
        height_ratio = vim.g.float_height_ratio,
      })
    end,
  },

  {
    "AckslD/nvim-FeMaco.lua",
    ft = { "markdown" },
    cmd = { "FeMaco" },
    config = function()
      require("femaco").setup()
    end,
  },

  -- NOTE: Mappings may conflict with other plugin (mapping prefix: <Leader>t/<Leader>T)
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown" },
  },

  {
    "fatih/vim-go",
    ft = { "go" },
    build = ":GoUpdateBinaries",
    init = function()
      vim.g.go_decls_mode = "fzf"

      -- TODO Add key mappings for vim-go commands
    end,
  },

  { "apeschel/vim-syntax-syslog-ng" },

  -- Documentation generator
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = { "Neogen" },
    keys = {
      { "<Leader>ng", [[<Cmd>Neogen<CR>]], desc = "Generate documentation" },
      { "<Leader>nf", [[<Cmd>Neogen func<CR>]], desc = "Generate function documentation" },
      { "<Leader>ni", [[<Cmd>Neogen file<CR>]], desc = "Generate file documentation" },
      { "<Leader>nt", [[<Cmd>Neogen type<CR>]], desc = "Generate type documentation" },
      { "<Leader>nc", [[<Cmd>Neogen class<CR>]], desc = "Generate class documentation" },
    },
    config = function()
      require("neogen").setup({
        snippet_engine = "luasnip",
      })
    end,
  },

  -- Documentation
  {
    "maskudo/devdocs.nvim",
    enabled = choose.is_enabled_plugin("devdocs.nvim"),
    dependencies = {
      "folke/snacks.nvim",
    },
    keys = {
      {
        "<Space>dc",
        mode = "n",
        "<Cmd>DevDocs get<CR>",
        desc = "Get Devdocs",
      },
      {
        "<Space>di",
        mode = "n",
        "<Cmd>DevDocs install<CR>",
        desc = "Install Devdocs",
      },
      {
        "<Space>do",
        mode = "n",
        function()
          local devdocs = require("devdocs")
          local installedDocs = devdocs.GetInstalledDocs()
          vim.ui.select(installedDocs, {}, function(selected)
            if not selected then
              return
            end
            local docDir = devdocs.GetDocDir(selected)
            -- prettify the filename as you wish
            Snacks.picker.files({ cwd = docDir })
          end)
        end,
        desc = "View Devdocs",
      },
    },
    opts = {
      ensure_installed = {
        "cpp",
        -- "go",
        "html",
        -- "dom",
        "http",
        -- "css",
        -- "javascript",
        "python~3.11",
        "python~3.10",
        "rust",
        -- some docs such as lua require version number along with the language name
        -- check `DevDocs install` to view the actual names of the docs
        "lua~5.1",
        "postgresql~11",
        -- "openjdk~21"
        "typescript",
        "vue~3",
      },
    },
  },
  {
    "rhysd/rust-doc.vim",
    ft = { "rust" },
    config = function()
      vim.g["rust_doc#define_map_K"] = 0
      vim.g["rust_doc#vim_open_cmd"] = "RustDocOpen"

      vim.cmd([[command! -nargs=1 RustDocOpen call vimrc#rust_doc#open(<f-args>)]])
    end,
  },
  { "mars90226/perldoc-vim", ft = { "perl" } },
  {
    "fs111/pydoc.vim",
    ft = { "python" },
    config = function()
      vim.g.pydoc_perform_mappings = 0
    end,
  },

  -- Utility
  -- Rust
  {
    "saecki/crates.nvim",
    tag = "stable",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufRead Cargo.toml" },
    config = function()
      local crates = require("crates")
      crates.setup({
        -- NOTE: This config is for nightly
        -- src = {
        --   cmp = {
        --     enabled = true,
        --   },
        -- },
        open_programs = { plugin_utils.get_browser(), "xdg-open", "open" },
        null_ls = {
          enabled = false,
          name = "crates.nvim",
        },
        -- TODO: Enable LSP for hover or change hover function?
      })

      local crates_prefix = "<Leader><Leader>c"

      -- TODO: Use keys
      vim.keymap.set("n", crates_prefix .. "t", crates.toggle, { silent = true, desc = "Crates - Toggle crates" })
      vim.keymap.set("n", crates_prefix .. "r", crates.reload, { silent = true, desc = "Crates - Reload crates" })

      vim.keymap.set("n", crates_prefix .. "v", crates.show_versions_popup, { silent = true, desc = "Crates - Show versions popup" })
      vim.keymap.set("n", crates_prefix .. "f", crates.show_features_popup, { silent = true, desc = "Crates - Show features popup" })
      vim.keymap.set("n", crates_prefix .. "d", crates.show_dependencies_popup, { silent = true, desc = "Crates - Show dependencies popup" })

      vim.keymap.set("n", crates_prefix .. "u", crates.update_crate, { silent = true, desc = "Crates - Update crate" })
      vim.keymap.set("v", crates_prefix .. "u", crates.update_crates, { silent = true, desc = "Crates - Update selected crates" })
      vim.keymap.set("n", crates_prefix .. "a", crates.update_all_crates, { silent = true, desc = "Crates - Update all crates" })
      vim.keymap.set("n", crates_prefix .. "U", crates.upgrade_crate, { silent = true, desc = "Crates - Upgrade crate" })
      vim.keymap.set("v", crates_prefix .. "U", crates.upgrade_crates, { silent = true, desc = "Crates - Upgrade selected crates" })
      vim.keymap.set("n", crates_prefix .. "A", crates.upgrade_all_crates, { silent = true, desc = "Crates - Upgrade all crates" })

      vim.keymap.set("n", crates_prefix .. "x", crates.expand_plain_crate_to_inline_table, { silent = true, desc = "Crates - Expand crate to inline table" })
      vim.keymap.set("n", crates_prefix .. "X", crates.extract_crate_into_table, { silent = true, desc = "Crates - Extract crate into table" })

      vim.keymap.set("n", crates_prefix .. "H", crates.open_homepage, { silent = true, desc = "Crates - Open crate homepage" })
      vim.keymap.set("n", crates_prefix .. "R", crates.open_repository, { silent = true, desc = "Crates - Open crate repository" })
      vim.keymap.set("n", crates_prefix .. "D", crates.open_documentation, { silent = true, desc = "Crates - Open crate documentation" })
      vim.keymap.set("n", crates_prefix .. "C", crates.open_crates_io, { silent = true, desc = "Crates - Open crates.io page" })
      vim.keymap.set("n", crates_prefix .. "L", crates.open_lib_rs, { silent = true, desc = "Crates - Open lib.rs page" })
    end,
  },
  -- TypeScript
  {
    "OlegGulevskyy/better-ts-errors.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = { '<Leader>dd', '<Leader>dx' },
    opts = {
      keymaps = {
        toggle = '<Leader>dd',
        go_to_definition = '<Leader>dx',
      },
    },
  },
}

return languages
