" Variabls
let s:url_pattern  = '\v%(https?://|git\@|git://|ssh://|ftp://|file:///)[0-9A-Za-z?=%/_.:,;~@!#$&()*+-]*'
let s:file_pattern = '\v%(^|^\.|\s\zs|\s\zs\.|\s\zs\.\.|^\.\.)[0-9A-Za-z~_-]*/[\[\]0-9A-Za-z_.#$%&+=/@-]*'
let s:hash_pattern = '\v<%(\x{7,40}|[0-9A-Za-z]{52}|\x{64})>'
let s:ip_pattern   = '\v\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'

" Utilities
function! vimrc#search#search(pattern, forward)
  let @/ = a:pattern
  call search(a:pattern, a:forward ? '' : 'b')
endfunction

" Functions
function! vimrc#search#search_url(...)
  let forward = a:0 >= 1 && type(a:0) == type(0) ? a:1 : v:true
  call vimrc#search#search(s:url_pattern, forward)
endfunction

function! vimrc#search#search_file(...)
  let forward = a:0 >= 1 && type(a:0) == type(0) ? a:1 : v:true
  call vimrc#search#search(s:file_pattern, forward)
endfunction

function! vimrc#search#search_hash(...)
  let forward = a:0 >= 1 && type(a:0) == type(0) ? a:1 : v:true
  call vimrc#search#search(s:hash_pattern, forward)
endfunction

function! vimrc#search#search_ip(...)
  let forward = a:0 >= 1 && type(a:0) == type(0) ? a:1 : v:true
  call vimrc#search#search(s:ip_pattern, forward)
endfunction

" Includes {{{
function! vimrc#search#define_search_mappings()
  nnoremap <silent><buffer> <M-s><C-F> :call vimrc#search#search_file(0)<CR>
  nnoremap <silent><buffer> <M-s><M-h> :call vimrc#search#search_hash(0)<CR>
  nnoremap <silent><buffer> <M-s><C-U> :call vimrc#search#search_url(0)<CR>
  nnoremap <silent><buffer> <M-s><M-i> :call vimrc#search#search_ip(0)<CR>
endfunction
" }}}
