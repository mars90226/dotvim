" For indentLine

" Functions
function! vimrc#indent_line#toggle_enabled()
  if g:indentLine_enabled == 0
    let g:indentLine_enabled = 1
  else
    let g:indentLine_enabled = 0
  endif
endfunction
