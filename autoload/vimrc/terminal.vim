" Settings
function! vimrc#terminal#settings()
  setlocal bufhidden=hide
  setlocal nolist
  setlocal nowrap
  setlocal nofoldenable
  setlocal foldcolumn=0
  setlocal colorcolumn=
  setlocal nonumber
  setlocal norelativenumber

  " Only clear incsearch-nohlsearch autocmd in normal shell terminal
  " Do not clear in other terminal like fzf, coc
  if expand('<afile>') =~# 'term://\.//\d\+:' . $SHELL
    " Clear incsearch-nohlsearch autocmd on entering terminal mode
    nnoremap <silent><buffer> i :ClearIncsearchAutoNohlsearch<CR>i
  endif
endfunction

" Utilities
" Open terminal in specified folder in new tab
function! vimrc#terminal#tabnew(folder)
  execute 'tabnew term://' . a:folder . '//' . $SHELL
endfunction
