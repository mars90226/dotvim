" For cscope.vim

" Functions
function! vimrc#cscope#generate_files() abort
  Dispatch -compiler=cscope
endfunction

function! vimrc#cscope#reload() abort
  cscope kill -1
  cscope add cscope.out
endfunction
