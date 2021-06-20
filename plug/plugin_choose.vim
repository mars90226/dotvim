" Setup
" Python & Python3 setting for Windows & Synology should be in local vim
" config
if vimrc#plugin#check#get_os() !~# 'windows' && vimrc#plugin#check#get_os() !~# 'synology'
  let g:python_host_prog = '/usr/bin/python'
  let g:python3_host_prog = '/usr/bin/python3'
endif

" plugin management
command! ListDisabledPlugins call vimrc#plugin#get_disabled_plugins()

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
