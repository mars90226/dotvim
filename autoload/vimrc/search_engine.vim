" Utilities
" TODO: Move to utils.lua and add key mappings

" Borrowed from unimpaired
function! vimrc#search_engine#url_encode(str) abort
  " iconv trick to convert utf-8 bytes to 8bits indiviual char.
  return substitute(iconv(a:str, 'latin1', 'utf-8'),'[^A-Za-z0-9_.~-]','\="%".printf("%02X",char2nr(submatch(0)))','g')
endfunction

" Borrowed from unimpaired
function! vimrc#search_engine#url_decode(str) abort
  let str = substitute(substitute(substitute(a:str,'%0[Aa]\n$','%0A',''),'%0[Aa]','\n','g'),'+',' ','g')
  return iconv(substitute(str,'%\(\x\x\)','\=nr2char("0x".submatch(1))','g'), 'utf-8', 'latin1')
endfunction

" Includes {{{
function! vimrc#search_engine#define_search_command(command, search_engine, prefix, suffix) abort
  execute 'command! -bar -nargs=1 '.a:command." call vimrc#search_engine#search('".a:search_engine."', <f-args>)"
  call vimrc#browser#include_search_mappings(a:command, a:prefix, a:suffix)
endfunction

function! vimrc#search_engine#define_client_search_command(command, search_engine, prefix, suffix) abort
  execute 'command! -bar -nargs=1 '.a:command." call vimrc#search_engine#client_search('".a:search_engine."', <f-args>)"
  call vimrc#browser#include_search_mappings(a:command, a:prefix, a:suffix)
endfunction

function! vimrc#search_engine#define_command(command, browser, search_engine, prefix, suffix) abort
  if a:browser ==# 'client'
    call vimrc#search_engine#define_client_search_command(a:command, a:search_engine, a:prefix, a:suffix)
  else
    call vimrc#search_engine#define_search_command(a:command, a:search_engine, a:prefix, a:suffix)
  endif
endfunction
" }}}

" Configs
" TODO: Add more search engines
let s:search_engines = {
      \ 'google': 'https://www.google.com/search?q=%s',
      \ 'duckduckgo': 'https://duckduckgo.com/?q=%s',
      \ 'devdocs': 'https://devdocs.io/?q=%s',
      \ 'mdn': 'https://developer.mozilla.org/en-US/search?q=%s'
      \ }

" Functions
function! vimrc#search_engine#get_url(search_engine, keyword) abort
  if !has_key(s:search_engines, a:search_engine)
    echoerr 'Search engine: '.a:search_engine.' is not exist!'
    return ''
  endif

  return printf(s:search_engines[a:search_engine], vimrc#search_engine#url_encode(a:keyword))
endfunction

" TODO: Move to browser.vim
function! vimrc#search_engine#search(search_engine, keyword) abort
  call vimrc#browser#async_open_url(vimrc#search_engine#get_url(a:search_engine, a:keyword))
endfunction

" TODO: Move to browser.vim
function! vimrc#search_engine#client_search(search_engine, keyword) abort
  call vimrc#browser#client_async_open_url(vimrc#search_engine#get_url(a:search_engine, a:keyword))
endfunction
