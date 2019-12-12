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

" Mappings
function! vimrc#fugitive#mappings()
  nnoremap <buffer> <silent> Su :GitDispatch stash -u<CR>
  nnoremap <buffer> <silent> Sp :GitDispatch stash pop<CR>
  nnoremap <buffer> <silent> gp :Gpush<CR>
  nnoremap <buffer> <silent> gl :Gpull<CR>
  nnoremap <buffer> <silent> gL :Gpull --rebase<CR>
endfunction

function! vimrc#fugitive#git_mappings()
  nnoremap <buffer> <silent> <Leader>gd :call vimrc#fzf#git#diff_commit(fugitive#Object(@%))<CR>
  nnoremap <buffer> <silent> <Leader>gf :call vimrc#fzf#git#files_commit(fugitive#Object(@%))<CR>
  nnoremap <buffer> <silent> <Leader>gg :call vimrc#fzf#git#grep_commit(fugitive#Object(@%), input('Git grep: '))<CR>
  nnoremap <buffer> <silent> <Leader>gt :execute 'Git show --stat '.fugitive#Object(@%)<CR>
endfunction

function! vimrc#fugitive#blame_mappings()
  nnoremap <buffer> <silent> <Leader>gd :call vimrc#fzf#git#diff_commit(vimrc#fugitive#blame_sha())<CR>
  nnoremap <buffer> <silent> <Leader>gf :call vimrc#fzf#git#files_commit(vimrc#fugitive#blame_sha())<CR>
  nnoremap <buffer> <silent> <Leader>gg :call vimrc#fzf#git#grep_commit(vimrc#fugitive#blame_sha(), input('Git grep: '))<CR>
  nnoremap <buffer> <silent> <Leader>gt :execute 'Git show --stat '.vimrc#fugitive#blame_sha()<CR>
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
