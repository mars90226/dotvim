" Plugin Cache
let s:plugin_config_cache_name = vimrc#get_vimhome() . '/.plugin_config_cache'
function! vimrc#plugin#config_cache#read()
  if filereadable(s:plugin_config_cache_name)
    execute 'source ' . s:plugin_config_cache_name
  endif
endfunction

let s:plugin_config_cache = []
function! vimrc#plugin#config_cache#append(content)
  call add(s:plugin_config_cache, a:content)
endfunction

function! vimrc#plugin#config_cache#write()
  call writefile(s:plugin_config_cache, s:plugin_config_cache_name)
endfunction

function! vimrc#plugin#config_cache#update()
  " Update plugin config
  call vimrc#plugin#config_cache#append("let g:has_jedi = " . vimrc#plugin#check#has_jedi(1))
  call vimrc#plugin#config_cache#append("let g:python_version = " . vimrc#plugin#check#python_version(1))

  call vimrc#plugin#config_cache#write()
endfunction

function! vimrc#plugin#config_cache#init()
  if !filereadable(s:plugin_config_cache_name)
    call vimrc#plugin#config_cache#update()
  endif
endfunction
