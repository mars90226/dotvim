local null_ls = require("null-ls")
local utils = require("vimrc.utils")

local my_null_ls = {}

my_null_ls.setup = function()
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
      -- NOTE: disabled for performance
      -- null_ls.builtins.code_actions.gitsigns,
      -- NOTE: disabled for performance
      -- TODO: Check if there's way to toggle it?
      -- null_ls.builtins.code_actions.shellcheck.with({
      --   condition = function()
      --     return vim.fn.executable("shellcheck") > 0
      --   end,
      -- }),

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
      -- NOTE: Disabled as normal workflow will save & quit when writing git commit message
      -- null_ls.builtins.diagnostics.gitlint.with({
      --   condition = function()
      --     return vim.fn.executable("gitlint") > 0
      --   end,
      --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      -- }),
      -- TODO: pylint is slow with lsp linting, disabled for now
      -- TODO: should use nvim-lint or other on-demand linting plugin to lint pylint
      -- null_ls.builtins.diagnostics.pylint.with({
      --   condition = function()
      --     return vim.fn.executable('pylint') > 0
      --   end
      -- }),
      -- NOTE: use nvim-lint to lint
      -- null_ls.builtins.diagnostics.shellcheck.with({
      --   condition = function()
      --     return vim.fn.executable("shellcheck") > 0
      --   end,
      -- }),
      null_ls.builtins.diagnostics.standardrb.with({
        condition = function()
          return vim.fn.executable("standardrb") > 0
        end,
        method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
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
      -- NOTE: use prettierd instead
      -- null_ls.builtins.formatting.prettier.with({
      --   condition = function()
      --     return vim.fn.executable("prettier") > 0
      --   end,
      -- }),
      null_ls.builtins.formatting.prettierd.with({
        condition = function()
          return vim.fn.executable("prettierd") > 0
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
end

return my_null_ls
