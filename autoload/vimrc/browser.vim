" Utility functions
function! vimrc#browser#get_command(command) abort
  if v:lua.require('vimrc.plugin_utils').is_executable('firefox')
    return 'firefox '.a:command
  elseif v:lua.require('vimrc.plugin_utils').is_executable('chrome')
    return 'chrome '.a:command
  else
    return ''
  endif
endfunction

function! vimrc#browser#get_search_command(keyword) abort
  if v:lua.require('vimrc.plugin_utils').is_executable('firefox')
    return "firefox --search '" . a:keyword . "'"
  elseif v:lua.require('vimrc.plugin_utils').is_executable('chrome')
    return "chrome '? " . a:keyword . "'"
  else
    return ''
  endif
endfunction

function! vimrc#browser#get_client_command(command) abort
  " TODO Check client browser
  return 'ssh '.$SSH_CLIENT_HOST." 'firefox ".a:command."'"
endfunction

function! vimrc#browser#get_client_search_command(keyword) abort
  " TODO Check client browser
  return 'ssh '.$SSH_CLIENT_HOST." \"firefox --search '".a:keyword."'\""
endfunction

" Utilities {{{
" Asynchronously browse internal
function! vimrc#browser#async_execute(command) abort
  call jobstart(a:command, {})
endfunction

function! vimrc#browser#async_browse(command) abort
  if empty(a:command)
    echoerr 'No browser found!'
    return
  endif

  call vimrc#browser#async_execute(a:command)
endfunction
" }}}

" Includes {{{
function! vimrc#browser#include_search_mappings(command, prefix, suffix) abort
  let cword_key  = a:prefix . a:suffix
  let cWORD_key  = a:prefix . toupper(a:suffix)
  let visual_key = a:prefix . a:suffix
  let query_key  = a:prefix . g:mapleader . a:suffix

  call vimrc#mapping#include_cursor_mappings(a:command, cword_key, cWORD_key)
  call vimrc#mapping#include_visual_selection_mappings(a:command, visual_key)
  call vimrc#mapping#include_query_mappings(a:command, query_key, a:command)
endfunction

function! vimrc#browser#include_open_url_mappings(command, prefix, suffix) abort
  let cword_key  = a:prefix . toupper(a:suffix)
  let cWORD_key  = a:prefix . a:suffix
  let visual_key = a:prefix . a:suffix
  let query_key  = a:prefix . g:mapleader . a:suffix

  call vimrc#mapping#include_cursor_mappings(a:command, cword_key, cWORD_key)
  call vimrc#mapping#include_visual_selection_mappings(a:command, visual_key)
  call vimrc#mapping#include_query_mappings(a:command, query_key, a:command)
endfunction

function! vimrc#browser#define_command(command, browser, type, prefix, suffix) abort
  let function = 'vimrc#browser#'.(a:browser ==# 'client' ? 'client_' : '').'async_'.a:type
  execute 'command! -bar -nargs=1 '.a:command.' call '.function.'(<f-args>)'

  if a:type ==# 'open_url' || a:type ==# 'open'
    call vimrc#browser#include_open_url_mappings(a:command, a:prefix, a:suffix)
  elseif a:type ==# 'search_keyword' || a:type ==# 'open_keyword'
    call vimrc#browser#include_search_mappings(a:command, a:prefix, a:suffix)
  endif
endfunction
" }}}

" Functions
" Asynchronously browse URI
" TODO Move to better place?
function! vimrc#browser#async_open(uri) abort
  " Detect URI and use browser
  if a:uri =~# '\v^https?://'
    if has('wsl')
      call vimrc#browser#async_open_url(a:uri, 1)
    elseif v:lua.require("vimrc.check").has_ssh_host_client()
      call vimrc#browser#client_async_open_url(a:uri, 1)
    else
      call vimrc#browser#async_open_url(a:uri, 1)
    endif
  else
    " Use xdg-open to open URI
    if !has('unix') || !v:lua.require('vimrc.plugin_utils').is_executable('xdg-open')
      echoerr 'No xdg-open found!'
      return
    endif

    call vimrc#browser#async_execute('xdg-open '.a:uri)
  endif
endfunction

" Asynchronously browse keyword
function! vimrc#browser#async_open_keyword(...) abort
  let args = copy(a:000)

  if has('wsl')
    call call('vimrc#browser#async_search_keyword', args)
  elseif v:lua.require("vimrc.check").has_ssh_host_client()
    call call('vimrc#browser#client_async_search_keyword', args)
  else
    call call('vimrc#browser#async_search_keyword', args)
  endif
endfunction

" Asynchronously open URL in browser
function! vimrc#browser#async_open_url(url, ...) abort
  let silent = a:0 > 0 ? a:1 : v:false
  if !silent
    redraw
    echo 'Open URL: '.a:url
  endif
  call vimrc#browser#async_browse(vimrc#browser#get_command(a:url))
endfunction

" Asynchronously search keyword in browser
function! vimrc#browser#async_search_keyword(keyword, ...) abort
  let silent = a:0 > 0 ? a:1 : v:false
  if !silent
    redraw
    echo 'Search keyword: '.a:keyword
  endif
  call vimrc#browser#async_browse(vimrc#browser#get_search_command(a:keyword))
endfunction

" Asynchronously open URL in client browser
function! vimrc#browser#client_async_open_url(url, ...) abort
  let silent = a:0 > 0 ? a:1 : v:false
  if !silent
    redraw
    echo 'Open URL in client browser: '.a:url
  endif
  call vimrc#browser#async_browse(vimrc#browser#get_client_command(a:url))
endfunction

" Asynchronously search keyword in client browser
function! vimrc#browser#client_async_search_keyword(keyword, ...) abort
  let silent = a:0 > 0 ? a:1 : v:false
  if !silent
    redraw
    echo 'Search keyword in client browser: '.a:keyword
  endif
  call vimrc#browser#async_browse(vimrc#browser#get_client_search_command(a:keyword))
endfunction
