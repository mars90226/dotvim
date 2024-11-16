local plugin_utils = require("vimrc.utils.plugin")

local null_ls = require("null-ls")

local my_null_ls = {}

my_null_ls.setup = function()
  null_ls.setup({
    sources = {
      -- NOTE: Unmaintained builtin sources are deprecated. Check reference for alternatives.
      -- Ref: https://github.com/nvimtools/none-ls.nvim/issues/58

      -- Code Action sources
      -- NOTE: disabled for performance
      -- null_ls.builtins.code_actions.gitsigns,

      -- Diagnostic sources
      -- NOTE: Disabled as normal workflow will save & quit when writing git commit message
      -- null_ls.builtins.diagnostics.gitlint.with({
      --   condition = function()
      --     return plugin_utils.is_executable("gitlint")
      --   end,
      --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      -- }),
      -- TODO: pylint is slow with lsp linting, disabled for now
      -- TODO: should use nvim-lint or other on-demand linting plugin to lint pylint
      -- null_ls.builtins.diagnostics.pylint.with({
      --   condition = function()
      --     return plugin_utils.is_executable('pylint')
      --   end
      -- }),
      null_ls.builtins.diagnostics.vint.with({
        condition = function()
          return plugin_utils.is_executable("vint")
        end,
      }),

      -- Formatting sources
      -- NOTE: use pylsp python-lsp-black
      -- null_ls.builtins.formatting.black.with({
      --   condition = function()
      --     return plugin_utils.is_executable("black")
      --   end,
      -- }),
      -- NOTE: use clangd clang-format
      -- null_ls.builtins.formatting.clang_format.with({
      --   condition = function()
      --     return plugin_utils.is_executable("clang-format")
      --   end,
      -- }),
      -- NOTE: use prettierd instead
      -- null_ls.builtins.formatting.prettier.with({
      --   condition = function()
      --     return plugin_utils.is_executable("prettier")
      --   end,
      -- }),
      null_ls.builtins.formatting.prettierd.with({
        condition = function()
          return plugin_utils.is_executable("prettierd")
        end,
      }),
      null_ls.builtins.formatting.shfmt.with({
        condition = function()
          return plugin_utils.is_executable("shfmt")
        end,
      }),
      null_ls.builtins.formatting.stylua.with({
        condition = function()
          return plugin_utils.is_executable("stylua")
        end,
      }),

      -- Hover sources
    },
    on_attach = require("vimrc.lsp").on_attach,
  })
end

return my_null_ls
