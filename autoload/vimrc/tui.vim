" For TUI support
let s:tui_processes = ["htop", "btm", "broot", "sr", "ranger", "nnn", "vifm", "fff", "lf"]
let s:floaterm_wrappers = ["fff", "fzf", "ranger"]

function! vimrc#tui#get_processes()
  return s:tui_processes
endfunction

function! vimrc#tui#get_floaterm_wrappers()
  return s:floaterm_wrappers
endfunction

" Functions
" Use surfraw
function! vimrc#tui#google_keyword(keyword)
  let escaped_keyword = vimrc#escape_symbol(a:keyword)

  if vimrc#plugin#is_enabled_plugin('vim-floaterm')
    execute 'FloatermNew sr google '.escaped_keyword.'; exit'
  else
    call vimrc#terminal#open_current_folder('new', 'sr google '.escaped_keyword)
  endif
endfunction

" TODO Rename function as it's not really TUI when not using floaterm
function! vimrc#tui#run(split, command)
  let split = a:split == "float" && vimrc#plugin#is_disabled_plugin('vim-floaterm') ? "new" : a:split

  if split == "float"
    if index(s:floaterm_wrappers, a:command) != -1 || index(s:tui_processes, a:command) == -1
      execute 'FloatermNew '.a:command
    else
      call floaterm#terminal#open(-1, a:command)
    endif
  else
    call vimrc#terminal#open_current_folder(split, a:command)
  endif
endfunction
