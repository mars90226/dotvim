local choose = require("vimrc.choose")

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

      nnoremap("<Leader>wg", "<Cmd>lua require('toggle-checkbox').toggle()<CR>")
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
  { "mustache/vim-mustache-handlebars", ft = { "handlebars", "mustache" } },
  { "wavded/vim-stylus", ft = "stylus" },
  { "alunny/pegjs-vim", ft = "pegjs" },
  { "moon-musick/vim-logrotate", ft = "logrotate" },

  -- Highlighing
  -- nvim-treesitter
  -- TODO: Move to dedicate place?
  -- TODO: Simplify condition
  {
    "nvim-treesitter/nvim-treesitter",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    build = ":TSUpdate",
    config = function()
      require("vimrc.plugins.nvim_treesitter").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-refactor",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    config = function()
      require("ts_context_commentstring").setup({})
    end,
  },
  -- TODO: Cannot lazy load on keys
  {
    "mfussenegger/nvim-treehopper",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  -- TODO: Cannot lazy load on keys
  {
    "RRethy/nvim-treesitter-textsubjects",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  },
  {
    "m-demare/hlargs.nvim",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
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
      { "vd", mode = { "n" }, desc = "STS swap current node to next" },
      { "vu", mode = { "n" }, desc = "STS swap current node to previous" },

      -- Visual Selection from Normal Mode
      { "vx", mode = { "n" }, desc = "STS select master node" },
      { "vn", mode = { "n" }, desc = "STS select current node" },

      -- Select Nodes in Visual Mode
      { "<M-j>", mode = { "x" }, desc = "STS select next sibling node" },
      { "<M-k>", mode = { "x" }, desc = "STS select previous sibling node" },
      { "<M-h>", mode = { "x" }, desc = "STS select parent node" },
      { "<M-l>", mode = { "x" }, desc = "STS select child node" },

      -- Swapping Nodes in Visual Mode
      { "<M-S-j>", mode = { "x" }, desc = "STS swap to next" },
      { "<M-S-k>", mode = { "x" }, desc = "STS swap to previous" },

      -- Targeted jump
      { vim.g.text_navigation_leader .. "r", mode = { "n" }, desc = "STS default targeted jump" },
      { vim.g.text_navigation_leader .. vim.g.text_navigation_leader, mode = { "n" }, desc = "STS default targeted jump" },
      { vim.g.text_navigation_leader .. "i", mode = { "n" }, desc = "STS literal targeted jump" },

      -- filtered jump
      { "<M-s>n", mode = { "n" }, desc = "STS filtered jump forward" },
      { "<M-s>p", mode = { "n" }, desc = "STS filtered jump backward" },
    },
    config = function()
      require("vimrc.plugins.syntax_tree_surfer").setup()
    end,
  },
  {
    "yioneko/nvim-yati",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  },
  {
    "ThePrimeagen/refactoring.nvim",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    cmd = { "Refactor", "RefactoringAddPrintf", "RefactoringAddPrintVar" },
    keys = {
      -- Remaps for the refactoring operations currently offered by the plugin
      { "<Space>re", mode = { "v" } },
      { "<Space>rf", mode = { "v" } },
      { "<Space>rv", mode = { "v" } },
      { "<Space>ri", mode = { "v" } },

      -- Extract block doesn't need visual mode
      -- FIXME: Not working
      { "<Space>rb", mode = { "n" } },
      { "<Space>rbf", mode = { "n" } },

      -- Inline variable can also pick up the identifier currently under the cursor without visual mode
      { "<Space>ri", mode = { "n" } },

      -- remap to open the Telescope refactoring menu in visual mode
      { "<Space>rr", mode = { "v" } },

      -- Debug print
      { "<Space>rp", mode = { "n" } },
      { "<Space>rP", mode = { "n" } },

      -- Print var
      -- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
      -- Remap in visual mode will print whatever is in the visual selection
      { "<Space>rk", mode = { "n", "v" } },
      { "<Space>rc", mode = { "v" } },
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

      -- Remaps for the refactoring operations currently offered by the plugin
      vim.api.nvim_set_keymap(
        "v",
        "<Space>re",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
        { noremap = true, silent = true, expr = false }
      )
      vim.api.nvim_set_keymap(
        "v",
        "<Space>rf",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
        { noremap = true, silent = true, expr = false }
      )
      vim.api.nvim_set_keymap(
        "v",
        "<Space>rv",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
        { noremap = true, silent = true, expr = false }
      )
      vim.api.nvim_set_keymap(
        "v",
        "<Space>ri",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
        { noremap = true, silent = true, expr = false }
      )

      -- Extract block doesn't need visual mode
      vim.api.nvim_set_keymap(
        "n",
        "<Space>rb",
        [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
        { noremap = true, silent = true, expr = false }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<Space>rbf",
        [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
        { noremap = true, silent = true, expr = false }
      )

      -- Inline variable can also pick up the identifier currently under the cursor without visual mode
      vim.api.nvim_set_keymap(
        "n",
        "<Space>ri",
        [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
        { noremap = true, silent = true, expr = false }
      )

      -- remap to open the Telescope refactoring menu in visual mode
      vim.api.nvim_set_keymap(
        "v",
        "<Space>rr",
        "<Esc><Cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
        { noremap = true }
      )

      -- Debug print
      vim.api.nvim_set_keymap(
        "n",
        "<Space>rp",
        ":lua require('refactoring').debug.printf({below = true})<CR>",
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<Space>rP",
        ":lua require('refactoring').debug.printf({below = false})<CR>",
        { noremap = true }
      )

      -- Print var

      -- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
      vim.api.nvim_set_keymap(
        "n",
        "<Space>rk",
        ":lua require('refactoring').debug.print_var({ normal = true })<CR>",
        { noremap = true }
      )
      -- Remap in visual mode will print whatever is in the visual selection
      vim.api.nvim_set_keymap(
        "v",
        "<Space>rk",
        ":lua require('refactoring').debug.print_var({})<CR>",
        { noremap = true }
      )

      -- Cleanup function: this remap should be made in normal mode
      vim.api.nvim_set_keymap("n", "<Space>rc", ":lua require('refactoring').debug.cleanup({})<CR>", { noremap = true })

      -- Customize Debug Command
      vim.api.nvim_create_user_command("RefactoringAddPrintf", refactoring.add_printf, {})
      vim.api.nvim_create_user_command("RefactoringAddPrintVar", refactoring.add_print_var, {})

      -- load refactoring Telescope extension
      require("telescope").load_extension("refactoring")
    end,
  },
  {
    "mizlan/iswap.nvim",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "ISwap", "ISwapWith", "ISwapNode", "ISwapNodeWith", "ISwapNodeWithLeft", "ISwapNodeWithRight" },
    keys = { "<Space>ii", "<Space>iw", "<Space>in", "<Space>im", "<Space>i,", "<Space>i." },
    config = function()
      require("iswap").setup()

      nnoremap("<Space>ii", [[<Cmd>ISwap<CR>]])
      nnoremap("<Space>iw", [[<Cmd>ISwapWith<CR>]])
      nnoremap("<Space>in", [[<Cmd>ISwapNode<CR>]])
      nnoremap("<Space>im", [[<Cmd>ISwapNodeWith<CR>]])
      nnoremap("<Space>i,", [[<Cmd>ISwapNodeWithLeft<CR>]])
      nnoremap("<Space>i.", [[<Cmd>ISwapNodeWithRight<CR>]])
    end,
  },
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
    keys = { "<Leader>bo" },
    config = function()
      require("block").setup({})

      nnoremap("<Leader>bo", "<Cmd>Block<CR>")
    end,
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
    config = function()
      -- NOTE: nvim-treesitter config is in nvim_treesitter.lua
      nnoremap("<F6>", function()
        require("vimrc.plugins.nvim_treesitter").toggle_context()
      end, { desc = "Toggle treesitter context" })
      nnoremap("gup", function()
        require("treesitter-context").go_to_context()
      end, { desc = "Go to parent context" })
    end,
  },

  -- TODO: Replace with emmet lsp
  {
    "mattn/emmet-vim",
    keys = { { "<M-m>", mode = { "i" } } },
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
    keys = { "<F11>", "<Space><F11>" },
    config = function()
      nnoremap("<F11>", [[<Cmd>lua require("vimrc.cscope").generate_files()<CR>]])
      nnoremap("<Space><F11>", [[<Cmd>lua require("vimrc.cscope").reload()<CR>]])
    end,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app & npm install",
    init = function()
      local plugin_utils = require("vimrc.plugin_utils")

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
      require("glow").setup()
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
      "<Leader>ng",
      "<Leader>nf",
      "<Leader>ni",
      "<Leader>nt",
      "<Leader>nt",
    },
    config = function()
      require("neogen").setup({
        snippet_engine = "luasnip",
      })

      nnoremap("<Leader>ng", [[<Cmd>Neogen<CR>]], { desc = "Generate documentation" })
      nnoremap("<Leader>nf", [[<Cmd>Neogen func<CR>]], { desc = "Generate function documentation" })
      nnoremap("<Leader>ni", [[<Cmd>Neogen file<CR>]], { desc = "Generate file documentation" })
      nnoremap("<Leader>nt", [[<Cmd>Neogen type<CR>]], { desc = "Generate type documentation" })
      nnoremap("<Leader>nc", [[<Cmd>Neogen class<CR>]], { desc = "Generate class documentation" })
    end,
  },

  -- Documentation
  -- FIXME: Strange bug that cancel breaks telescope.nvim picker when search has no match on the
  -- first time. If cancelling the picker when search has match, and then cancelling again when search
  -- has no match, then it doesn't break telescope.nvim picker.
  {
    "luckasRanarison/nvim-devdocs",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsOpen",
      "DevdocsOpenFloat",
      "DevdocsOpenCurrent",
      "DevdocsOpenCurrentFloat",
      "DevdocsUpdate",
      "DevdocsUpdateAll",
    },
    keys = {
      "<Space>dc",
      "<Space>dC",
      "<Space>do",
      "<Space>dO",
    },
    config = function()
      require("nvim-devdocs").setup({
        float_win = {
          relative = "editor",
          height = math.floor(vim.o.lines * 0.9),
          width = math.floor(vim.o.columns * 0.8),
          border = "rounded",
        },
        after_open = function(bufnr)
          vim.wo.wrap = true
          nnoremap("gq", [[<Cmd>close<CR>]], { silent = true, buffer = true })
        end,
      })

      nnoremap(
        "<Space>dc",
        [[<Cmd>DevdocsOpenCurrentFloat<CR>]],
        { desc = "Open DevDocs of current file in floating window" }
      )
      nnoremap("<Space>dC", [[<Cmd>DevdocsOpenCurrent<CR>]], { desc = "Open DevDocs of current file" })
      nnoremap("<Space>do", [[<Cmd>DevdocsOpenFloat<CR>]], { desc = "Open DevDocs in floating window" })
      nnoremap("<Space>dO", [[<Cmd>DevdocsOpen<CR>]], { desc = "Open DevDocs" })
    end,
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
    tag = "v0.4.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup({
        -- NOTE: This config is for nightly
        -- src = {
        --   cmp = {
        --     enabled = true,
        --   },
        -- },
        null_ls = {
          enabled = choose.is_enabled_plugin("none-ls.nvim"),
          name = "crates.nvim",
        },
      })
    end,
  },
}

return languages
