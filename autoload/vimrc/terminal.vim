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
  if vimrc#terminal#is_shell_terminal(expand('<afile>'))
    " Clear incsearch-nohlsearch autocmd on entering terminal mode
    nnoremap <silent><buffer> i :ClearIncsearchAutoNohlsearch<CR>i
  endif
endfunction

function! vimrc#terminal#meta_key_fix()
  set <M-a>=a
  set <M-c>=c
  set <M-h>=h
  set <M-g>=g
  set <M-j>=j
  set <M-k>=k
  set <M-l>=l
  set <M-n>=n
  set <M-o>=o
  set <M-p>=p
  set <M-s>=s
  set <M-t>=t
  set <M-/>=/
  set <M-?>=?
  set <M-]>=]
  set <M-`>=`
  set <M-1>=1
  set <M-S-o>=O
endfunction

" Utilities
" Open terminal in specified folder in new tab
function! vimrc#terminal#tabnew(folder)
  execute 'tabnew term://' . a:folder . '//' . $SHELL
endfunction

function! vimrc#terminal#is_shell_terminal(terminal)
  return ((a:terminal =~ $SHELL) || (a:terminal =~ "powershell"))
        \ && (a:terminal !~ "fzf") && (a:terminal !~ "coc")
endfunction

" Only whitelist specific processes
function! vimrc#terminal#is_interactive_process(terminal)
  return (a:terminal =~ "htop") || (a:terminal =~ "broot")
endfunction
