" Mappings
function! vimrc#flog#mappings()
  nmap <silent><buffer> q <Plug>FlogQuit

  nnoremap <silent><buffer> <Leader>gd :call vimrc#fzf#git#diff_commit(vimrc#flog#sha())<CR>
  xnoremap <silent><buffer> <Leader>gd :<C-U>call vimrc#flog#visual_diff_commits()<CR>
  nnoremap <silent><buffer> <Leader>gf :call vimrc#fzf#git#files_commit(vimrc#flog#sha())<CR>
  nnoremap <silent><buffer> <Leader>gg :call vimrc#fzf#git#grep_commit(vimrc#flog#sha(), input('Git grep: '))<CR>
endfunction

" Functions
function! vimrc#flog#sha(...)
  let line = get(a:000, 0, line('.'))
  return flog#get_commit_data(line).short_commit_hash
endfunction

function! vimrc#flog#visual_diff_commits()
  let firstline = line("'<")
  let lastline = line("'>")
  let start_commit = vimrc#flog#sha(lastline)
  let end_commit = vimrc#flog#sha(firstline)

  call vimrc#fzf#git#diff_commits(start_commit, end_commit)
endfunction
