" Map Leader
let g:mapleader = ','

" Language
" Always use English to avoid plugin not catching exception due to translation
" E.g. vim-subversive tries to catch 'Unknown Exception'
if !has('nvim')
  " neovim current seems not using system locale
  " And language C seems to break :Denite file
  language C
endif

" Change Menu language
" This should happen before loading plugins to avoid deleting plugins' menus
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
