local lsp = {}

lsp.startup = function(use)
  -- Language Server Protocol
  use("neovim/nvim-lspconfig")

  use({
    "williamboman/nvim-lsp-installer",
    config = function()
      local lsp_installer = require("nvim-lsp-installer")
      local lsp_configs = require("vimrc.lsp")

      lsp_installer.on_server_ready(function(server)
        lsp_configs.setup_server(server.name, server:get_default_options())
      end)

      -- Ensure lsp servers
      local lsp_installer_servers = require("nvim-lsp-installer.servers")
      for server_name, _ in pairs(lsp_configs.servers) do
        local ok, lsp_server = lsp_installer_servers.get_server(server_name)
        if ok then
          if not lsp_server:is_installed() then
            lsp_server:install()
          end
        else
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
      require("lspsaga").setup({})

      nnoremap("gd", "<Cmd>Lspsaga lsp_finder<CR>", "silent")
      nnoremap("gi", "<Cmd>Lspsaga implement<CR>", "silent")
      nnoremap("gp", "<Cmd>Lspsaga preview_definition<CR>", "silent")
      nnoremap("gy", "<Cmd>Lspsaga signature_help<CR>", "silent")
      nnoremap("gr", "<Cmd>Lspsaga rename<CR>", "silent")
      nnoremap("gx", "<Cmd>Lspsaga code_action<CR>", "silent")
      xnoremap("gx", ":<C-U>Lspsaga range_code_action<CR>", "silent")
      nnoremap("K", "<Cmd>lua require('vimrc.plugins.lspsaga').show_doc()<CR>", "silent")
      nnoremap("go", "<Cmd>Lspsaga show_line_diagnostics<CR>", "silent")
      nnoremap("gC", "<Cmd>Lspsaga show_cursor_dianostics<CR>", "silent")
      nnoremap("]c", "<Cmd>Lspsaga diagnostic_jump_next<CR>", "silent")
      nnoremap("[c", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "silent")
      nnoremap("<C-U>", "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>")
      nnoremap("<C-D>", "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>")
    end,
  })

  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup({})

      nnoremap("<Space>xx", "<Cmd>TroubleToggle<CR>", "silent")
      nnoremap("<Space>xw", "<Cmd>TroubleToggle lsp_workspace_diagnostics<CR>", "silent")
      nnoremap("<Space>xd", "<Cmd>TroubleToggle lsp_document_diagnostics<CR>", "silent")
      nnoremap("<Space>xq", "<Cmd>TroubleToggle quickfix<CR>", "silent")
      nnoremap("<Space>xl", "<Cmd>TroubleToggle loclist<CR>", "silent")
      nnoremap("<Space>xr", "<Cmd>TroubleToggle lsp_references<CR>", "silent")
    end,
  })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.config({
        sources = {
          -- Code Action sources
          null_ls.builtins.code_actions.gitsigns,

          -- Diagnostic sources
          null_ls.builtins.diagnostics.eslint.with({
            condition = function()
              return vim.fn.executable("eslint") > 0
            end,
          }),
          null_ls.builtins.diagnostics.flake8.with({
            condition = function()
              return vim.fn.executable("flake8") > 0
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
          null_ls.builtins.formatting.black.with({
            condition = function()
              return vim.fn.executable("black") > 0
            end,
          }),
          null_ls.builtins.formatting.clang_format.with({
            condition = function()
              return vim.fn.executable("clang-format") > 0
            end,
          }),
          null_ls.builtins.formatting.eslint.with({
            condition = function()
              return vim.fn.executable("eslint") > 0
            end,
          }),
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
      })

      require("vimrc.lsp").setup_server("null-ls", {})
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

  use {
    "nvim-lua/lsp-status.nvim",
    config = function()
      local lsp_status = require('lsp-status')

      lsp_status.config {
        diagnostics = false
      }
    end
  }
end

return lsp
