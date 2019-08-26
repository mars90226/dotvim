" Use directory junction in Windows to link $HOME."/.vim" to $VIM."/vimfiles"
let s:vimhome = $HOME . '/.vim'

function! vimrc#get_vimhome()
  return s:vimhome
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
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
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
  if &foldmethod == 'manual'
    setlocal foldmethod=syntax
  else
    setlocal foldmethod=manual
  endif
endfunction

" LastTab {{{
if !exists("s:last_tabs")
  let s:last_tabs = [1]
endif

function! vimrc#get_last_tabs()
  return s:last_tabs
endfunction

function! vimrc#last_tab(count)
  if a:count >= 0 && a:count < len(s:last_tabs)
    let tabnr = s:last_tabs[a:count]
  else
    let tabnr = s:last_tabs[-1]
  endif
  let last_tab_nr = tabpagenr('$')
  if tabnr > last_tab_nr
    echoerr 'Tab number ' . tabnr . ' is not exist!'
  else
    execute 'tabnext ' . tabnr
  endif
endfunction

function! vimrc#insert_last_tab(tabnr)
  let s:last_tabs = filter(s:last_tabs, 'v:val != ' . a:tabnr)
  call insert(s:last_tabs, a:tabnr, 0)
  let count_tabcount = tabpagenr('$') - 1
  if count_tabcount > len(s:last_tabs)
    let s:last_tabs = s:last_tabs[0 : count_tabcount]
  endif
endfunction
" }}}

" Zoom {{{
function! vimrc#zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction

function! vimrc#zoom_selected(selected)
  let filetype = &filetype
  tabnew
  call append(line('$'), split(a:selected, "\n"))
  1delete
  let &filetype = filetype
endfunction
" }}}

function! vimrc#toggle_parent_folder_tag()
  let s:parent_folder_tag_pattern = "./tags;"
  if index(split(&tags, ','), s:parent_folder_tag_pattern) != -1
    execute 'set tags-=' . s:parent_folder_tag_pattern
  else
    execute 'set tags+=' . s:parent_folder_tag_pattern
  endif
endfunction

function! vimrc#file_size(path)
  let path = expand(a:path)
  if isdirectory(path)
    echomsg path . " is directory!"
    return
  endif

  let file_size = getfsize(path)
  let gb = file_size / (1024 * 1024 * 1024)
  let mb = file_size / (1024 * 1024) % 1024
  let kb = file_size / (1024) % 1024
  let byte = file_size % 1024

  echomsg path . " size is "
        \ . (gb > 0 ? gb . "GB, " : "")
        \ . (mb > 0 ? mb . "MB, " : "")
        \ . (kb > 0 ? kb . "KB, " : "")
        \ . byte . "byte"
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
