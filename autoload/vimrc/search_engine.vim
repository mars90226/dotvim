" Functions
let s:duckduckgo_url = 'https://duckduckgo.com/?q=%s'
function! vimrc#search_engine#duckduckgo_url(keyword)
  return printf(s:duckduckgo_url, vimrc#search_engine#url_encode(a:keyword))
endfunction

" TODO: Move to browser.vim
function! vimrc#search_engine#duckduckgo(keyword)
  call vimrc#browser#async_open_url(vimrc#search_engine#duckduckgo_url(a:keyword))
endfunction

function! vimrc#search_engine#client_duckduckgo(keyword)
  call vimrc#browser#client_async_open_url(vimrc#search_engine#duckduckgo_url(a:keyword))
endfunction

" Utilities
" Borrowed from unimpaired
function! vimrc#search_engine#url_encode(str) abort
  " iconv trick to convert utf-8 bytes to 8bits indiviual char.
  return substitute(iconv(a:str, 'latin1', 'utf-8'),'[^A-Za-z0-9_.~-]','\="%".printf("%02X",char2nr(submatch(0)))','g')
endfunction
