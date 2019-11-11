" Mappings
function! vimrc#vimwiki#mappings()
  nnoremap <silent><buffer> <Leader>wg :VimwikiToggleListItem<CR>
  " The following will override auto-pairs' <CR> mappings
  inoremap <silent><buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<Esc>:VimwikiReturn 1 5\<CR>"
endfunction
