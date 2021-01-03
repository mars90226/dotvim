" Functions
function! vimrc#lazy#lazy_load(name) abort
  let augroup_name = 'vimrc_lazy_load_'.a:name
  execute 'augroup '.augroup_name
  autocmd!
  execute 'autocmd FocusLost,CursorHold,CursorHoldI * call vimrc#lazy#'.a:name.'#load() | autocmd! '.augroup_name
  augroup END
endfunction
