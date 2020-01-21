" For syntastic

" Functions
function! vimrc#syntastic#check_header()
  let header_pattern_index = index(g:syntastic_ignore_files, '\m\c\.h$')
  if header_pattern_index >= 0
    call remove(g:syntastic_ignore_files, header_pattern_index)
  endif

  let g:syntastic_c_check_header = 1
  let g:syntastic_cpp_check_header = 1
  SyntasticCheck
endfunction
