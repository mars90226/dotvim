" Mappings
function! vimrc#git_messenger#mappings() abort
  nnoremap <silent><buffer> <Leader>gc :call vimrc#git_messenger#goto_commit('Gsplit')<CR>
  nnoremap <silent><buffer> <Leader>gC :call vimrc#git_messenger#goto_commit('Gedit')<CR>

  " FIXME Display some error message when using these key mappings
  call vimrc#git#include_git_mappings('vimrc#git_messenger#sha()')
endfunction

" Functions
function! vimrc#git_messenger#goto_commit(split) abort
  execute a:split.' '.vimrc#git_messenger#sha()
endfunction

function! vimrc#git_messenger#sha() abort
  return split(getline(3))[1]
endfunction
