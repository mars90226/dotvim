" Plugin Management

let s:plugin_disabled = []

function! vimrc#plugin#disable_plugin(plugin) abort
  if index(s:plugin_disabled, a:plugin) == -1
    call add(s:plugin_disabled, a:plugin)
  endif
endfunction

function! vimrc#plugin#disable_plugins(plugins) abort
  for plugin in a:plugins
    call vimrc#plugin#disable_plugin(plugin)
  endfor
endfunction

function! vimrc#plugin#enable_plugin(plugin) abort
  let index = index(s:plugin_disabled, a:plugin)

  if index != -1
    call remove(s:plugin_disabled, index)
  end
endfunction

function! vimrc#plugin#clear_disabled_plugins() abort
  let s:plugin_disabled = []
endfunction

function! vimrc#plugin#is_disabled_plugin(plugin) abort
  return index(s:plugin_disabled, a:plugin) != -1
endfunction

function! vimrc#plugin#is_enabled_plugin(plugin) abort
  return index(s:plugin_disabled, a:plugin) == -1
endfunction

function! vimrc#plugin#get_disabled_plugins() abort
  echo s:plugin_disabled
endfunction
