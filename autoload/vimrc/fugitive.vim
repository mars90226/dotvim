" Utilities
" Borrowed from vim-fugitive {{{
let s:common_efm = ''
      \ . '%+Egit:%.%#,'
      \ . '%+Eusage:%.%#,'
      \ . '%+Eerror:%.%#,'
      \ . '%+Efatal:%.%#,'
      \ . '%-G%.%#%\e[K%.%#,'
      \ . '%-G%.%#%\r%.%\+'

let s:fnameescape = " \t\n*?[{`$\\%#'\"|!<"
function! s:fnameescape(file) abort
  if exists('*fnameescape')
    return fnameescape(a:file)
  else
    return escape(a:file, s:fnameescape)
  endif
endfunction
" }}}

" Settings
function! vimrc#fugitive#gitcommit_settings()
  setlocal complete+=k
  setlocal nolist
  setlocal spell
endfunction

" For fugitive://* buffers
function! vimrc#fugitive#fugitive_buffer_settings()
  setlocal bufhidden=delete
endfunction

" Mappings
function! vimrc#fugitive#mappings()
  nnoremap <buffer> <silent> Su :GitDispatch stash -u<CR>
  nnoremap <buffer> <silent> Sp :GitDispatch stash pop<CR>
  nnoremap <buffer> <silent> gp :Gpush<CR>
  nnoremap <buffer> <silent> gl :Gpull<CR>
  nnoremap <buffer> <silent> gL :Gpull --rebase<CR>
endfunction

function! vimrc#fugitive#git_mappings()
  call vimrc#git#include_git_mappings("fugitive#Object(@%)")
endfunction

function! vimrc#fugitive#blame_mappings()
  call vimrc#git#include_git_mappings("vimrc#fugitive#blame_sha()")
endfunction

" Functions
function! vimrc#fugitive#review_last_commit()
  if exists('b:git_dir')
    Gtabedit HEAD^{}
    nnoremap <buffer> <silent> q :<C-U>bdelete<CR>
  else
    echo 'No git a git repository:' expand('%:p')
  endif
endfunction

function! vimrc#fugitive#git_dispatch(command)
  let [mp, efm, cc] = [&l:mp, &l:efm, get(b:, 'current_compiler', '')]
  try
    let b:current_compiler = 'git'
    let &l:errorformat = s:common_efm
    let &l:makeprg = 'git ' . a:command
    Make!
  finally
    let [&l:mp, &l:efm, b:current_compiler] = [mp, efm, cc]
    if empty(cc) | unlet! b:current_compiler | endif
  endtry
endfunction

function! vimrc#fugitive#commit_sha()
  let filename = fugitive#Object(@%)
  if filename =~# ':'
    let sha = split(filename, ':')[0]
  else
    let sha = 'HEAD'
  endif

  return sha
endfunction

function! vimrc#fugitive#blame_sha(...)
  " Borrowed from gv#sha() in gv.vim
  return matchstr(get(a:000, 0, getline('.')), '\zs[a-f0-9]\+')
endfunction
