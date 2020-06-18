" Mappings
function! vimrc#gv#mappings()
  nnoremap <silent><buffer> + :call vimrc#gv#expand()<CR>

  call vimrc#git#include_git_mappings('gv#sha()', 'vimrc#gv#visual_diff_commits()')
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

function! vimrc#gv#show_file(file, options)
  let is_current_file = a:file ==# '%'
  let cmd = is_current_file ? 'GV! ' : 'GV '

  for key in keys(a:options)
    if len(key) == 1
      let cmd .= '-'.key.' '.a:options[key].' '
    else
      let cmd .= '--'.key.'='.a:options[key].' '
    endif
  endfor

  if !is_current_file
    let cmd .= ' -- '.a:file
  endif

  execute cmd
endfunction
