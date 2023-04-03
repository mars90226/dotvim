local choose = require("vimrc.choose")

local lsp = {}

lsp.startup = function(use)
  -- Language Server Protocol
  use({ "neovim/nvim-lspconfig" })
  use({
    "williamboman/mason.nvim",
    config = function()
      local lsp_configs = require("vimrc.lsp")

      require("mason").setup()
      require("mason-lspconfig").setup()

      -- Setup lsp servers
      lsp_configs.setup({})
    end,
  })
  use({
    "williamboman/mason-lspconfig.nvim",
    require = { "williamboman/mason.nvim" },
  })
  use({
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    require = { "williamboman/mason.nvim" },
  })
  use({
    "tamago324/nlsp-settings.nvim",
    config = function()
      require("nlspsettings").setup({
        config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
        local_settings_dir = ".nlsp-settings",
        local_settings_root_markers_fallback = { ".git" },
        append_default_schemas = true,
        loader = "json",
      })
    end,
  })

  use("ii14/lsp-command")

  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require("vimrc.plugins.lspsaga").setup()
    end,
  })

  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
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
      vim.keymap.set("n", "]g", [[<Cmd>lua require("trouble").next({ skip_groups = true, jump = true })<CR>]], opts)

      -- jump to the previous item, skipping the groups
      vim.keymap.set("n", "[g", [[<Cmd>lua require("trouble").previous({ skip_groups = true, jump = true })<CR>]], opts)
    end,
  })

  -- TODO: null-ls.nvim cause performance problem, need to find a way to fix this
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("vimrc.plugins.null_ls").setup()
    end,
  })

  use({
    "mfussenegger/nvim-lint",
    config = function()
      require("vimrc.plugins.nvim_lint").setup()
    end,
  })

  -- NOTE: Used in light vim mode when null-ls.nvim is disabled
  use({
    "mhartington/formatter.nvim",
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
  })

  if choose.is_enabled_plugin("nvim-navic") then
    use({
      "SmiteshP/nvim-navic",
      requires = "neovim/nvim-lspconfig",
      config = function()
        require("nvim-navic").setup({
          highlight = true,
        })
      end,
    })
  end

  use({
    "rmagatti/goto-preview",
    module = "goto-preview",
    config = function()
      require("goto-preview").setup({})
    end,
  })

  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  })

  -- Goto Definitions
  -- NOTE: Has symbol preview
  use({
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    keys = { "<F7>" },
    config = function()
      require("vimrc.plugins.symbols_outline").setup()
    end,
  })

  -- Specific LSP Support
  use({
    "p00f/clangd_extensions.nvim",
    module = "clangd_extensions",
  })
  use({
    "simrat39/rust-tools.nvim",
    module = { "rust-tools" },
  })
  use({ "jose-elias-alvarez/nvim-lsp-ts-utils" })
  -- NOTE: Disabled as it'll cause lua_ls use too much memory
  -- TODO: Add a method to load neodev.nvim on-demand
  use({
    "folke/neodev.nvim",
    disable = true,
    config = function()
      require("neodev").setup({})
    end,
  })

  -- Fold
  -- TODO: Check if folding not work in vimwiki
  -- TODO: Find a better place for fold
  -- There's several place for fold settings:
  -- 1. Here for nvim-ufo
  -- 2. vimwiki.vim for vimwiki specific config
  use({
    "kevinhwang91/nvim-ufo",
    requires = "kevinhwang91/promise-async",
    config = function()
      require("vimrc.plugins.ufo").setup()
    end,
  })

  -- Breadcrumbs
  if choose.is_enabled_plugin("nvim-navbuddy") then
    use({
      "SmiteshP/nvim-navbuddy",
      requires = {
        "neovim/nvim-lspconfig",
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("nvim-navbuddy").setup()

        nnoremap("<Space><Leader>", "<Cmd>Navbuddy<CR>")
      end,
    })
  end

  -- Overloads
  use({ "Issafalcon/lsp-overloads.nvim" })
end

return lsp
