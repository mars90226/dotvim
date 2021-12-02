local lspsaga = {
  show_doc = function()
    if vim.o.filetype == "help" then
      vim.cmd([[help ]] .. vim.fn.expand("<cword>"))
    else
      vim.cmd([[Lspsaga hover_doc]])
    end
  end,
  on_attach = function(client)
    nnoremap("gd", "<Cmd>Lspsaga lsp_finder<CR>", "silent", "buffer")
    nnoremap("gi", "<Cmd>Lspsaga implement<CR>", "silent", "buffer")
    nnoremap("gp", "<Cmd>Lspsaga preview_definition<CR>", "silent", "buffer")
    nnoremap("gy", "<Cmd>Lspsaga signature_help<CR>", "silent", "buffer")
    nnoremap("gr", "<Cmd>Lspsaga rename<CR>", "silent", "buffer")
    nnoremap("gx", "<Cmd>Lspsaga code_action<CR>", "silent", "buffer")
    xnoremap("gx", ":<C-U>Lspsaga range_code_action<CR>", "silent", "buffer")
    nnoremap("K", "<Cmd>lua require('vimrc.plugins.lspsaga').show_doc()<CR>", "silent", "buffer")
    nnoremap("go", "<Cmd>Lspsaga show_line_diagnostics<CR>", "silent", "buffer")
    nnoremap("gC", "<Cmd>Lspsaga show_cursor_dianostics<CR>", "silent", "buffer")
    nnoremap("]c", "<Cmd>Lspsaga diagnostic_jump_next<CR>", "silent", "buffer")
    nnoremap("[c", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "silent", "buffer")
    nnoremap("<C-U>", "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", "buffer")
    nnoremap("<C-D>", "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", "buffer")
  end,
}

return lspsaga
