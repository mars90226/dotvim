" Map Leader
let g:mapleader = ','
let g:maplocalleader = '\'

" Set Encoding
if vimrc#plugin#check#get_os() =~# 'windows'
  set encoding=utf8
endif
