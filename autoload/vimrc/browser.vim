" Utility functions
function! vimrc#browser#get_command(command)
  if executable('firefox')
    return 'firefox '.a:command
  elseif executable('chrome')
    return 'chrome '.a:command
  else
    return ''
  endif
endfunction

function! vimrc#browser#get_search_command(keyword)
  if executable('firefox')
    return "firefox --search '" . a:keyword . "'"
  elseif executable('chrome')
    return "chrome '? " . a:keyword . "'"
  else
    return ''
  endif
endfunction

function! vimrc#browser#get_client_command(command)
  " TODO Check client browser
  return 'ssh '.$SSH_CLIENT_HOST." 'firefox ".a:command."'"
endfunction

function! vimrc#browser#get_client_search_command(keyword)
  " TODO Check client browser
  return 'ssh '.$SSH_CLIENT_HOST." \"firefox --search '".a:keyword."'\""
endfunction

" Utilities {{{
" Asynchronously browse internal
function! vimrc#browser#async_execute(command)
  " Currently only support neovim
  if !vimrc#plugin#check#has_rpc()
    echoerr 'This version of vim does not have RPC!'
    return
  endif

  call jobstart(a:command, {})
endfunction

function! vimrc#browser#async_browse(command)
  if empty(a:command)
    echoerr 'No browser found!'
    return
  endif

  call vimrc#browser#async_execute(a:command)
endfunction
" }}}

" Includes {{{
function! vimrc#browser#include_search_mappings(command, prefix, suffix)
  let cword_key  = a:prefix . a:suffix
  let cWORD_key  = a:prefix . toupper(a:suffix)
  let visual_key = a:prefix . a:suffix

  call vimrc#mapping#include_cursor_mappings(a:command, cword_key, cWORD_key)
  call vimrc#mapping#include_visual_selection_mappings(a:command, visual_key)
endfunction

function! vimrc#browser#include_open_url_mappings(command, prefix, suffix)
  let cword_key  = a:prefix . toupper(a:suffix)
  let cWORD_key  = a:prefix . a:suffix
  let visual_key = a:prefix . a:suffix

  call vimrc#mapping#include_cursor_mappings(a:command, cword_key, cWORD_key)
  call vimrc#mapping#include_visual_selection_mappings(a:command, visual_key)
endfunction

function! vimrc#browser#define_command(command, browser, type, prefix, suffix)
  let function = 'vimrc#browser#'.(a:browser ==# 'client' ? 'client_' : '').'async_'.a:type
  execute 'command! -bar -nargs=1 '.a:command.' call '.function.'(<f-args>)'

  if a:type ==# 'open_url'
    call vimrc#browser#include_open_url_mappings(a:command, a:prefix, a:suffix)
  elseif a:type ==# 'search_keyword'
    call vimrc#browser#include_search_mappings(a:command, a:prefix, a:suffix)
  endif
endfunction
" }}}

" Functions
" Asynchronously browse URI
" TODO Move to better place?
function! vimrc#browser#async_open(uri)
  " Use xdg-open to open URI
  if !has('unix') || !executable('xdg-open')
    echoerr 'No xdg-open found!'
    return
  endif

  call vimrc#browser#async_execute('xdg-open '.a:uri)
endfunction

" Asynchronously open URL in browser
function! vimrc#browser#async_open_url(url)
  echo 'Open URL: '.a:url
  call vimrc#browser#async_browse(vimrc#browser#get_command(a:url))
endfunction

" Asynchronously search keyword in browser
function! vimrc#browser#async_search_keyword(keyword)
  echo 'Search keyword: '.a:keyword
  call vimrc#browser#async_browse(vimrc#browser#get_search_command(a:keyword))
endfunction

" Asynchronously open URL in client browser
function! vimrc#browser#client_async_open_url(url)
  echo 'Open URL in client browser: '.a:url
  call vimrc#browser#async_browse(vimrc#browser#get_client_command(a:url))
endfunction

" Asynchronously search keyword in client browser
function! vimrc#browser#client_async_search_keyword(keyword)
  echo 'Search keyword in client browser: '.a:keyword
  call vimrc#browser#async_browse(vimrc#browser#get_client_search_command(a:keyword))
endfunction
