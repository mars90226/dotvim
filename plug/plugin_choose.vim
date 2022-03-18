" Setup
" Python & Python3 setting for Windows & Synology should be in local vim
" config
if vimrc#plugin#check#get_os() !~# 'windows' && vimrc#plugin#check#get_os() !~# 'synology'
  " Detect asdf
  if filereadable($HOME.'/.asdf/shims/python')
    let g:python_host_prog = $HOME.'/.asdf/shims/python'
  endif
  if filereadable($HOME.'/.asdf/shims/python3')
    let g:python3_host_prog = $HOME.'/.asdf/shims/python3'
  endif

  " Use default Python & Python3
  if !exists('g:python_host_prog')
    let g:python_host_prog = '/usr/bin/python'
  endif
  if !exists('g:python3_host_prog')
    let g:python3_host_prog = '/usr/bin/python3'
  endif
endif

" plugin management
command! ListDisabledPlugins call vimrc#plugin#get_disabled_plugins()

" disable builtin plugin
call vimrc#source('plug/disable_builtin.vim')

" plugin secret
call vimrc#source('plug/secret.vim')

" plugin local
call vimrc#source('plug/local.vim')

" Start choosing
call vimrc#plugin#clear_disabled_plugins()

call vimrc#source('plug/choose/appearance.vim')
call vimrc#source('plug/choose/completion.vim')
call vimrc#source('plug/choose/file_explorer.vim')
call vimrc#source('plug/choose/finder.vim')
call vimrc#source('plug/choose/text_navigation.vim')
call vimrc#source('plug/choose/language.vim')
call vimrc#source('plug/choose/git.vim')
call vimrc#source('plug/choose/terminal.vim')
call vimrc#source('plug/choose/misc.vim')
