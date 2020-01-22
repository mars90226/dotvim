let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
" let g:AutoPairsMapCR = 0

" Custom <CR> map to avoid enter <CR> when popup is opened
" inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>" . AutoPairsReturn()

command! AutoPairsToggleMultilineClose call vimrc#auto_pairs#toggle_multiline_close()
