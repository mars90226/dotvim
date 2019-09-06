let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
" let g:AutoPairsMapCR = 0

" Custom <CR> map to avoid enter <CR> when popup is opened
" inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>" . AutoPairsReturn()

function! s:AutoPairsToggleMultilineClose()
  if g:AutoPairsMultilineClose == 0
    let g:AutoPairsMultilineClose = 1
  else
    let g:AutoPairsMultilineClose = 0
  endif
endfunction
command! AutoPairsToggleMultilineClose call <SID>AutoPairsToggleMultilineClose()

augroup autoPairsFileTypeSpecific
  autocmd!
  autocmd Filetype xml let b:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '<': '>'}
augroup END
