local goto_preview = {
  on_attach = function(client)
    nnoremap("gpd", [[<Cmd>lua require('goto-preview').goto_preview_definition()<CR>]], "silent", "buffer")
    nnoremap("gpi", [[<Cmd>lua require('goto-preview').goto_preview_implementation()<CR>]], "silent", "buffer")
    nnoremap("gP", [[<Cmd>lua require('goto-preview').close_all_win()<CR>]], "silent", "buffer")
    nnoremap("gpr", [[<Cmd>lua require('goto-preview').goto_preview_references()<CR>]], "silent", "buffer")
  end,
}

return goto_preview
