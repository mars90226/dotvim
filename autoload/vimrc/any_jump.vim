" Settings
function! vimrc#any_jump#settings() abort
  nnoremap <silent><buffer> S :call g:AnyJumpHandleOpen('split')<CR><C-W>r
  nnoremap <silent><buffer> V :call g:AnyJumpHandleOpen('vsplit')<CR><C-W>r
endfunction
