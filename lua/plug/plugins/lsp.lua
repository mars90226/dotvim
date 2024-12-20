local choose = require("vimrc.choose")

local lsp = {
  -- Language Server Protocol
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        cmd = {
          "Mason",
          "MasonUpdate",
          "MasonInstall",
          "MasonUninstall",
          "MasonUninstallAll",
          "MasonLog",
        },
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
    init = function()
      vim.g.lsp_legacy_commands = true
    end
  },

  {
    "glepnir/lspsaga.nvim",
    branch = "main",
    event = { "LspAttach" },
    -- NOTE: config setup in vimrc.lsp.setup_plugins()
  },

  -- Diagnostic
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd = { "Trouble" },
    keys = {
      { "<Space>xx", "<Cmd>Trouble diagnostics toggle<CR>",         desc = "Trouble diagnostics" },
      {
        "<Space>xd",
        "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
        desc = "Trouble buffer diagnostics",
      },
      { "<Space>xs", "<Cmd>Trouble symbols toggle focus=false<CR>", desc = "Trouble symbols" },
      {
        "<Space>xl",
        "<Cmd>Trouble lsp toggle focus=false win.position=right<CR>",
        desc = "Trouble LSP definitions / references / ...",
      },
      { "<Space>xq", "<Cmd>Trouble quickfix<CR>",       desc = "Trouble quickfix" },
      { "<Space>xa", "<Cmd>Trouble loclist<CR>",        desc = "Trouble loclist" },
      { "<Space>xr", "<Cmd>Trouble lsp_references<CR>", desc = "Trouble lsp_references" },

      -- jump to the next item, skipping the groups
      {
        "]x",
        function()
          require("trouble").next({ mode = "diagnostics", skip_groups = true, jump = true })
        end,
        desc = "Trouble next",
      },

      -- jump to the previous item, skipping the groups
      {
        "[x",
        function()
          require("trouble").prev({ mode = "diagnostics", skip_groups = true, jump = true })
        end,
        desc = "Trouble prevous",
      },

      -- TODO: Use Trouble v3 next/previous function with other modes
    },
    opts = {
      modes = {
        symbols = {
          win = {
            size = { width = vim.g.right_sidebar_width, height = vim.g.right_sidebar_height },
          }
        }
      }
    },
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = { "LspAttach" },
    config = function()
      local lsp_lines = require("lsp_lines")
      lsp_lines.setup()
      lsp_lines.toggle() -- disable by default

      vim.keymap.set("n", "yoO", lsp_lines.toggle, { desc = "Toggle lsp_lines" })
    end,
  },

  -- TODO: none-ls.nvim cause performance problem, need to find a way to fix this
  -- TODO: Due to performance issue, none-ls.nvim is only enabled for code action integration from other plugins.
  -- NOTE: Above TODO is based on null-ls.nvim, need to check if it's still true for none-ls.nvim
  {
    "nvimtools/none-ls.nvim",
    -- TODO: Remove none-ls.nvim
    enabled = false,
    cond = choose.is_enabled_plugin("none-ls.nvim"),
    -- TODO: Lazy load on filetypes
    event = { "BufReadPre", "BufNewFile" },
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
    event = { "LspAttach" },
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },

  -- Goto Definitions
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<F7>", "<Cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {},
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
    "mrcjkb/rustaceanvim",
    cond = choose.is_enabled_plugin("rustaceanvim"),
    version = "^5", -- Recommended
    ft = { "rust" },
    config = function()
      -- NOTE: rustaceanvim use ftplugin to load config.
      -- The lazy.nvim will add rustaceanvim's path to runtimepath, and load config function afterward.
      -- So this config function is loaded before rustaceanvim's ftplugin.
      local server_opts = require("vimrc.lsp").calculate_server_opts("rustaceanvim", {
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
    -- NOTE: Disabled as it doesn't support volar for now and seems unmaintained
    enabled = false,
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
  {
    "yioneko/nvim-vtsls",
    ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
    opts = {},
    config = function(_, opts)
      require("vtsls").config(opts)
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
  -- TODO: Error when hovering, setup ltex_extra.nvim twice
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
    event = { "VeryLazy" },
    init = function()
      -- NOTE: Set foldlevel to 99 to expand all folds by default as nvim-ufo is lazy loaded
      vim.wo.foldlevel = 99 -- feel free to decrease the value
      vim.o.foldlevelstart = 99
    end,
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

      vim.keymap.set("n", "<Space><Leader>", "<Cmd>Navbuddy<CR>", { desc = "Toggle Navbuddy" })
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

      vim.keymap.set("n", "<Leader>ir", ":IncRename ", { desc = "IncRename" })
      vim.keymap.set("n", "<Leader>ik", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "IncRename cursor word" })
    end,
  },

  -- Code Action
  {
    "aznhe21/actions-preview.nvim",
    event = { "LspAttach" },
    config = function()
      vim.keymap.set({ "v", "n" }, "ga", require("actions-preview").code_actions, { desc = "actions-preview.nvim - code actions" })
    end,
  },

  -- Timeout
  -- TODO: Seems to cause more LSP problems than solve problems?
  -- Also, copilot keeps being disabled.
  {
    "zeioth/garbage-day.nvim",
    enabled = false,
    event = { "LspAttach" },
    opts = {}
  },
}

return lsp
