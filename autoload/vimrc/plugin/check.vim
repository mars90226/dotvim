" Plugin Check Utility

" Detect operating system
if has('win32') || has('win64')
  let s:os = 'windows'
else
  let s:os = systemlist('uname -a')[0]
endif

function! vimrc#plugin#check#get_os() abort
  return s:os
endfunction

function! vimrc#plugin#check#get_distro(...) abort
  let force = (a:0 >= 1 && type(a:1) == type(v:true)) ? a:1 : v:false

  if force || !exists('g:distro')
    if s:os =~# 'windows'
      return 'Windows'
    else
      return systemlist('lsb_release -is')[0]
    endif
  else
    return g:distro
  endif
endfunction

" Set nvim version
if has('nvim')
  function! vimrc#plugin#check#nvim_version() abort
    if exists('g:nvim_version')
      return g:nvim_version
    endif

    let g:nvim_version = systemlist('nvim --version')[0]
    return g:nvim_version
  endfunction

  function! vimrc#plugin#check#nvim_patch_version() abort
    return matchlist(vimrc#plugin#check#nvim_version(), '\v^NVIM v\d+\.\d+\.\d+-%(dev\+)?(\d+)')[1]
  endfunction

  " Check if $NVIM_TERMINAL is set or parent process is nvim
  function! vimrc#plugin#check#nvim_terminal() abort
    if exists('g:nvim_terminal')
      return g:nvim_terminal
    endif

    " Check bash environment variable in neovim terminal
    if $NVIM_TERMINAL ==# 'yes'
      let g:nvim_terminal = 'yes'
      return g:nvim_terminal
    endif

    if vimrc#plugin#check#get_os() =~# 'windows'
      " FIXME: Implement parent process check in Windows
      let g:nvim_terminal = 'no'
      return g:nvim_terminal
    endif

    " Use /proc to get parent process info
    let parent_pid = split(readfile('/proc/'.getpid().'/stat')[0])[3]
    let parent_cmdline = readfile('/proc/'.parent_pid.'/cmdline')[0]
    if parent_cmdline =~# 'nvim'
      let g:nvim_terminal = 'yes'
    else
      let g:nvim_terminal = 'no'
    endif

    return g:nvim_terminal
  endfunction
endif

function! vimrc#plugin#check#has_floating_window() abort
  return exists('*nvim_win_set_config')
endfunction

" return empty string when no python support found
function! vimrc#plugin#check#python_version(...) abort
  let force = (a:0 >= 1 && type(a:1) == type(v:true)) ? a:1 : v:false

  if force || !exists('g:python_version')
    if has('python3')
      return substitute(split(execute('py3 import sys; print(sys.version)'), ' ')[0], '^\n', '', '')
    elseif has('python')
      return substitute(split(execute('py import sys; print(sys.version)'), ' ')[0], '^\n', '', '')
    else
      return ''
    endif
  else
    return g:python_version
  endif
endfunction

" check if current vim/neovim has async function
function! vimrc#plugin#check#has_async() abort
  return v:version >= 800 || has('nvim')
endfunction

function! vimrc#plugin#check#has_rpc() abort
  return has('nvim')
endfunction

function! vimrc#plugin#check#has_linux_build_env() abort
  return s:os !~# 'windows' && s:os !~# 'synology'
endfunction

function! vimrc#plugin#check#has_cargo() abort
  return executable('cargo') && vimrc#plugin#check#has_linux_build_env()
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

function! vimrc#plugin#check#has_jedi(...) abort
  let force = (a:0 >= 1 && type(a:1) == type(v:true)) ? a:1 : v:false

  if force || !exists('g:has_jedi')
    if has('python3')
      call system('pip3 show -qq jedi')
      return !v:shell_error
    elseif has('python')
      call system('pip show -qq jedi')
      return !v:shell_error
    else
      return 0
    endif
  else
    return g:has_jedi == 1
  endif
endfunction

" Assume DSM has no browser
function! vimrc#plugin#check#has_browser() abort
  return s:os !~# 'synology'
endfunction

function! vimrc#plugin#check#has_ssh_host_client() abort
  return !empty($SSH_CLIENT_HOST)
endfunction

let s:clang_dir_prefix = '/usr/lib/llvm-'
function! vimrc#plugin#check#detect_clang_dir(subpath) abort
  let clang_versions = map(glob(s:clang_dir_prefix.'*', v:false, v:true),
        \ { _, path -> matchstr(path, s:clang_dir_prefix.'\zs.*') } )

  if empty(clang_versions)
    return ''
  endif

  let newest_clang_version = sort(clang_versions, 'N')[-1]
  return s:clang_dir_prefix.newest_clang_version.a:subpath
endfunction
