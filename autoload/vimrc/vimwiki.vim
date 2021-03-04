" Settings
function! vimrc#vimwiki#settings() abort
  " Currently, do nothing
endfunction

" Mappings
function! vimrc#vimwiki#mappings() abort
  nnoremap <silent><buffer> <Leader>wg :VimwikiToggleListItem<CR>

  " for original vimwiki <Tab> & <S-Tab> in insert mode
  inoremap <expr><buffer> <C-X><Tab> vimwiki#tbl#kbd_tab()
  inoremap <expr><buffer> <C-X><S-Tab> vimwiki#tbl#kbd_shift_tab()

  " The following will override auto-pairs' <CR> mappings
  inoremap <silent><buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<Esc>:VimwikiReturn 1 5\<CR>"
endfunction
