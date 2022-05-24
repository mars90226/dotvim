local lsp = {}

lsp.startup = function(use)
  -- Language Server Protocol
  use({
    "neovim/nvim-lspconfig",
    config = function()
      require("vimrc.lsp").setup({})
    end
  })

  use({
    "williamboman/nvim-lsp-installer",
    config = function()
      local lsp_installer = require("nvim-lsp-installer")
      local lsp_configs = require("vimrc.lsp")

      -- TODO: Add ensure_installed
      lsp_installer.setup({
        automatic_installation = true,
      })

      -- Setup lsp servers
      local lsp_installer_servers = require("nvim-lsp-installer.servers")
      for server_name, _ in pairs(lsp_configs.get_servers()) do
        local ok, lsp_server = lsp_installer_servers.get_server(server_name)
        if ok then
          lsp_configs.setup_server(lsp_server.name, lsp_server:get_default_options())
        end

        -- nvim-lsp-installer unsupported servers or install failed servers
        if not ok or not lsp_server:is_installed() then
          -- Maybe lsp_installer not supported language server, but already installed
          -- TODO: use other attribute to record name
          if vim.fn.executable(server_name) then
            lsp_configs.setup_server(server_name, {})
          end
        end
      end
    end,
  })

  use("ii14/lsp-command")

  use({
    "tami5/lspsaga.nvim",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      require("lspsaga").setup({
        code_action_prompt = {
          enable = true,
          sign = true,
          sign_priority = 40,
          virtual_text = false,
        },
      })
    end,
  })

  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup({})

      nnoremap("<Space>xx", "<Cmd>TroubleToggle<CR>", "silent")
      nnoremap("<Space>xw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", "silent")
      nnoremap("<Space>xd", "<Cmd>TroubleToggle document_diagnostics<CR>", "silent")
      nnoremap("<Space>xq", "<Cmd>TroubleToggle quickfix<CR>", "silent")
      nnoremap("<Space>xl", "<Cmd>TroubleToggle loclist<CR>", "silent")
      nnoremap("<Space>xr", "<Cmd>TroubleToggle lsp_references<CR>", "silent")
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
      local null_ls = require("null-ls")
      local utils = require("vimrc.utils")

      -- Skip null-ls.nvim in light vim mode
      if utils.is_light_vim_mode() then
        return
      end

      null_ls.setup({
        sources = {
          -- Code Action sources
          -- NOTE: use eslint_d instead
          -- null_ls.builtins.code_actions.eslint.with({
          --   condition = function()
          --     return vim.fn.executable("eslint") > 0
          --   end,
          -- }),
          -- null_ls.builtins.code_actions.eslint_d.with({
          --   condition = function()
          --     return vim.fn.executable("eslint_d") > 0
          --   end,
          -- }),
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.code_actions.shellcheck.with({
            condition = function()
              return vim.fn.executable("shellcheck") > 0
            end,
          }),

          -- Diagnostic sources
          -- NOTE: use eslint_d instead
          -- null_ls.builtins.diagnostics.eslint.with({
          --   condition = function()
          --     return vim.fn.executable("eslint") > 0
          --   end,
          -- }),
          -- null_ls.builtins.diagnostics.eslint_d.with({
          --   condition = function()
          --     return vim.fn.executable("eslint_d") > 0
          --   end,
          --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          -- }),
          -- NOTE: use pylsp pyls-flake8
          -- null_ls.builtins.diagnostics.flake8.with({
          --   condition = function()
          --     return vim.fn.executable("flake8") > 0
          --   end,
          -- }),
          null_ls.builtins.diagnostics.gitlint.with({
            condition = function()
              return vim.fn.executable("gitlint") > 0
            end,
          }),
          -- TODO: pylint is slow with lsp linting, disabled for now
          -- TODO: should use nvim-lint or other on-demand linting plugin to lint pylint
          -- null_ls.builtins.diagnostics.pylint.with({
          --   condition = function()
          --     return vim.fn.executable('pylint') > 0
          --   end
          -- }),
          null_ls.builtins.diagnostics.shellcheck.with({
            condition = function()
              return vim.fn.executable("shellcheck") > 0
            end,
          }),
          null_ls.builtins.diagnostics.standardrb.with({
            condition = function()
              return vim.fn.executable("standardrb") > 0
            end,
          }),
          null_ls.builtins.diagnostics.vint.with({
            condition = function()
              return vim.fn.executable("vint") > 0
            end,
          }),

          -- Formatting sources
          -- NOTE: use pylsp python-lsp-black
          -- null_ls.builtins.formatting.black.with({
          --   condition = function()
          --     return vim.fn.executable("black") > 0
          --   end,
          -- }),
          -- NOTE: use clangd clang-format
          -- null_ls.builtins.formatting.clang_format.with({
          --   condition = function()
          --     return vim.fn.executable("clang-format") > 0
          --   end,
          -- }),
          -- NOTE: use eslint_d instead
          -- null_ls.builtins.formatting.eslint.with({
          --   condition = function()
          --     return vim.fn.executable("eslint") > 0
          --   end,
          -- }),
          -- null_ls.builtins.formatting.eslint_d.with({
          --   condition = function()
          --     return vim.fn.executable("eslint_d") > 0
          --   end,
          -- }),
          null_ls.builtins.formatting.json_tool.with({
            condition = function()
              return vim.fn.executable("json.tool") > 0
            end,
          }),
          null_ls.builtins.formatting.lua_format.with({
            condition = function()
              return vim.fn.executable("lua-format") > 0
            end,
          }),
          null_ls.builtins.formatting.prettier.with({
            condition = function()
              return vim.fn.executable("prettier") > 0
            end,
          }),
          null_ls.builtins.formatting.rustfmt.with({
            condition = function()
              return vim.fn.executable("rustfmt") > 0
            end,
          }),
          null_ls.builtins.formatting.shfmt.with({
            condition = function()
              return vim.fn.executable("shfmt") > 0
            end,
          }),
          null_ls.builtins.formatting.standardrb.with({
            condition = function()
              return vim.fn.executable("standardrb") > 0
            end,
          }),
          null_ls.builtins.formatting.stylua.with({
            condition = function()
              return vim.fn.executable("stylua") > 0
            end,
          }),

          -- Hover sources
        },
        on_attach = require("vimrc.lsp").on_attach,
      })
    end,
  })

  use({
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        python = { "mypy", "pylint" },
      }

      nnoremap("<Space>ll", "<Cmd>lua require('lint').try_lint()<CR>", "silent")

      vim.cmd([[augroup nvim_lint_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd BufWritePost lua require('lint').try_lint()]])
      vim.cmd([[augroup END]])
    end,
  })

  use({
    "nvim-lua/lsp-status.nvim",
    config = function()
      local lsp_status = require("lsp-status")

      lsp_status.config({
        diagnostics = false,
      })
    end,
  })

  use({
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup({})
    end,
  })

  -- Goto Definitions
  use({
    "stevearc/aerial.nvim",
    config = function()
      local plugin_utils = require("vimrc.plugin_utils")

      require("aerial").setup({
        backends = vim.tbl_filter(function(backend)
          return backend ~= nil
        end, {
          "lsp",
          plugin_utils.check_enabled_plugin("treesitter", "nvim-treesitter"),
          "markdown",
        }),
        filter_kind = {
          "Class",
          "Constructor",
          "Enum",
          "Function",
          "Interface",
          "Module",
          "Method",
          "Struct",
          -- "Variable",
        },
        width = vim.g.right_sidebar_width,
        on_attach = function(bufnr)
          -- Toggle the aerial window with <F7>
          nnoremap("<F7>", [[<Cmd>AerialToggle!<CR>]], "silent", "buffer")
          -- Jump forwards/backwards with '{' and '}'
          nnoremap("{", [[<Cmd>AerialPrev<CR>]], "silent", "buffer")
          nnoremap("}", [[<Cmd>AerialNext<CR>]], "silent", "buffer")
          -- Jump up the tree with '[[' or ']]'
          nnoremap("[[", [[<Cmd>AerialPrevUp<CR>]], "silent", "buffer")
          nnoremap("]]", [[<Cmd>AerialNextUp<CR>]], "silent", "buffer")
        end,
      })
    end,
  })

  -- Specific LSP Support
  use({
    "simrat39/rust-tools.nvim",
    config = function()
      require("rust-tools").setup({})
    end,
  })
  use({ "jose-elias-alvarez/nvim-lsp-ts-utils" })
end

return lsp
