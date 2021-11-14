" Plugin Cache
let s:plugin_config_cache_name = vimrc#get_vimhome() . '/.plugin_config_cache'
function! vimrc#plugin#config_cache#read() abort
  if filereadable(s:plugin_config_cache_name)
    execute 'source ' . s:plugin_config_cache_name
  endif
endfunction

let s:plugin_config_cache = []
function! vimrc#plugin#config_cache#append(content) abort
  call add(s:plugin_config_cache, a:content)
endfunction

function! vimrc#plugin#config_cache#write() abort
  call writefile(s:plugin_config_cache, s:plugin_config_cache_name)
endfunction

function! vimrc#plugin#config_cache#update() abort
  " Update plugin config
  call vimrc#plugin#config_cache#append("let g:os = '" . vimrc#plugin#check#get_os(v:true) . "'")
  call vimrc#plugin#config_cache#append("let g:distro = '" . vimrc#plugin#check#get_distro(v:true) . "'")
  call vimrc#plugin#config_cache#append("let g:python_version = '" . vimrc#plugin#check#python_version(v:true) . "'")

  call vimrc#plugin#config_cache#write()
endfunction

function! vimrc#plugin#config_cache#init() abort
  if !filereadable(s:plugin_config_cache_name)
    call vimrc#plugin#config_cache#update()
  endif
endfunction
