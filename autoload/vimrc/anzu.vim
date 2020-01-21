" For anzu

" Disabled on file larger than 10MB
let s:anzu_disable_large_file_threshold = 10 * 1024 * 1024

" Functions
function! vimrc#anzu#toggle_update()
  if g:anzu_enable_CursorHold_AnzuUpdateSearchStatus == 0
    let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 2
  else
    let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 0
  endif
endfunction

function! vimrc#anzu#disable_on_large_file()
  if getfsize(expand(@%)) > s:anzu_disable_large_file_threshold
    let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 0
  else
    let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 2
  endif
endfunction
