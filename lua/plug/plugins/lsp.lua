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
          require("mason").setup({
            ui = {
              border = "single",
            },
          })
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          require("mason-lspconfig").setup()
        end,
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
    event = { "LspAttach" },
  },

  {
    "glepnir/lspsaga.nvim",
    branch = "main",
    event = { "LspAttach" },
    -- NOTE: config setup in vimrc.lsp.setup_plugins()
  },

  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd = { "Trouble", "TroubleToggle" },
    keys = { "<Space>xx", "<Space>xw", "<Space>xd", "<Space>xq", "<Space>xl", "<Space>xr", "]x", "[x" },
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
      vim.keymap.set("n", "]x", [[<Cmd>lua require("trouble").next({ skip_groups = true, jump = true })<CR>]], opts)

      -- jump to the previous item, skipping the groups
      vim.keymap.set("n", "[x", [[<Cmd>lua require("trouble").previous({ skip_groups = true, jump = true })<CR>]], opts)
    end,
  },

  -- TODO: none-ls.nvim cause performance problem, need to find a way to fix this
  -- TODO: Due to performance issue, none-ls.nvim is only enabled for code action integration from other plugins.
  -- NOTE: Above TODO is based on null-ls.nvim, need to check if it's still true for none-ls.nvim
  {
    "nvimtools/none-ls.nvim",
    enabled = true,
    cond = choose.is_enabled_plugin("none-ls.nvim"),
    event = { "VeryLazy" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    config = function()
      -- NOTE: none-ls.nvim is still using null-ls as module name, so we don't rename the module.
      require("vimrc.plugins.null_ls").setup()
    end,
  },

  -- Lint
  {
    "mfussenegger/nvim-lint",
    event = { "VeryLazy" },
    config = function()
      require("vimrc.plugins.nvim_lint").setup()
    end,
  },

  -- Format
  {
    "stevearc/conform.nvim",
    config = function()
      require("vimrc.plugins.conform").setup()
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
    tag = "legacy",
    event = { "LspAttach" },
    config = function()
      require("fidget").setup({
        window = {
          blend = 0,
        }
      })
    end,
  },

  -- Goto Definitions
  -- NOTE: Has symbol preview
  -- FIXME: symbols-outline.nvim is archived, replace it with aerial.nvim
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    keys = { "<F7>" },
    config = function()
      require("vimrc.plugins.symbols_outline").setup()
    end,
  },

  -- Specific LSP Support
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    config = function()
      require("clangd_extensions").setup({
        extensions = {
          memory_usage = {
            border = "rounded",
          },
          symbol_info = {
            border = "rounded",
          },
        },
      })
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    cond = choose.is_enabled_plugin("rustaceanvim"),
    version = '^3', -- Recommended
    ft = { 'rust' },
    init = function()
      -- TODO: Lazy load rustaceanvim server opts
      local server_opts = require('vimrc.lsp').calculate_server_opts('rustaceanvim', {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
            cargo = {
              loadOutDirsFromCheck = true,
            },
            procMacro = {
              enable = true,
            },
          },
        },
      })

      vim.g.rustaceanvim = {
        server = server_opts,
        -- TODO: Add dap config
      }
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    config = function()
      -- TODO: typescript-tools.nvim do not support mason-installed tsserver for now.
      require("typescript-tools").setup(require("vimrc.lsp").calculate_server_opts("typescript-tools", {
        settings = {
          -- spawn additional tsserver instance to calculate diagnostics on it
          separate_diagnostic_server = true,
          -- "change"|"insert_leave" determine when the client asks the server about diagnostic
          publish_diagnostic_on = "insert_leave",
          -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
          -- (see 💅 `styled-components` support section)
          tsserver_plugins = {},
          -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
          -- memory limit in megabytes or "auto"(basically no limit)
          tsserver_max_memory = "auto",
          -- described below
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeCompletionsForModuleExports = true,
            quotePreference = "auto",
          },
          tsserver_format_options = {
            allowIncompleteCompletions = false,
            allowRenameOfImportPath = false,
          },
        },
      }))
    end,
  },
  -- NOTE: Disabled as it'll cause lua_ls use too much memory
  -- TODO: Add a method to load neodev.nvim on-demand
  {
    "folke/neodev.nvim",
    enabled = false,
    config = function()
      require("neodev").setup({})
    end,
  },
  -- FIXME: Error when hovering, setup ltex_extra.nvim twice
  -- Ref: https://github.com/barreiroleo/ltex_extra.nvim/issues/54
  {
    "barreiroleo/ltex_extra.nvim",
    enabled = false,
    ft = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc", "quarto", "rmd" },
  },
  { "b0o/schemastore.nvim", ft = { "json", "yaml" } },

  -- Fold
  -- TODO: Check if folding not work in vimwiki
  -- TODO: Find a better place for fold
  -- There's several place for fold settings:
  -- 1. Here for nvim-ufo
  -- 2. vimwiki.vim for vimwiki specific config
  -- TODO: Use neovim built-in transparent fold text: vim.wo.foldtext = ''
  -- Ref: https://github.com/neovim/neovim/pull/20750
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

  -- Rename
  {
    "smjonas/inc-rename.nvim",
    event = { "LspAttach" },
    config = function()
      require("inc_rename").setup()

      nnoremap("<Leader>ir", ":IncRename ")
      nnoremap("<Leader>ik", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true })
    end,
  },

  -- Code Action
  {
    "aznhe21/actions-preview.nvim",
    event = { "LspAttach" },
    config = function()
      vim.keymap.set({ "v", "n" }, "ga", require("actions-preview").code_actions)
    end,
  },
}

return lsp
