" Plugin Management

let s:plugin_disabled = {}

function! vimrc#plugin#disable_plugin(plugin) abort
  if !has_key(s:plugin_disabled, a:plugin)
    let s:plugin_disabled[a:plugin] = v:true
  endif
endfunction

function! vimrc#plugin#disable_plugins(plugins) abort
  for plugin in a:plugins
    call vimrc#plugin#disable_plugin(plugin)
  endfor
endfunction

function! vimrc#plugin#enable_plugin(plugin) abort
  if has_key(s:plugin_disabled, a:plugin)
    call remove(s:plugin_disabled, a:plugin)
  end
endfunction

function! vimrc#plugin#clear_disabled_plugins() abort
  let s:plugin_disabled = {}
endfunction

function! vimrc#plugin#is_disabled_plugin(plugin) abort
  return has_key(s:plugin_disabled, a:plugin)
endfunction

function! vimrc#plugin#is_enabled_plugin(plugin) abort
  return !has_key(s:plugin_disabled, a:plugin)
endfunction

function! vimrc#plugin#get_disabled_plugins() abort
  echo s:plugin_disabled
endfunction
