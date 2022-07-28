" Variabls
let s:url_pattern  = '\v%(https?://|git\@|git://|ssh://|ftp://|file:///)[0-9A-Za-z?=%/_.:,;~@!#$&()*+-]*'
let s:file_pattern = '\v%(^|^\.|\s\zs|\s\zs\.|\s\zs\.\.|^\.\.)[0-9A-Za-z~_-]*/[\[\]0-9A-Za-z_.#$%&+=/@-]*'
let s:hash_pattern = '\v<%(\x{7,40}|[0-9A-Za-z]{52}|\x{64})>'
let s:ip_pattern   = '\v\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'

" Utilities
function! vimrc#search#search(pattern, forward) abort
  let @/ = a:pattern
  call search(a:pattern, a:forward ? '' : 'b')
endfunction

" Functions
function! vimrc#search#search_url(...) abort
  let forward = a:0 >= 1 && type(a:0) == type(0) ? a:1 : v:true
  call vimrc#search#search(s:url_pattern, forward)
endfunction

function! vimrc#search#search_file(...) abort
  let forward = a:0 >= 1 && type(a:0) == type(0) ? a:1 : v:true
  call vimrc#search#search(s:file_pattern, forward)
endfunction

function! vimrc#search#search_hash(...) abort
  let forward = a:0 >= 1 && type(a:0) == type(0) ? a:1 : v:true
  call vimrc#search#search(s:hash_pattern, forward)
endfunction

function! vimrc#search#search_ip(...) abort
  let forward = a:0 >= 1 && type(a:0) == type(0) ? a:1 : v:true
  call vimrc#search#search(s:ip_pattern, forward)
endfunction

" Includes {{{
function! vimrc#search#define_search_mappings() abort
  nmap <silent><buffer> <M-s> <Plug>(search-prefix)
  nnoremap <silent><buffer> <M-s><M-s> <M-s>
endfunction
" }}}
