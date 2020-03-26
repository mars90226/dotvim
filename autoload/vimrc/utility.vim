" Functions
" Escape colon, backslash and space
function! vimrc#utility#escape_symbol(expr)
  let l:expr = a:expr
  let l:expr = substitute(l:expr, '\\', '\\\\', 'g')
  let l:expr = substitute(l:expr, ':', '\\:', 'g')
  let l:expr = substitute(l:expr, ' ', '\\ ', 'g')

  return l:expr
endfunction

function! vimrc#utility#warn(message)
  echohl WarningMsg
  echom a:message
  echohl None
  return 0
endfunction

function! vimrc#utility#get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection ==# 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! vimrc#utility#quit_tab()
  try
    tabclose
  catch /E784/ " Can't close last tab
    qall
  endtry
endfunction

function! vimrc#utility#window_equal()
  windo setlocal nowinfixheight nowinfixwidth
  wincmd =
endfunction

" Delete inactive buffers
function! vimrc#utility#delete_inactive_buffers(wipeout, bang)
  "From tabpagebuflist() help, get a list of all buffers in all tabs
  let visible_buffers = {}
  for t in range(tabpagenr('$'))
    for b in tabpagebuflist(t + 1)
      let visible_buffers[b] = 1
    endfor
  endfor

  "Below originally inspired by Hara Krishna Dara and Keith Roberts
  "http://tech.groups.yahoo.com/group/vim/message/56425
  let wipeout_count = 0
  if a:wipeout
    let cmd = 'bwipeout'
  else
    let cmd = 'bdelete'
  endif
  for b in range(1, bufnr('$'))
    if buflisted(b) && !getbufvar(b,'&mod') && !has_key(visible_buffers, b)
      "bufno listed AND isn't modified AND isn't in the list of buffers open in windows and tabs
      if a:bang
        silent exec cmd . '!' b
      else
        silent exec cmd b
      endif
      let wipeout_count = wipeout_count + 1
    endif
  endfor

  if a:wipeout
    echomsg wipeout_count . ' buffer(s) wiped out'
  else
    echomsg wipeout_count . ' buffer(s) deleted'
  endif
endfunction

" vimrc#utility#execute_command() for executing command with query
function! vimrc#utility#execute_command(command, prompt)
  " TODO input completion
  let query = input(a:prompt)
  if query !=# ''
    execute a:command . ' ' . query
  else
    echomsg 'Cancelled!'
  endif
endfunction

" sdcv
let s:sdcv_command = vimrc#terminal#get_open_command() . ' sdcv'

function! vimrc#utility#get_sdcv_command()
  return s:sdcv_command
endfunction

" xdg-open
let s:xdg_open_command = vimrc#terminal#get_open_command() . ' xdg-open'

function! vimrc#utility#get_xdg_open()
  return s:xdg_open_command
endfunction

" DiffOrig
function! vimrc#utility#diff_original()
  vertical new
  set buftype=nofile
  read ++edit #
  0d_
  diffthis
  wincmd p
  diffthis
endfunction

function! vimrc#utility#file_size(path)
  let path = expand(a:path)
  if isdirectory(path)
    echomsg path . ' is directory!'
    return
  endif

  let file_size = getfsize(path)
  let gb = file_size / (1024 * 1024 * 1024)
  let mb = file_size / (1024 * 1024) % 1024
  let kb = file_size / (1024) % 1024
  let byte = file_size % 1024

  echomsg path . ' size is '
        \ . (gb > 0 ? gb . 'GB, ' : '')
        \ . (mb > 0 ? mb . 'MB, ' : '')
        \ . (kb > 0 ? kb . 'KB, ' : '')
        \ . byte . 'byte'
endfunction

function! vimrc#utility#set_tab_size(size)
  let &l:tabstop     = a:size
  let &l:shiftwidth  = a:size
  let &l:softtabstop = a:size
endfunction

" Borrowed from gv.vim
function! vimrc#utility#get_cursor_syntax()
  return synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction

" Find the cursor {{{
function! vimrc#utility#blink_cursor_location()
  let cursorline = &cursorline
  let cursorcolumn = &cursorcolumn

  let &cursorline = 1
  let &cursorcolumn = 1

  call timer_start(200, function('s:blink_cursor_location_callback', [cursorline, cursorcolumn]))
endfunction

function! s:blink_cursor_location_callback(cursorline, cursorcolumn, timer_id)
  let &cursorline = a:cursorline
  let &cursorcolumn = a:cursorcolumn
endfunction
" }}}

function! vimrc#utility#refresh_display()
  let $DISPLAY = split(systemlist('tmux show-environment DISPLAY')[0], '=')[1]
endfunction

" Trim whitespace
function! vimrc#utility#trim_whitespace()
    let l:save = winsaveview()
    " FIXME vint: Use substitute() instead of :substitue
    %substitute/\s\+$//e
    call winrestview(l:save)
endfunction

function! vimrc#utility#set_scratch()
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
endfunction
