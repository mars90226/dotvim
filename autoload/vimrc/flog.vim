" Mappings
function! vimrc#flog#mappings()
  nnoremap <buffer><expr> q winnr('$') != 1 ? ':<C-U>wincmd w<CR>:<C-U>close<CR>' : 'q'

  call vimrc#git#include_git_mappings('vimrc#flog#sha()', 'vimrc#flog#visual_diff_commits()')
endfunction

" Functions
function! vimrc#flog#sha(...)
  let line = get(a:000, 0, line('.'))
  return flog#get_commit_at_line(line).short_commit_hash
endfunction

function! vimrc#flog#visual_diff_commits()
  let firstline = line("'<")
  let lastline = line("'>")
  let start_commit = vimrc#flog#sha(lastline)
  let end_commit = vimrc#flog#sha(firstline)

  call vimrc#fzf#git#diff_commits(start_commit, end_commit)
endfunction

function! vimrc#flog#show_file(file, options)
  let is_current_file = a:file ==# '%'
  let cmd = 'Flog -- '

  for key in keys(a:options)
    if len(key) == 1
      let cmd .= '-'.key.' '.a:options[key].' '
    else
      let cmd .= '--'.key.'='.a:options[key].' '
    endif
  endfor

  let cmd .= is_current_file ? shellescape(expand('%')) : a:file

  execute cmd
endfunction
