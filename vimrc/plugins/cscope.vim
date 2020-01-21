call vimrc#lazy#lazy_load('cscope_macros')

nnoremap <F11> :call vimrc#cscope#generate_files()<CR>
