" Map Leader
let g:mapleader = ','
let g:maplocalleader = '\'

" Change Menu language
" This should happen before loading plugins to avoid deleting plugins' menus
" TODO: Check if neovim don't need this
if has('gui')
  if &langmenu !=# 'en_US.UTF-8'
    set langmenu=en_US.UTF-8
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
  endif
endif

" Set Encoding
if vimrc#plugin#check#get_os() =~# 'windows'
  set encoding=utf8
endif
