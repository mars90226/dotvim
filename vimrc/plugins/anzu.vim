map n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
map N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)

command! AnzuToggleUpdate call s:AnzuToggleUpdate()
function! s:AnzuToggleUpdate()
  if g:anzu_enable_CursorHold_AnzuUpdateSearchStatus == 0
    let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 2
  else
    let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 0
  endif
endfunction

augroup anzuDisableUpdateOnLargeFile
  autocmd!

  " Disabled on file larger than 10MB
  autocmd BufWinEnter,WinEnter *
        \ if getfsize(expand(@%)) > 10 * 1024 * 1024 |
        \   let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 0 |
        \ else |
        \   let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 2 |
        \ endif
augroup END
