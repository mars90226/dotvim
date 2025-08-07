local goto_preview = {
  on_attach = function(client)
    vim.keymap.set("n", "gpd", [[<Cmd>lua require('goto-preview').goto_preview_definition()<CR>]], { silent = true, buffer = true })
    vim.keymap.set("n", "gpi", [[<Cmd>lua require('goto-preview').goto_preview_implementation()<CR>]], { silent = true, buffer = true })
    vim.keymap.set("n", "gpc", [[<Cmd>lua require('goto-preview').close_all_win()<CR>]], { silent = true, buffer = true })
    vim.keymap.set("n", "gpr", [[<Cmd>lua require('goto-preview').goto_preview_references()<CR>]], { silent = true, buffer = true })
  end,
}

return goto_preview
