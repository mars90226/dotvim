local choose = require("vimrc.choose")

local lsp = {
  -- Language Server Protocol
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        config = function()
          require("mason").setup()
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          require("mason-lspconfig").setup()
        end
      },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local lsp_configs = require("vimrc.lsp")

      -- Setup lsp servers
      lsp_configs.setup({})
    end,
  },
  {
    "tamago324/nlsp-settings.nvim",
    event = { "LspAttach" },
    config = function()
      require("nlspsettings").setup({
        config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
        local_settings_dir = ".nlsp-settings",
        local_settings_root_markers_fallback = { ".git" },
        append_default_schemas = true,
        loader = "json",
      })
    end,
  },

  {
    "ii14/lsp-command",
    event = { "VeryLazy" },
  },

  {
    "glepnir/lspsaga.nvim",
    branch = "main",
    event = { "LspAttach" },
    -- NOTE: config setup in vimrc.lsp.setup_plugins()
  },

  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    cmd = { "Trouble", "TroubleToggle" },
    keys = { "<Space>xx", "<Space>xw", "<Space>xd", "<Space>xq", "<Space>xl", "<Space>xr" },
    config = function()
      require("trouble").setup({})

      local opts = { noremap = true, silent = true }

      vim.keymap.set("n", "<Space>xx", "<Cmd>TroubleToggle<CR>", opts)
      vim.keymap.set("n", "<Space>xw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", opts)
      vim.keymap.set("n", "<Space>xd", "<Cmd>TroubleToggle document_diagnostics<CR>", opts)
      vim.keymap.set("n", "<Space>xq", "<Cmd>TroubleToggle quickfix<CR>", opts)
      vim.keymap.set("n", "<Space>xl", "<Cmd>TroubleToggle loclist<CR>", opts)
      vim.keymap.set("n", "<Space>xr", "<Cmd>TroubleToggle lsp_references<CR>", opts)

      -- jump to the next item, skipping the groups
      vim.keymap.set("n", "]g", [[<Cmd>lua require("trouble").next({ skip_groups = true, jump = true }),<CR>]], opts)

      -- jump to the previous item, skipping the groups
      vim.keymap.set("n", "[g", [[<Cmd>lua require("trouble").previous({ skip_groups = true, jump = true }),<CR>]], opts)
    end,
  },

  -- TODO: null-ls.nvim cause performance problem, need to find a way to fix this
  -- TODO: Due to performance issue, null-ls.nvim is disabled now
  {
    "jose-elias-alvarez/null-ls.nvim",
    enabled = false,
    cond = choose.is_enabled_plugin("null-ls.nvim"),
    event = { "VeryLazy" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    config = function()
      require("vimrc.plugins.null_ls").setup()
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "VeryLazy" },
    config = function()
      require("vimrc.plugins.nvim_lint").setup()
    end,
  },

  -- NOTE: Used in light vim mode when null-ls.nvim is disabled
  {
    "mhartington/formatter.nvim",
    event = { "VeryLazy" },
    config = function()
      local plugin_utils = require("vimrc.plugin_utils")

      require("formatter").setup({
        filetype = {
          markdown = {
            plugin_utils.check_executable(require("formatter.defaults.prettierd"), "prettierd"),
          },
        },
      })

      nnoremap("<Leader>f", "<Cmd>Format<CR>", "silent")
    end,
  },

  {
    "SmiteshP/nvim-navic",
    cond = choose.is_enabled_plugin("nvim-navic"),
    event = { "LspAttach" },
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require("nvim-navic").setup({
        highlight = true,
      })
    end,
  },

  {
    "rmagatti/goto-preview",
    event = { "LspAttach" },
    config = function()
      require("goto-preview").setup({})
    end,
  },

  {
    "j-hui/fidget.nvim",
    event = { "LspAttach" },
    config = function()
      require("fidget").setup({})
    end,
  },

  -- Goto Definitions
  -- NOTE: Has symbol preview
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    keys = { "<F7>" },
    config = function()
      require("vimrc.plugins.symbols_outline").setup()
    end,
  },

  -- Specific LSP Support
  { "p00f/clangd_extensions.nvim" },
  { "simrat39/rust-tools.nvim" },
  { "jose-elias-alvarez/nvim-lsp-ts-utils" },
  -- NOTE: Disabled as it'll cause lua_ls use too much memory
  -- TODO: Add a method to load neodev.nvim on-demand
  {
    "folke/neodev.nvim",
    enabled = false,
    config = function()
      require("neodev").setup({})
    end,
  },

  -- Fold
  -- TODO: Check if folding not work in vimwiki
  -- TODO: Find a better place for fold
  -- There's several place for fold settings:
  -- 1. Here for nvim-ufo
  -- 2. vimwiki.vim for vimwiki specific config
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      require("vimrc.plugins.ufo").setup()
    end,
  },

  -- Breadcrumbs
  {
    "SmiteshP/nvim-navbuddy",
    cond = choose.is_enabled_plugin("nvim-navbuddy"),
    event = { "LspAttach" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("nvim-navbuddy").setup()

      nnoremap("<Space><Leader>", "<Cmd>Navbuddy<CR>")
    end,
  },

  -- Overloads
  {
    "Issafalcon/lsp-overloads.nvim",
    event = { "LspAttach" },
  },
}

return lsp
