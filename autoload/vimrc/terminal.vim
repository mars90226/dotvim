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
  let shells = ["bash", "zsh", "fish", "pweorshell"]
  let exception_programs = ["fzf", "coc"]

  for exception_program in exception_programs
    if a:terminal =~ exception_program
      return v:false
    endif
  endfor

  for shell in shells
    if a:terminal =~ shell
      return v:true
    endif
  endfor
endfunction

" Only whitelist specific processes
function! vimrc#terminal#is_interactive_process(terminal)
  let interactive_processes = ["htop", "broot"]

  for interactive_process in interactive_processes
    if a:terminal =~ interactive_process
      return v:true
    endif
  endfor
endfunction
