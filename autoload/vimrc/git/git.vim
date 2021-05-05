" Functions
function! vimrc#git#git#sha() abort
  return fugitive#Object(@%)
endfunction
