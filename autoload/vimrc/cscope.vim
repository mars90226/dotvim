" For cscope.vim

" Functions
function! vimrc#cscope#generate_files()
  !find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files ;
  !cscope -b -i cscope.files -f cscope.out
  cscope kill -1
  cscope add cscope.out
endfunction
