call vimrc#lazy#lazy_load('cscope_macros')

nnoremap <F11> :call <SID>generate_cscope_files()<CR>
function! s:generate_cscope_files()
  !find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files ;
  !cscope -b -i cscope.files -f cscope.out
  cscope kill -1
  cscope add cscope.out
endfunction
