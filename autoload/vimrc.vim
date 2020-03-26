" Use directory junction in Windows to link $HOME."/.vim" to $VIM."/vimfiles"
let s:vimhome = $HOME . '/.vim'
let s:vim_mode = $VIM_MODE

function! vimrc#get_vimhome()
  return s:vimhome
endfunction

function! vimrc#get_vim_mode()
  return s:vim_mode
endfunction

function! vimrc#source(path)
  let abspath = resolve(s:vimhome.'/'.a:path)
  execute 'source '.fnameescape(abspath)
endfunction

" Utilities
function! vimrc#remap(old_key, new_key, mode)
  let mapping = maparg(a:old_key, a:mode)

  if !empty(mapping)
    execute a:mode . 'unmap ' . a:old_key
    execute a:mode . 'noremap ' . a:new_key . ' ' . mapping
  endif
endfunction

" Get char
function! vimrc#getchar(...) abort
  let prompt = a:0 >= 1 && type(a:1) == type('') ? a:1 : 'Press any key: '

  redraw | echo prompt
  let c = getchar()
  while c ==# "\<CursorHold>"
    redraw | echo prompt
    let c = getchar()
  endwhile
  return c
endfunction

function! vimrc#getchar_string(...) abort
  let c = a:0 >= 1 ? vimrc#getchar(a:1) : vimrc#getchar()
  return type(c) == type('') ? c : nr2char(c)
endfunction

function! vimrc#display_char() abort
  let c = vimrc#getchar()
  redraw | echomsg printf('Raw: "%s" | Char: "%s"', c, nr2char(c))
endfunction

" Clear and redraw
function! vimrc#clear_and_redraw()
  call vimrc#lightline#refresh()
endfunction

" Execute and save command
function! vimrc#execute_and_save(command)
  call histadd('cmd', a:command)
  execute a:command
endfunction

" Clear winfixheight & winfixwidth for resizing window
function! vimrc#clear_winfixsize()
  setlocal nowinfixheight
  setlocal nowinfixwidth
endfunction

function! vimrc#get_boundary_pattern(pattern)
  return '\<'.a:pattern.'\>'
endfunction
