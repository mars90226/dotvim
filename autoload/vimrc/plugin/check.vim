" Plugin Check Utility

" Detect operating system
if has("win32") || has("win64")
  let s:os = "windows"
  let s:distro = "Windows"
else
  let s:os = systemlist("uname -a")[0]
  let s:distro = systemlist("lsb_release -is")[0]
endif

function! vimrc#plugin#check#get_os()
  return s:os
endfunction

function! vimrc#plugin#check#get_distro()
  return s:distro
endfunction

" Set nvim version
if has("nvim")
  let s:nvim_version = systemlist("nvim --version")[0]
  function! vimrc#plugin#check#nvim_version()
    return s:nvim_version
  endfunction

  function! vimrc#plugin#check#nvim_patch_version()
    return matchlist(s:nvim_version, '\v^NVIM v\d+\.\d+\.\d+-(\d+)')[1]
  endfunction
endif

" return empty string when no python support found
function! vimrc#plugin#check#python_version(...)
  let force = (a:0 >= 1 && type(a:1) == type(v:true)) ? a:1 : v:false

  if force || !exists("g:python_version")
    if has("python3")
      return substitute(split(execute('py3 import sys; print(sys.version)'), ' ')[0], '^\n', '', '')
    elseif has("python")
      return substitute(split(execute('py import sys; print(sys.version)'), ' ')[0], '^\n', '', '')
    else
      return ""
    endif
  else
    return g:python_version
  endif
endfunction

" check if current vim/neovim has async function
function! vimrc#plugin#check#has_async()
  return v:version >= 800 || has("nvim")
endfunction

function! vimrc#plugin#check#has_rpc()
  return has("nvim")
endfunction

function! vimrc#plugin#check#has_linux_build_env()
  return s:os !~ "windows" && s:os !~ "synology"
endfunction

let s:git_version = 'not initialized'
function! vimrc#plugin#check#git_version()
  if s:git_version == 'not initialized'
    let s:git_version = systemlist('git --version')[0]
    if v:shell_error
      let s:git_version = 'not installed'
    endif
  endif

  return s:git_version
endfunction

function! vimrc#plugin#check#has_jedi(...)
  let force = (a:0 >= 1 && type(a:1) == type(v:true)) ? a:1 : v:false

  if force || !exists("g:has_jedi")
    if has("python3")
      call system('pip3 show -qq jedi')
      return !v:shell_error
    elseif has("python")
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
function! vimrc#plugin#check#has_browser()
  return s:os !~ "synology"
endfunction
