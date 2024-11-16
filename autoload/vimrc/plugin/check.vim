" Plugin Check Utility
" TODO: use vim.loop.os_uname()
function! vimrc#plugin#check#get_os(...) abort
  let force = (a:0 >= 1 && type(a:1) == type(v:true)) ? a:1 : v:false

  if force || !exists('g:os')
    " Detect operating system
    if has('win32') || has('win64')
      let g:os = 'windows'
    elseif has('mac')
      let g:os = 'mac'
    else
      let g:os = systemlist('uname -a')[0]
    endif
  endif

  return g:os
endfunction

" TODO: use vim.loop.os_uname()
function! vimrc#plugin#check#get_distro(...) abort
  let force = (a:0 >= 1 && type(a:1) == type(v:true)) ? a:1 : v:false

  if force || !exists('g:distro')
    if vimrc#plugin#check#get_os() =~# 'windows'
      let g:distro = 'Windows'
    else
      let g:distro = systemlist('lsb_release -is')[0]
    endif
  endif

  return g:distro
endfunction

" Check if nvim is inside nvim terminal
function! vimrc#plugin#check#in_nvim_terminal() abort
  return $NVIM !=# ''
endfunction

" return empty string when no python support found
function! vimrc#plugin#check#python_version(...) abort
  let force = (a:0 >= 1 && type(a:1) == type(v:true)) ? a:1 : v:false

  if force || !exists('g:python_version')
    if has('python3')
      let g:python_version = substitute(split(execute('py3 import sys; print(sys.version)'), ' ')[0], '^\n', '', '')
    elseif has('python')
      let g:python_version = substitute(split(execute('py import sys; print(sys.version)'), ' ')[0], '^\n', '', '')
    else
      let g:python_version = ''
    endif
  endif

  return g:python_version
endfunction

function! vimrc#plugin#check#has_linux_build_env() abort
  let os = vimrc#plugin#check#get_os()
  return os !~# 'windows' && os !~# 'synology'
endfunction

function! vimrc#plugin#check#has_cargo() abort
  return v:lua.require('vimrc.plugin_utils').is_executable('cargo') && vimrc#plugin#check#has_linux_build_env()
endfunction

let s:git_version = 'not initialized'
function! vimrc#plugin#check#git_version() abort
  if s:git_version ==# 'not initialized'
    let s:git_version = systemlist('git --version')[0]
    if v:shell_error
      let s:git_version = 'not installed'
    endif
  endif

  return s:git_version
endfunction

" Assume DSM has no browser
function! vimrc#plugin#check#has_browser() abort
  return vimrc#plugin#check#get_os() !~# 'synology'
endfunction

function! vimrc#plugin#check#has_ssh_host_client() abort
  return !empty($SSH_CLIENT_HOST)
endfunction
