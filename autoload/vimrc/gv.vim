" Mappings
function! vimrc#gv#mappings()
  nnoremap <silent><buffer> + :call vimrc#gv#expand()<CR>
  nnoremap <silent><buffer> <Leader>gd :call vimrc#fzf#git#diff_commit(gv#sha())<CR>
  xnoremap <silent><buffer> <Leader>gd :<C-U>call vimrc#gv#visual_diff_commits()<CR>
  nnoremap <silent><buffer> <Leader>gf :call vimrc#fzf#git#files_commit(gv#sha())<CR>
  nnoremap <silent><buffer> <Leader>gg :call vimrc#fzf#git#grep_commit(gv#sha(), input('Git grep: '))<CR>
  nnoremap <silent><buffer> <Leader>gt :execute 'Git show --stat '.gv#sha()<CR>

  " Command line mapping
  cnoremap <buffer><expr> <C-G><C-S> gv#sha()
endfunction

" Functions
function! vimrc#gv#expand()
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction

function! vimrc#gv#visual_diff_commits()
  " Borrowed from gv.vim
  let shas = filter(map(getline("'<", "'>"), 'gv#sha(v:val)'), '!empty(v:val)')
  let start_commit = shas[-1]
  let end_commit = shas[0]

  call vimrc#fzf#git#diff_commits(start_commit, end_commit)
endfunction
