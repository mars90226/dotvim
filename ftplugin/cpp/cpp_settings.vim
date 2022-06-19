if exists('b:loaded_cpp_settings')
  finish
endif
let b:loaded_cpp_settings = 1

let b:AutoPairsJumps = ['\w\zs>']

" Clangd
nnoremap <silent><buffer> <M-`> <Cmd>ClangdSwitchSourceHeader<CR>
