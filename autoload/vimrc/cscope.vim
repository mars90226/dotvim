" For cscope.vim

" Functions
function! vimrc#cscope#generate_files()
  Dispatch -compiler=cscope
endfunction

function! vimrc#cscope#reload()
  cscope kill -1
  cscope add cscope.out
endfunction
