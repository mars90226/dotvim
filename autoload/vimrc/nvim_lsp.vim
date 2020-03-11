let s:nvim_lsp_filetypes = []

" Functions
function! vimrc#nvim_lsp#show_documentation()
  if index(s:nvim_lsp_filetypes, &filetype) == -1
    normal! K
  else
    lua vim.lsp.buf.hover()
  endif
endfunction

function! vimrc#nvim_lsp#register_filetype(filetype)
  if index(s:nvim_lsp_filetypes, a:filetype) == -1
    call add(s:nvim_lsp_filetypes, a:filetype)
  endif
endfunction
