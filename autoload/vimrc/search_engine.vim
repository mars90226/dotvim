" Utilities
" Borrowed from unimpaired
function! vimrc#search_engine#url_encode(str) abort
  " iconv trick to convert utf-8 bytes to 8bits indiviual char.
  return substitute(iconv(a:str, 'latin1', 'utf-8'),'[^A-Za-z0-9_.~-]','\="%".printf("%02X",char2nr(submatch(0)))','g')
endfunction

" Configs
let s:search_engines = {
      \ 'duckduckgo': 'https://duckduckgo.com/?q=%s',
      \ 'devdocs': 'https://devdocs.io/?q=%s'
      \ }

" Functions
function! vimrc#search_engine#get_url(search_engine, keyword)
  if !has_key(s:search_engines, a:search_engine)
    echoerr 'Search engine: '.a:search_engine.' is not exist!'
    return ''
  endif

  return printf(s:search_engines[a:search_engine], vimrc#search_engine#url_encode(a:keyword))
endfunction

" TODO: Move to browser.vim
function! vimrc#search_engine#search(search_engine, keyword)
  call vimrc#browser#async_open_url(vimrc#search_engine#get_url(a:search_engine, a:keyword))
endfunction

" TODO: Move to browser.vim
function! vimrc#search_engine#client_search(search_engine, keyword)
  call vimrc#browser#client_async_open_url(vimrc#search_engine#get_url(a:search_engine, a:keyword))
endfunction
