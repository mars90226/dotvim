local diagnostic = {}

diagnostic.setup = function()
  local use_config = function(plugin_spec)
    plugin_spec.config()
  end

  use_config({
    "mars90226/diagnostic",
    config = function()
      vim.diagnostic.config({
        virtual_text = {
          source = "if_many",
        },
        float = {
          source = "if_many",
        },
        signs = {
          text = {
            -- icons / text used for a diagnostic
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          }
        },
      })

      nnoremap("]d", [[<Cmd>lua vim.diagnostic.goto_next()<CR>]], "silent")
      nnoremap("[d", [[<Cmd>lua vim.diagnostic.goto_prev()<CR>]], "silent")
      nnoremap("go", [[<Cmd>lua vim.diagnostic.open_float()<CR>]], "silent")
    end,
  })
end

return diagnostic
