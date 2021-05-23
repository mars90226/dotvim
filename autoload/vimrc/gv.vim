" Mappings
function! vimrc#gv#mappings() abort
  nnoremap <silent><buffer> + :call vimrc#gv#expand()<CR>

  call vimrc#git#include_git_mappings('gv', v:true, v:true)
endfunction

" Functions
function! vimrc#gv#expand() abort
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction

function! vimrc#gv#show_file(file, options) abort
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
