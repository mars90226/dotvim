" Use directory junction in Windows to link $HOME."/.vim" to $VIM."/vimfiles"
let s:vimhome = $HOME . '/.vim'
let s:vim_mode = $VIM_MODE

" Check if $NVIM_TERMINAL is set or parent process is nvim
let s:nvim_terminal = ($NVIM_TERMINAL ==# 'yes' ? $NVIM_TERMINAL :
      \ systemlist('ps -o ppid= -p '.getpid().' | xargs ps -o cmd= -p ')[0] =~# 'nvim' ? 'yes' : 'no')

function! vimrc#get_vimhome()
  return s:vimhome
endfunction

function! vimrc#get_vim_mode()
  return s:vim_mode
endfunction

function! vimrc#get_nvim_terminal()
  return s:nvim_terminal
endfunction

function! vimrc#source(path)
  let abspath = resolve(s:vimhome.'/'.a:path)
  execute 'source '.fnameescape(abspath)
endfunction

" Utilities
" Escape colon, backslash and space
function! vimrc#escape_symbol(expr)
  let l:expr = a:expr
  let l:expr = substitute(l:expr, '\\', '\\\\', 'g')
  let l:expr = substitute(l:expr, ':', '\\:', 'g')
  let l:expr = substitute(l:expr, ' ', '\\ ', 'g')

  return l:expr
endfunction

function! vimrc#warn(message)
  echohl WarningMsg | echomsg a:message | echohl None
endfunction

function! vimrc#get_visual_selection()
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

function! vimrc#check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction "}}}

function! vimrc#remap(old_key, new_key, mode)
  let mapping = maparg(a:old_key, a:mode)

  if !empty(mapping)
    execute a:mode . 'unmap ' . a:old_key
    execute a:mode . 'noremap ' . a:new_key . ' ' . mapping
  endif
endfunction

" Functions
function! vimrc#toggle_indent()
  if &expandtab
    setlocal noexpandtab
    setlocal tabstop=4
    setlocal softtabstop=4
    setlocal shiftwidth=4
  else
    setlocal expandtab
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
  endif
endfunction

" Toggle fold between manual and syntax
function! vimrc#toggle_fold()
  if &foldmethod ==# 'manual'
    setlocal foldmethod=syntax
  else
    setlocal foldmethod=manual
  endif
endfunction

function! vimrc#toggle_parent_folder_tag()
  let s:parent_folder_tag_pattern = './tags;'
  if index(split(&tags, ','), s:parent_folder_tag_pattern) != -1
    execute 'set tags-=' . s:parent_folder_tag_pattern
  else
    execute 'set tags+=' . s:parent_folder_tag_pattern
  endif
endfunction

function! vimrc#file_size(path)
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

function! vimrc#set_tab_size(size)
  let &l:tabstop     = a:size
  let &l:shiftwidth  = a:size
  let &l:softtabstop = a:size
endfunction

" Borrowed from gv.vim
function! vimrc#get_cursor_syntax()
  return synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction

" Find the cursor {{{
function! vimrc#blink_cursor_location()
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

function! vimrc#refresh_display()
  let $DISPLAY = split(systemlist('tmux show-environment DISPLAY')[0], '=')[1]
endfunction

" Delete inactive buffers
function! vimrc#delete_inactive_buffers(wipeout, bang)
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

" Trim whitespace
function! vimrc#trim_whitespace()
    let l:save = winsaveview()
    " FIXME vint: Use substitute() instead of :substitue
    %substitute/\s\+$//e
    call winrestview(l:save)
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

" Used in command-line mode
function! vimrc#trim_cmdline()
  let length = str2nr(input('length: ', '', 'expression'))
  return getcmdline()[0 : length - 1]
endfunction

" Used in command-line mode
function! vimrc#delete_whole_word()
  let cmd = getcmdline()
  let pos = getcmdpos() - 1 " getcmdpos() start from 1, but string index start from 0
  let meet_non_space = v:false
  for i in range(pos-2, 0, -1)
    if cmd[i] !=# ' '
      let meet_non_space = v:true
    endif

    if cmd[i] ==# ' ' && meet_non_space
      call setcmdpos(i+2)
      return cmd[0:i] . cmd[pos : ]
    endif
  endfor
  call setcmdpos(1)
  return cmd[pos : ]
endfunction

" Fold
" Borrowed from https://superuser.com/questions/990296/how-to-change-the-way-that-vim-displays-collapsed-folded-lines
function! vimrc#neat_fold_text()
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '| ' . printf('%10s', lines_count . ' lines') . ' |'
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction

function! vimrc#get_boundary_pattern(pattern)
  return '\<'.a:pattern.'\>'
endfunction

function! vimrc#set_scratch()
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
endfunction
