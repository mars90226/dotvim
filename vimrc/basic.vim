" Basic {{{
" Map Leader
let g:mapleader = ','
let g:maplocalleader = '\'

" Set Encoding
if vimrc#plugin#check#get_os() =~# 'windows'
  set encoding=utf8
endif
" }}}

" Config {{{
" Loaded before plugins, can be used in plugin config
let g:left_sidebar_width = 35
let g:right_sidebar_width = 40
" }}}
