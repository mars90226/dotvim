" Mappings
function! vimrc#gv#mappings()
  nnoremap <silent><buffer> + :call vimrc#gv#expand()<CR>

  call vimrc#git#include_git_mappings("gv#sha()", "vimrc#gv#visual_diff_commits()")
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
