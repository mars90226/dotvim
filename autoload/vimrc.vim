" Use directory junction in Windows to link $HOME."/.vim" to $VIM."/vimfiles"
let s:vimhome = $HOME . '/.vim'
let s:vim_mode = $VIM_MODE

function! vimrc#get_vimhome() abort
  return s:vimhome
endfunction

function! vimrc#get_vim_mode() abort
  return s:vim_mode
endfunction

function! vimrc#source(path) abort
  let abspath = resolve(s:vimhome.'/'.a:path)
  execute 'source '.fnameescape(abspath)
endfunction

" Utilities
" Execute and save command
function! vimrc#execute_and_save(command) abort
  call histadd('cmd', a:command)
  execute a:command
endfunction

" Clear winfixheight & winfixwidth for resizing window
function! vimrc#clear_winfixsize() abort
  setlocal nowinfixheight
  setlocal nowinfixwidth
endfunction

function! vimrc#get_boundary_pattern(pattern) abort
  return '\<'.a:pattern.'\>'
endfunction
