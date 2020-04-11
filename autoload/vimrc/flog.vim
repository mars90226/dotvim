" Mappings
function! vimrc#flog#mappings()
  nmap <silent><buffer> q <Plug>(FlogQuit)

  call vimrc#git#include_git_mappings('vimrc#flog#sha()', 'vimrc#flog#visual_diff_commits()')
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
