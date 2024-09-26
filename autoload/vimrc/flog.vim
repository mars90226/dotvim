" Variables
let s:flog_cmd = 'Flog'

" Mappings
function! vimrc#flog#mappings() abort
  nnoremap <buffer><expr> q winnr('$') != 1 ? ':<C-U>wincmd w<CR>:<C-U>close<CR>' : 'q'

  " Alternative key mapping for those key mappings that are hard to type in ergonomic keyboard.
  nmap <buffer> ygr <Plug>(FlogYank)

  call vimrc#git#include_git_mappings('flog', v:true, v:true)
  call vimrc#search#define_search_mappings()
endfunction

" Functions
function! vimrc#flog#sha(...) abort
  let line = get(a:000, 0, line('.'))
  return flog#floggraph#commit#GetAtLine(line).hash
endfunction

function! vimrc#flog#_open(cmd, options, raw_args) abort
  let cmd = copy(a:cmd).' '

  " Currently only support :Flog builtin options, no "git log --graph" options
  for key in keys(a:options)
    if type(a:options[key]) != type('') && !a:options[key]
      continue
    endif

    let cmd .= '-'.key

    if type(a:options[key]) == type('')
      let cmd .= '='.a:options[key]
    endif

    let cmd .= ' '
  endfor

  if !empty(a:raw_args)
    let cmd .= ' -- '.a:raw_args
  endif

  execute cmd
endfunction

function! vimrc#flog#open(options) abort
  call vimrc#flog#_open(s:flog_cmd, a:options, '')
endfunction

function! vimrc#flog#show_file(file, options) abort
  let a:options['path'] = a:file ==# '%' ? expand('%') : a:file
  call vimrc#flog#_open(s:flog_cmd, a:options, '')
endfunction
