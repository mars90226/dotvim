if exists('b:loaded_rust_settings')
  finish
endif
let b:loaded_rust_settings = 1

let b:AutoPairs = AutoPairsDefine({'\w\zs<': '>'})
let b:AutoPairsJumps = ['>']

nnoremap <silent><buffer> gK :call vimrc#rust_doc#search_under_cursor(expand('<cword>'))<CR>
vnoremap <silent><buffer> gK :<C-U>call vimrc#rust_doc#search_under_cursor(vimrc#get_visual_selection())<CR>
nnoremap <silent><buffer> <Space>gq :RustFmt<CR>
