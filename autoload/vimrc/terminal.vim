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
  " Do not clear in other terminal like fzf, ranger, coc
  if expand('<afile>') =~# 'term://\.//\d\+:' . $SHELL
    " Clear incsearch-nohlsearch autocmd on entering terminal mode
    nnoremap <silent><buffer> i :ClearIncsearchAutoNohlsearch<CR>i
  endif
endfunction
