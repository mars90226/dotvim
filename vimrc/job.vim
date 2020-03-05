" This file is for commands that use Neovim's job API

if has('nvim')
  " Asynchronous open URI
  if has('unix') && executable('xdg-open')
    " Required by fugitive :GBrowse
    command! -bar -nargs=1 Browse call vimrc#browser#async_open(<f-args>)
    call vimrc#browser#include_open_url_mappings('Browse', '<Leader>x', 'x')
  endif

  " Asynchronous open URL in browser
  command! -bar -nargs=1 OpenUrl call vimrc#browser#async_open_url(<f-args>)
  call vimrc#browser#include_open_url_mappings('OpenUrl', '<Leader>b', 'b')

  " Asynchronous search keyword in browser
  command! -bar -nargs=1 SearchKeyword call vimrc#browser#async_search_keyword(<f-args>)
  call vimrc#browser#include_search_mappings('SearchKeyword', '<Leader>k', 'k')

  " Asynchronous search keyword in duckduckgo in browser
  command! -bar -nargs=1 SearchKeywordDdg call vimrc#search_engine#search('duckduckgo', <f-args>)
  call vimrc#browser#include_search_mappings('SearchKeywordDdg', '<Leader>k', 'd')

  " Asynchronous search keyword in devdoc in browser
  command! -bar -nargs=1 SearchKeywordDevDocs call vimrc#search_engine#search('devdocs', <f-args>)
  call vimrc#browser#include_search_mappings('SearchKeywordDevDocs', '<Leader>k', 'e')

  " Asynchronous open URL in client browser
  command! -bar -nargs=1 ClientOpenUrl call vimrc#browser#client_async_open_url(<f-args>)
  call vimrc#browser#include_open_url_mappings('ClientOpenUrl', '<Leader>b', 'c')

  " Asynchronous search keyword in client browser
  command! -bar -nargs=1 ClientSearchKeyword call vimrc#browser#client_async_search_keyword(<f-args>)
  call vimrc#browser#include_search_mappings('ClientSearchKeyword', '<Leader>k', 'c')

  " Asynchronous search keyword in duckduckgo in client browser
  command! -bar -nargs=1 ClientSearchKeywordDdg call vimrc#search_engine#client_search('duckduckgo', <f-args>)
  call vimrc#browser#include_search_mappings('ClientSearchKeywordDdg', '<Leader>k', 'v')

  " Asynchronous search keyword in devdocs in client browser
  command! -bar -nargs=1 ClientSearchKeywordDevDocs call vimrc#search_engine#client_search('devdocs', <f-args>)
  call vimrc#browser#include_search_mappings('ClientSearchKeywordDevDocs', '<Leader>k', 'b')
endif
