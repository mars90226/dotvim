local choose = require("vimrc.choose")

local lsp = {
  -- Language Server Protocol
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "mason-org/mason.nvim",
        version = false, -- Use latest (2.0+) version
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
        "mason-org/mason-lspconfig.nvim",
        version = false, -- Use latest (2.0+) version
        config = function()
          require("mason-lspconfig").setup()
        end,
      },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        opts = {},
      },
    },
    config = function()
      local lsp_configs = require("vimrc.lsp")

      -- Setup lsp servers
      lsp_configs.setup({})
    end,
  },

  -- Diagnostic
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd = { "Trouble" },
    keys = {
      { "<Space>xx", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Trouble diagnostics" },
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
      { "<Space>xq", "<Cmd>Trouble quickfix<CR>", desc = "Trouble quickfix" },
      { "<Space>xa", "<Cmd>Trouble loclist<CR>", desc = "Trouble loclist" },
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
          },
        },
      },
    },
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
    cmd = { "ConformInfo", "Format" },
    keys = {
      { "<Space>lF", mode = { "n", "x" }, "<Cmd>Format<CR>", { silent = true, desc = "Format by conform" } },
    },
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
    dependencies = {
      "epheien/outline-treesitter-provider.nvim",
      "bngarren/outline-test-blocks-provider.nvim",
    },
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<F7>", "<Cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {},
    config = function()
      require("outline").setup({
        providers = {
          priority = { "test_blocks", "lsp", "coc", "markdown", "norg", "man", "treesitter" },
          test_blocks = {
            enable = { describe = true, it = true, pending = false },
            max_depth = 5,
          },
        },
      })
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
    "mrcjkb/rustaceanvim",
    cond = choose.is_enabled_plugin("rustaceanvim"),
    version = "^6", -- Recommended
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
    "yioneko/nvim-vtsls",
    ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
    opts = {},
    config = function(_, opts)
      require("vtsls").config(opts)
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        "lazy.nvim",
        -- It can also be a table with trigger words / mods
        -- Only load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { "b0o/schemastore.nvim", ft = { "json", "yaml" } },
  {
    "Sebastian-Nielsen/better-type-hover",
    ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
    config = function()
      -- NOTE: Call require("better-type-hover").better_type_hover() in lsp.show_doc() in
      -- lua/vimrc/lsp.lua
      require("better-type-hover").setup({
        -- TODO: Currently cannot be disabled, so set to a less used keymap
        openTypeDocKeymap = "<LocalLeader>K",
      })
    end,
  },

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
    cond = choose.is_enabled_plugin("nvim-ufo"),
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
      require("nvim-navbuddy").setup({
        window = {
          border = "rounded",
          size = "90%",
        },
      })

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
      vim.keymap.set(
        { "v", "n" },
        "ga",
        require("actions-preview").code_actions,
        { desc = "actions-preview.nvim - code actions" }
      )
    end,
  },
}

return lsp
