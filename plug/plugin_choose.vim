" plugin management
command! ListDisabledPlugins call vimrc#plugin#get_disabled_plugins()

" plugin config cache
command! UpdatePluginConfigCache call vimrc#plugin#config_cache#update()

call vimrc#plugin#config_cache#init()
call vimrc#plugin#config_cache#read()

" plugin secret
call vimrc#source('plug/secret.vim')

" plugin local
call vimrc#source('plug/local.vim')

" Start choosing
call vimrc#plugin#clear_disabled_plugins()

call vimrc#source('plug/choose/statusline.vim')
call vimrc#source('plug/choose/completion.vim')
call vimrc#source('plug/choose/file_explorer.vim')
call vimrc#source('plug/choose/finder.vim')
call vimrc#source('plug/choose/text_navigation.vim')
call vimrc#source('plug/choose/lint.vim')
call vimrc#source('plug/choose/language.vim')
call vimrc#source('plug/choose/git.vim')
call vimrc#source('plug/choose/terminal.vim')
call vimrc#source('plug/choose/misc.vim')
