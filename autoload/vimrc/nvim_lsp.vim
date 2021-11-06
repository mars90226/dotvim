" Functions
function! vimrc#nvim_lsp#show_documentation() abort
  if &filetype ==# 'help'
    execute 'help ' . expand('<cword>')
  else
    lua vim.lsp.buf.hover()
  endif
endfunction
