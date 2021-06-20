" plugin config cache
command! UpdatePluginConfigCache call vimrc#plugin#config_cache#update()

call vimrc#plugin#config_cache#init()
call vimrc#plugin#config_cache#read()
