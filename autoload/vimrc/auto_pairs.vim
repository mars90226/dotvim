" For auto-pairs

" Functions
function! vimrc#auto_pairs#toggle_multiline_close()
  if g:AutoPairsMultilineClose == 0
    let g:AutoPairsMultilineClose = 1
  else
    let g:AutoPairsMultilineClose = 0
  endif
endfunction
