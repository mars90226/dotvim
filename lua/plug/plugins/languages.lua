local choose = require("vimrc.choose")

local languages = {
  -- filetype
  { "rust-lang/rust.vim", ft = { "rust" } },
  { "leafo/moonscript-vim", ft = { "moon" } },
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
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    keys = { "<Space>hp", "<Space>hh" },
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
      })

      nnoremap("<Space>hp", [[<Cmd>TSPlaygroundToggle<CR>]])
      nnoremap("<Space>hh", [[<Cmd>TSHighlightCapturesUnderCursor<CR>]])
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "mfussenegger/nvim-treehopper",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "RRethy/nvim-treesitter-textsubjects",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "lewis6991/spellsitter.nvim",
    cond = choose.is_enabled_plugin("nvim-treesitter") and choose.is_enabled_plugin("spellsitter.nvim"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("spellsitter").setup()
    end,
  },
  {
    "m-demare/hlargs.nvim",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
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
    config = function()
      require("vimrc.plugins.syntax_tree_surfer").setup()
    end,
  },
  {
    "yioneko/nvim-yati",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    event = { "VeryLazy" },
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
        "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
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
    "p00f/nvim-ts-rainbow",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "HampusHauffman/block.nvim",
    cmd = { "Block", "BlockOn", "BlockOff" },
    keys = { "<Leader>bo" },
    config = function()
      require("block").setup({})

      nnoremap("<Leader>bo", "<Cmd>Block<CR>")
    end
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

  -- TODO: Remove vim-lsp-cxx-highlight when neovim 0.9.0 is stable
  -- ref: :help lsp-semantic-highlight
  {
    "jackguo380/vim-lsp-cxx-highlight",
    cond = choose.is_enabled_plugin("vim-lsp-cxx-highlight"),
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Context
  {
    "nvim-treesitter/nvim-treesitter-context",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- NOTE: nvim-treesitter config is in nvim_treesitter.lua
      nnoremap("<Space><F6>", ":TSContextToggle<CR>")
      nnoremap("gup", function()
        require("treesitter-context").go_to_context()
      end, { desc = "Go to parent context" })
    end,
  },
  {
    "SmiteshP/nvim-gps",
    cond = choose.is_enabled_plugin("nvim-treesitter") and choose.is_enabled_plugin("nvim-gps"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-gps").setup()
    end,
  },

  -- TODO: Replace with emmet lsp
  {
    "mattn/emmet-vim",
    keys = { "<M-m>" },
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

  {
    "rhysd/rust-doc.vim",
    ft = { "rust" },
    config = function()
      vim.g["rust_doc#define_map_K"] = 0
      vim.g["rust_doc#vim_open_cmd"] = "RustDocOpen"

      vim.cmd([[command! -nargs=1 RustDocOpen call vimrc#rust_doc#open(<f-args>)]])
    end,
  },

  { "apeschel/vim-syntax-syslog-ng" },

  {
    "kkoomen/vim-doge",
    build = function()
      vim.fn["doge#install"]()
    end,
    cmd = { "DogeGenerate", "DogeCreateDocStandard" },
    keys = { "<Leader><Leader>d" },
    init = function()
      vim.g.doge_mapping = "<Leader><Leader>d"
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
}

return languages
