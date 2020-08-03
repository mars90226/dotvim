" For TUI support
let s:shells = ['bash', 'zsh', 'fish', 'powershell', 'ash']
let s:tui_processes = ['htop', 'btm', 'broot', 'sr', 'ranger', 'nnn', 'vifm', 'fff', 'lf', 'lazygit', 'gitui', 'bandwhich']
let s:floaterm_wrappers = ['fff', 'fzf', 'lf', 'nnn', 'ranger', 'vifm', 'rg']

function! vimrc#tui#get_shells()
  return s:shells
endfunction

function! vimrc#tui#get_processes()
  return s:tui_processes
endfunction

function! vimrc#tui#get_floaterm_wrappers()
  return s:floaterm_wrappers
endfunction

" Difference from vimrc#terminal#is_interactive_process():
" 1. Check if command is shell
" 2. Check if command is floaterm wrapper
function! vimrc#tui#is_tui(command)
  if index(s:floaterm_wrappers, a:command) != -1
    return v:true
  endif

  for tui_process in s:tui_processes
    if a:command =~ vimrc#get_boundary_pattern(tui_process)
      return v:false
    endif
  endfor

  for shell in s:shells
    if a:command =~ vimrc#get_boundary_pattern(shell)
      return v:false
    endif
  endfor

  return v:true
endfunction

" Functions
" TODO Rename function as it's not really TUI when not using floaterm
function! vimrc#tui#run(split, command)
  let split = a:split ==# 'float' && vimrc#plugin#is_disabled_plugin('vim-floaterm') ? 'new' : a:split

  if split ==# 'float'
    if vimrc#tui#is_tui(a:command)
      execute 'FloatermNew '.a:command
    else
      call floaterm#terminal#open(-1, a:command, {}, {})
    endif
  else
    call vimrc#terminal#open_current_folder(split, a:command)
  endif
endfunction

" Use surfraw
function! vimrc#tui#google_keyword(keyword)
  if empty(a:keyword)
    return
  endif

  let command = 'sr google '.shellescape(a:keyword)
  call vimrc#tui#run('float', command)
endfunction
