" For auto-pairs

" Functions
function! vimrc#auto_pairs#toggle_multiline_close() abort
  if g:AutoPairsMultilineClose == 0
    let g:AutoPairsMultilineClose = 1
  else
    let g:AutoPairsMultilineClose = 0
  endif
endfunction

" TODO Add start pattern matching
function! vimrc#auto_pairs#jump() abort
  let end_patterns = ['"', '\]', "'", ')', '}', '`']
  if exists('b:AutoPairsJumps')
    let end_patterns += b:AutoPairsJumps
  endif
  let search_pattern = '['.join(end_patterns, '').']'
  call search(search_pattern, 'W')
endfunction
