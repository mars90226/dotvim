" Plugin Management

" Use directory junction in Windows to link $HOME."/.vim" to $VIM."/vimfiles"
let s:vimhome = $HOME . '/.vim'

function! vimrc#plugin#get_vimhome()
  return s:vimhome
endfunction

let s:plugin_disabled = []

function! vimrc#plugin#disable_plugin(plugin)
  let l:idx = index(s:plugin_disabled, a:plugin)

  if l:idx == -1
    call add(s:plugin_disabled, a:plugin)
  endif
endfunction

function! vimrc#plugin#disable_plugins(plugins)
  let s:plugin_disabled += a:plugins
endfunction

function! vimrc#plugin#enable_plugin(plugin)
  let l:idx = index(s:plugin_disabled, a:plugin)

  if l:idx != -1
    call remove(s:plugin_disabled, l:idx)
  end
endfunction

function! vimrc#plugin#is_disabled_plugin(plugin)
  return index(s:plugin_disabled, a:plugin) != -1
endfunction

function! vimrc#plugin#is_enabled_plugin(plugin)
  return index(s:plugin_disabled, a:plugin) == -1
endfunction

function! vimrc#plugin#get_disabled_plugins()
  echo s:plugin_disabled
endfunction
