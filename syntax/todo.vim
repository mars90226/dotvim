" Quit when a syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

runtime! syntax/vimwiki.vim
let b:current_syntax = 'todo'
