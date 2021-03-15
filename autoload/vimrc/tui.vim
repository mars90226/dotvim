" For TUI support
let s:shells = [&shell, 'bash', 'zsh', 'fish', 'powershell', 'ash']
let s:tui_processes = ['htop', 'btm', 'broot', 'sr', 'ranger', 'nnn', 'vifm', 'fff', 'lf', 'lazygit', 'gitui', 'bandwhich']
let s:floaterm_wrappers = ['broot', 'fff', 'fzf', 'lf', 'nnn', 'ranger', 'rg', 'vifm']

function! vimrc#tui#get_shells() abort
  return s:shells
endfunction

function! vimrc#tui#is_shell(cmd) abort
  return index(s:shells, a:cmd) != -1
endfunction

function! vimrc#tui#get_processes() abort
  return s:tui_processes
endfunction

function! vimrc#tui#get_floaterm_wrappers() abort
  return s:floaterm_wrappers
endfunction

" 1. Check if command is floaterm wrapper
" 2. Check if command is tui process
" 3. Check if command is shell
function! vimrc#tui#is_tui(command) abort
  if index(s:floaterm_wrappers, a:command) != -1
    return v:true
  endif

  for tui_process in s:tui_processes
    if a:command =~ vimrc#get_boundary_pattern(tui_process)
      return v:true
    endif
  endfor

  for shell in s:shells
    if a:command =~ vimrc#get_boundary_pattern(shell)
      return v:true
    endif
  endfor

  return v:false
endfunction

" Functions
" TODO Rename function as it's not really TUI when not using floaterm
function! vimrc#tui#run(split, command, ...) abort
  let force_noshell = a:0 > 0 && type(a:1) == type(0) ? a:1 : 0
  let split = a:split ==# 'float' && vimrc#plugin#is_disabled_plugin('vim-floaterm') ? 'new' : a:split

  if split ==# 'float' && (vimrc#tui#is_tui(a:command) || force_noshell)
    execute 'FloatermNew '.a:command
  else
    call vimrc#terminal#open_current_folder(split, a:command)
  endif
endfunction

" Use surfraw
function! vimrc#tui#google_keyword(keyword) abort
  if empty(a:keyword)
    return
  endif

  let command = 'sr google '.shellescape(a:keyword)
  call vimrc#tui#run('float', command)
endfunction
