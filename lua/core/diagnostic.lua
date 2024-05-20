local diagnostic = {}

diagnostic.setup = function()
  local use_config = function(plugin_spec)
    plugin_spec.config()
  end

  use_config({
    "mars90226/diagnostic",
    config = function()
      -- Borrowed from trouble.nvim
      local diagnostic_signs = {
        -- icons / text used for a diagnostic
        error = { name = "Error", text = "" },
        warning = { name = "Warn", text = "" },
        hint = { name = "Hint", text = "" },
        information = { name = "Info", text = "" },
      }

      vim.diagnostic.config({
        virtual_text = {
          source = "if_many",
        },
        float = {
          source = "if_many",
        }
      })

      -- TODO: Migrate from `sign_define` to `vim.diagnostic.config`
      for _, signs in pairs(diagnostic_signs) do
        local hl = "DiagnosticSign" .. signs.name
        vim.fn.sign_define(hl, { text = signs.text, texthl = hl })
      end

      nnoremap("]d", [[<Cmd>lua vim.diagnostic.goto_next()<CR>]], "silent")
      nnoremap("[d", [[<Cmd>lua vim.diagnostic.goto_prev()<CR>]], "silent")
      nnoremap("go", [[<Cmd>lua vim.diagnostic.open_float()<CR>]], "silent")
    end,
  })
end

return diagnostic
