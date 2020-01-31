if exists('b:loaded_rust_settings')
  finish
endif
let b:loaded_rust_settings = 1

let b:AutoPairs = AutoPairsDefine({'\w\zs<': '>'})
let b:AutoPairsJumps = ['>']

command! -nargs=1 RustupDoc     call vimrc#rust_doc#open_rustup_doc(<f-args>)
command!          RustupDocCore call vimrc#rust_doc#open_rustup_doc('--core')
command!          RustupDocStd  call vimrc#rust_doc#open_rustup_doc('--std')

nnoremap <silent><buffer> gK :call vimrc#rust_doc#search_under_cursor(expand('<cword>'))<CR>
vnoremap <silent><buffer> gK :<C-U>call vimrc#rust_doc#search_under_cursor(vimrc#get_visual_selection())<CR>
nnoremap <silent><buffer> <Space>gq :RustFmt<CR>
nnoremap <silent><buffer> <C-X><C-K> :call vimrc#rust_doc#open_rustup_doc(vimrc#rust_doc#get_cursor_word())<CR>
nnoremap <silent><buffer> <C-X><C-S> :execute 'RustupDoc '.input('topic: ')<CR>
