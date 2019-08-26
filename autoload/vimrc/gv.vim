" Mappings
function! vimrc#gv#mappings()
  nnoremap <silent><buffer> + :call vimrc#gv#expand()<CR>
  nnoremap <silent><buffer> <Leader>gd :call vimrc#fzf#git#diff_commit(gv#sha())<CR>
  nnoremap <silent><buffer> <Leader>gf :call vimrc#fzf#git#files_commit(gv#sha())<CR>
  nnoremap <silent><buffer> <Leader>gg :call vimrc#fzf#git#grep_commit(gv#sha(), input('Git grep: '))<CR>
endfunction

" Functions
function! vimrc#gv#expand()
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction
