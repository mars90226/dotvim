" This file is for commands that use Neovim's job API

if has('nvim')
  " Asynchronous open URI
  if has('unix') && executable('xdg-open')
    " Required by fugitive :GBrowse
    command! -bar -nargs=1 Browse call vimrc#browser#async_open(<f-args>)
    call vimrc#mapping#include_cursor_mapping('Browse', '<Leader>xX', '<Leader>xx')
    call vimrc#mapping#include_visual_selection_mapping('Browse', '<Leader>xx')
  endif

  " Asynchronous open URL in browser
  command! -bar -nargs=1 OpenUrl call vimrc#browser#async_open_url(<f-args>)
  call vimrc#mapping#include_cursor_mapping('OpenUrl', '<Leader>bB', '<Leader>bb')
  call vimrc#mapping#include_visual_selection_mapping('OpenUrl', '<Leader>bb')

  " Asynchronous search keyword in browser
  command! -bar -nargs=1 SearchKeyword call vimrc#browser#async_search_keyword(<f-args>)
  call vimrc#mapping#include_cursor_mapping('SearchKeyword', '<Leader>kk', '<Leader>kK')
  call vimrc#mapping#include_visual_selection_mapping('SearchKeyword', '<Leader>kk')

  " Asynchronous search keyword in duckduckgo in browser
  command! -bar -nargs=1 SearchKeywordDdg call vimrc#search_engine#search('duckduckgo', <f-args>)
  call vimrc#mapping#include_cursor_mapping('SearchKeywordDdg', '<Leader>kd', '<Leader>kD')
  call vimrc#mapping#include_visual_selection_mapping('SearchKeywordDdg', '<Leader>kd')

  " Asynchronous search keyword in devdoc in browser
  command! -bar -nargs=1 SearchKeywordDevDocs call vimrc#search_engine#search('devdocs', <f-args>)
  call vimrc#mapping#include_cursor_mapping('SearchKeywordDevDocs', '<Leader>ke', '<Leader>kE')
  call vimrc#mapping#include_visual_selection_mapping('SearchKeywordDevDocs', '<Leader>ke')

  " Asynchronous open URL in client browser
  command! -bar -nargs=1 ClientOpenUrl call vimrc#browser#client_async_open_url(<f-args>)
  call vimrc#mapping#include_cursor_mapping('ClientOpenUrl', '<Leader>bC', '<Leader>bc')
  call vimrc#mapping#include_visual_selection_mapping('ClientOpenUrl', '<Leader>bc')

  " Asynchronous search keyword in client browser
  command! -bar -nargs=1 ClientSearchKeyword call vimrc#browser#client_async_search_keyword(<f-args>)
  call vimrc#mapping#include_cursor_mapping('ClientSearchKeyword', '<Leader>kc', '<Leader>kC')
  call vimrc#mapping#include_visual_selection_mapping('ClientSearchKeyword', '<Leader>kc')

  " Asynchronous search keyword in duckduckgo in client browser
  command! -bar -nargs=1 ClientSearchKeywordDdg call vimrc#search_engine#client_search('duckduckgo', <f-args>)
  call vimrc#mapping#include_cursor_mapping('ClientSearchKeywordDdg', '<Leader>kv', '<Leader>kV')
  call vimrc#mapping#include_visual_selection_mapping('ClientSearchKeywordDdg', '<Leader>kv')

  " Asynchronous search keyword in devdocs in client browser
  command! -bar -nargs=1 ClientSearchKeywordDevDocs call vimrc#search_engine#client_search('devdocs', <f-args>)
  call vimrc#mapping#include_cursor_mapping('ClientSearchKeywordDevDocs', '<Leader>kb', '<Leader>kB')
  call vimrc#mapping#include_visual_selection_mapping('ClientSearchKeywordDevDocs', '<Leader>kb')
endif
