if exists('b:loaded_rust_settings')
  finish
endif
let b:loaded_rust_settings = 1

let b:AutoPairsJumps = ['>']

command! -nargs=+ RustupDoc     call vimrc#rust_doc#open_rustup_doc(<f-args>)
command! -nargs=* RustupDocCore call vimrc#rust_doc#open_rustup_doc('--core', <f-args>)
command! -nargs=* RustupDocStd  call vimrc#rust_doc#open_rustup_doc('--std', <f-args>)

nnoremap <silent><buffer> gK         :call vimrc#rust_doc#search_under_cursor(expand('<cword>'))<CR>
xnoremap <silent><buffer> gK         :<C-U>call vimrc#rust_doc#search_under_cursor(vimrc#utility#get_visual_selection())<CR>
nnoremap <silent><buffer> <C-X><C-K> :call vimrc#rust_doc#open_rustup_doc(vimrc#rust_doc#get_cursor_word())<CR>
nnoremap <silent><buffer> <C-X><C-q> :RustFmt<CR>
nnoremap <silent><buffer> <C-X><C-S> :execute 'RustupDoc '.input('topic: ')<CR>
