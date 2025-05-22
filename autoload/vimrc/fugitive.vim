" Variables
" TODO: Improve variable name
let s:fugitive_plugin_script_name = 'autoload/fugitive.vim'

function! vimrc#fugitive#get_fugitive_plugin_snr() abort
  if !exists('s:fugitive_plugin_snr')
    let s:fugitive_plugin_snr = vimrc#utility#get_script_id(s:fugitive_plugin_script_name)
  endif

  return s:fugitive_plugin_snr
endfunction

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
function! vimrc#fugitive#settings() abort
  setlocal buftype=nowrite
endfunction

function! vimrc#fugitive#git_settings() abort
  setlocal nospell
endfunction

function! vimrc#fugitive#gitcommit_settings() abort
  setlocal complete+=k
  setlocal nolist
  setlocal spell
endfunction

function! vimrc#fugitive#blame_settings() abort
endfunction

" For fugitive://* buffers
function! vimrc#fugitive#fugitive_buffer_settings() abort
  setlocal bufhidden=delete

  " Use fugitive's '=' mapping
  let n_maparg = maparg('=', 'n', v:false, v:true)
  if has_key(n_maparg, 'rhs')
    execute 'nnoremap <buffer> <silent> <Tab> '.vimrc#utility#replace_sid_with_snr(vimrc#fugitive#get_fugitive_plugin_snr(), n_maparg.rhs)
  endif
  let x_maparg = maparg('=', 'x', v:false, v:true)
  if has_key(x_maparg, 'rhs')
    execute 'xnoremap <buffer> <silent> <Tab> '.vimrc#utility#replace_sid_with_snr(vimrc#fugitive#get_fugitive_plugin_snr(), x_maparg.rhs)
  endif

  " Use fugitive's '-' mapping
  nmap <buffer> <silent> _               :vsplit<CR>-
  nmap <buffer> <silent> <Space>-        :split<CR>-
  nmap <buffer> <silent> <Space><Space>- :tab split<CR>-

  " :cnext and :cprevious like mapping with fugitive
  " TODO: Organize code
  nnoremap <silent><buffer> ]g :copen<CR>:lua require('vimrc.quickfix').move_next()<CR>:call vimrc#quickfix#open('Gedit')<CR>
  nnoremap <silent><buffer> [g :copen<CR>:lua require('vimrc.quickfix').move_previous()<CR>:call vimrc#quickfix#open('Gedit')<CR>

  " Avoid conflicting with git filetype mappings
  if &filetype !=# 'git'
    call vimrc#git#include_git_mappings('fugitive_buffer')
  endif
endfunction

" Mappings
function! vimrc#fugitive#mappings() abort
  nnoremap <buffer> <silent> Su :GitDispatch stash -u<CR>
  nnoremap <buffer> <silent> Sp :GitDispatch stash pop<CR>
  nnoremap <buffer> <silent> gp :Git push<CR>
  nnoremap <buffer> <silent> gl :Git pull<CR>
  nnoremap <buffer> <silent> gL :Git pull --rebase<CR>

  if v:lua.require('vimrc.plugin_utils').is_executable('rust-commitizen')
    nnoremap <buffer> <silent> czc :call vimrc#tui#run('float', 'rust-commitizen', 1)<CR>
  endif
  if v:lua.require('vimrc.plugin_utils').is_executable('git-cz')
    nnoremap <buffer> <silent> czC :call vimrc#tui#run('float', 'git cz', 1)<CR>
  endif

  nnoremap <buffer> <silent> coO :execute 'Git checkout --ours '.fugitive#StatusCfile()<CR>
  nnoremap <buffer> <silent> coT :execute 'Git checkout --theirs '.fugitive#StatusCfile()<CR>

  call vimrc#git#include_git_mappings('fugitive')
  call vimrc#search#define_search_mappings()

  " GV
  nnoremap <buffer> <silent> <Leader>gv :call vimrc#gv#show_file(fugitive#StatusCfile(), {})<CR>
  nnoremap <buffer> <silent> <Leader>gV :call vimrc#gv#show_file(fugitive#StatusCfile(), {'author': g:company_domain})<CR>
  nnoremap <buffer> <silent> <Leader>g<C-V> :call vimrc#gv#show_file(fugitive#StatusCfile(), {'author': g:company_email})<CR>

  " Flog
  nnoremap <buffer> <silent> <Leader>gf :call vimrc#flog#show_file(fugitive#StatusCfile(), {})<CR>
  nnoremap <buffer> <silent> <Leader>gF :call vimrc#flog#show_file(fugitive#StatusCfile(), {'author': g:company_domain})<CR>
  nnoremap <buffer> <silent> <Leader>g<C-F> :call vimrc#flog#show_file(fugitive#StatusCfile(), {'author': g:company_email})<CR>
endfunction

function! vimrc#fugitive#git_mappings() abort
  call vimrc#git#include_git_mappings('git')
  call vimrc#search#define_search_mappings()

  nnoremap <buffer> <silent> gq :close<CR>
endfunction

function! vimrc#fugitive#blame_mappings() abort
  call vimrc#git#include_git_mappings('fugitive_blame')
  call vimrc#search#define_search_mappings()
endfunction

" Functions
function! vimrc#fugitive#review_last_commit() abort
  if exists('b:git_dir')
    Gtabedit HEAD^{}
    nnoremap <buffer> <silent> q :<C-U>bdelete<CR>
  else
    echo 'No git a git repository:' expand('%:p')
  endif
endfunction

function! vimrc#fugitive#git_dispatch(command) abort
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

function! vimrc#fugitive#commit_sha() abort
  let filename = fugitive#Object(@%)
  if filename =~# ':'
    let sha = split(filename, ':')[0]
  else
    let sha = 'HEAD'
  endif

  return sha
endfunction

function! vimrc#fugitive#blame_sha(...) abort
  " Borrowed from gv#sha() in gv.vim
  return matchstr(get(a:000, 0, getline('.')), '\zs[a-f0-9]\+')
endfunction

function! vimrc#fugitive#diff_staged_file(file) abort
  execute 'Gtabedit :'.a:file
  execute 'Gdiffsplit HEAD:'.a:file
endfunction

function! vimrc#fugitive#goto_blame_line(split) abort
  let current_line = line('.')
  if a:split !=# 'edit'
    execute a:split
  endif
  execute current_line.'Git blame'
endfunction

function! vimrc#fugitive#close_all_fugitive_buffers() abort
  call vimrc#utility#delete_buffers({ _, buf -> bufname(buf) =~# '^fugitive:///' })
endfunction
