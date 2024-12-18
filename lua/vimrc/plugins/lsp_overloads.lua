local lsp_overloads = {}

lsp_overloads.on_attach = function(client)
  require("lsp-overloads").setup(client, {
    keymaps = {
      next_signature = "<C-j>",
      previous_signature = "<C-k>",
      next_parameter = "<C-l>",
      previous_parameter = "<C-h>",
    },
  })

  -- FIXME: Conflict with M-L in tmux
  vim.keymap.set("i", "<M-S-l>", "<Cmd>LspOverloadsSignature<CR>")
end

return lsp_overloads
