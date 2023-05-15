" Variables
let s:search_patterns = {
  \ 'url': '\v%(https?://|git\@|git://|ssh://|ftp://|file:///)[0-9A-Za-z?=%/_.:,;~@!#$&()*+-]*',
  \ 'file': '\v%(^|^\.|\s\zs|\s\zs\.|\s\zs\.\.|^\.\.)[0-9A-Za-z~_-]*/[\[\]0-9A-Za-z_.#$%&+=/@-]*',
  \ 'hash': '\v<%(\x{7,40}|[0-9A-Za-z]{52}|\x{64})>',
  \ 'ip': '\v\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'}

" Utilities
function! vimrc#search#get_pattern(type) abort
  return s:search_patterns[a:type]
endfunction

function! vimrc#search#search(pattern, forward) abort
  let @/ = a:pattern
  call search(a:pattern, a:forward ? '' : 'b')
endfunction

" Functions
function! vimrc#search#search_url(...) abort
  let forward = a:0 >= 1 && type(a:0) == type(0) ? a:1 : v:true
  call vimrc#search#search(vimrc#search#get_pattern('url'), forward)
endfunction

function! vimrc#search#search_file(...) abort
  let forward = a:0 >= 1 && type(a:0) == type(0) ? a:1 : v:true
  call vimrc#search#search(vimrc#search#get_pattern('file'), forward)
endfunction

function! vimrc#search#search_hash(...) abort
  let forward = a:0 >= 1 && type(a:0) == type(0) ? a:1 : v:true
  call vimrc#search#search(vimrc#search#get_pattern('hash'), forward)
endfunction

function! vimrc#search#search_ip(...) abort
  let forward = a:0 >= 1 && type(a:0) == type(0) ? a:1 : v:true
  call vimrc#search#search(vimrc#search#get_pattern('ip'), forward)
endfunction

" Includes {{{
function! vimrc#search#define_search_mappings() abort
  nmap <silent><buffer> <M-s> <Plug>(search-prefix)
  nnoremap <silent><buffer> <M-s><M-s> <M-s>
endfunction
" }}}
