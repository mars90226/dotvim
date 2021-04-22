" Mappings
function! vimrc#flog#mappings() abort
  nnoremap <buffer><expr> q winnr('$') != 1 ? ':<C-U>wincmd w<CR>:<C-U>close<CR>' : 'q'

  call vimrc#git#include_git_mappings('vimrc#flog#sha()', 'vimrc#flog#visual_diff_commits()')
endfunction

" Functions
function! vimrc#flog#sha(...) abort
  let line = get(a:000, 0, line('.'))
  return flog#get_commit_at_line(line).short_commit_hash
endfunction

function! vimrc#flog#visual_diff_commits() abort
  let firstline = line("'<")
  let lastline = line("'>")
  let start_commit = vimrc#flog#sha(lastline)
  let end_commit = vimrc#flog#sha(firstline)

  call vimrc#fzf#git#diff_commits(start_commit, end_commit)
endfunction

function! vimrc#flog#show_file(file, options) abort
  let is_current_file = a:file ==# '%'
  let cmd = 'Flog '
  let a:options['path'] = is_current_file ? expand('%') : a:file

  " Currently only support :Flog builtin options, no "git log --graph" options
  for key in keys(a:options)
    let cmd .= '-'.key.'='.a:options[key].' '
  endfor

  execute cmd
endfunction
