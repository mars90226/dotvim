" plugin management
command! ListDisabledPlugins call vimrc#plugin#get_disabled_plugins()

" plugin config cache
command! UpdatePluginConfigCache call vimrc#plugin#config_cache#update()

call vimrc#plugin#config_cache#read()
call vimrc#plugin#config_cache#init()

" Start choosing
call vimrc#plugin#choose#start($VIM_MODE, $NVIM_TERMINAL)
