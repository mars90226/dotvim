" This file is for commands that use Neovim's job API

if has('nvim')
  " Asynchronous open URI
  if has('unix') && executable('xdg-open')
    " Required by fugitive :GBrowse
    call vimrc#browser#define_command('Browse', 'vimrc#browser#async_open', '<Leader>x', 'x')
  endif

  " Asynchronous open URL in browser
  call vimrc#browser#define_command('OpenUrl', 'vimrc#browser#async_open_url', '<Leader>b', 'b')

  " Asynchronous search keyword in browser
  call vimrc#browser#define_command('SearchKeyword', 'vimrc#browser#async_search_keyword', '<Leader>k', 'k')

  " Asynchronous search keyword in duckduckgo in browser
  call vimrc#search_engine#define_search_command('SearchKeywordDdg', 'duckduckgo', '<Leader>k', 'd')

  " Asynchronous search keyword in devdoc in browser
  call vimrc#search_engine#define_search_command('SearchKeywordDdg', 'devdocs', '<Leader>k', 'e')

  " Asynchronous open URL in client browser
  call vimrc#browser#define_command('ClientOpenUrl', 'vimrc#browser#client_async_open_url', '<Leader>b', 'c')

  " Asynchronous search keyword in client browser
  call vimrc#browser#define_command('ClientSearchKeyword', 'vimrc#browser#client_async_search_keyword', '<Leader>k', 'c')

  " Asynchronous search keyword in duckduckgo in client browser
  call vimrc#search_engine#define_client_search_command('ClientSearchKeywordDdg', 'duckduckgo', '<Leader>k', 'v')

  " Asynchronous search keyword in devdocs in client browser
  call vimrc#search_engine#define_client_search_command('ClientSearchKeywordDevDocs', 'devdocs', '<Leader>k', 'b')
endif
