local goto_preview = {
  on_attach = function(client)
    vim.keymap.set("n", "gpd", function() require('goto-preview').goto_preview_definition() end, { silent = true, buffer = true })
    vim.keymap.set("n", "gpi", function() require('goto-preview').goto_preview_implementation() end, { silent = true, buffer = true })
    vim.keymap.set("n", "gpc", function() require('goto-preview').close_all_win() end, { silent = true, buffer = true })
    vim.keymap.set("n", "gpr", function() require('goto-preview').goto_preview_references() end, { silent = true, buffer = true })
  end,
}

return goto_preview
