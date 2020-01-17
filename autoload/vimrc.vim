" Use directory junction in Windows to link $HOME."/.vim" to $VIM."/vimfiles"
let s:vimhome = $HOME . '/.vim'
let s:vim_mode = $VIM_MODE
let s:nvim_terminal = $NVIM_TERMINAL

function! vimrc#get_vimhome()
  return s:vimhome
endfunction

function! vimrc#get_vim_mode()
  return s:vim_mode
endfunction

function! vimrc#get_browser()
  if executable('firefox')
    return "firefox"
  elseif executable('chrome')
    return "chrome"
  else
    return ""
  endif
endfunction

function! vimrc#get_browser_search_command(keyword)
  if executable('firefox')
    return "firefox --search '" . a:keyword . "'"
  elseif executable('chrome')
    return "chrome '? " . a:keyword . "'"
  else
    return ""
  endif
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
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! vimrc#check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~ '\s'
endfunction "}}}

" Get rg current type option {{{
" TODO Not 100% accurate pattern, increase accuracy
let s:type_pattern_options = {
      \ 'c-family':   ['\v\.%(c|cpp|h|hpp)$',                 '-tc -tcpp'],
      \ 'config':     ['\v\.%(cfg|conf|config|ini)$',         '-tconfig'],
      \ 'css':        ['\v\.%(css|scss)$',                    '-tcss'],
      \ 'csv':        ['\.csv$',                              '-tcsv'],
      \ 'go':         ['\.go$',                               '-tgo'],
      \ 'html':       ['\.html$',                             '-thtml'],
      \ 'javascript': ['\v\.%(js|jsx)$',                      '-tjs'],
      \ 'json':       ['\.json$',                             '-tjson'],
      \ 'log':        ['\.log$',                              '-tlog'],
      \ 'lua':        ['\.lua$',                              '-tlua'],
      \ 'perl':       ['\v\.%(pl|pm|t)$',                      '-tperl'],
      \ 'python':     ['\.py$',                               '-tpy'],
      \ 'ruby':       ['\v%(\.rb|Gemfile|Rakefile)$',         '-truby'],
      \ 'rust':       ['\.rs$',                               '-trust'],
      \ 'shell':      ['\v\.%(bash|bashrc|sh|bash_aliases)$', "-g '{*.sh,.bashrc,.bash_*}'"],
      \ 'sql':        ['\.sql$',                              '-tsql'],
      \ 'txt':        ['\.txt$',                              '-ttxt'],
      \ 'typescript': ['\.ts$',                               "-g '*.ts'"],
      \ 'vim':        ['\v%(\.vim|\.vimrc|_vimrc)$',          "-g '{*.vim,_vimrc}'"],
      \ 'yaml':       ['\v\.%(yaml|yml)$',                    '-tyaml'],
      \ 'wiki':       ['\.wiki$',                             '-twiki'],
      \ }

" TODO Use ripgrep type list
" TODO Change to global function?
" TODO Detect non-file buffer
function! vimrc#rg_current_type_option() abort
  let filename = expand('%:t')

  for [type, value] in items(s:type_pattern_options)
    let pattern = value[0]
    let option = value[1]
    if filename =~ pattern
      return option
    endif
  endfor

  return ''
endfunction

function! vimrc#remap(old_key, new_key, mode)
  let mapping = maparg(a:old_key, a:mode)

  if !empty(mapping)
    execute a:mode . 'unmap ' . a:old_key
    execute a:mode . 'noremap ' . a:new_key . ' ' . mapping
  endif
endfunction
" }}}

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
  " Insert last tab
  let s:last_tabs = filter(s:last_tabs, 'v:val != ' . a:tabnr)
  call insert(s:last_tabs, a:tabnr, 0)

  " Truncate last_tabs when containing more than all tabs
  let count_tabcount = tabpagenr('$') - 1
  if count_tabcount > len(s:last_tabs)
    let s:last_tabs = s:last_tabs[0 : count_tabcount]
  endif
endfunction

function! vimrc#clear_invalid_last_tab()
  " Clear invalid last tab
  let new_last_tabs = []
  for last_tab in s:last_tabs
    if last_tab <= tabpagenr('$')
      call add(new_last_tabs, last_tab)
    endif
  endfor
  let s:last_tabs = new_last_tabs
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
    if buflisted(b) && !getbufvar(b,"&mod") && !has_key(visible_buffers, b)
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
    %s/\s\+$//e
    call winrestview(l:save)
endfunction

" Get char
function! vimrc#getchar() abort
  redraw | echo 'Press any key: '
  let c = getchar()
  while c ==# "\<CursorHold>"
    redraw | echo 'Press any key: '
    let c = getchar()
  endwhile
  redraw | echomsg printf('Raw: "%s" | Char: "%s"', c, nr2char(c))
endfunction

" Clear and redraw
function! vimrc#clear_and_redraw()
  call vimrc#lightline#refresh()
endfunction

" Execute and save command
function! vimrc#execute_and_save(command)
  call histadd("cmd", a:command)
  execute a:command
endfunction

" Clear winfixheight & winfixwidth for resizing window
function! vimrc#clear_winfixsize()
  setlocal nowinfixheight
  setlocal nowinfixwidth
endfunction

" Asynchronously browse URI
function! vimrc#async_browse(uri)
  " Currently only support neovim
  if !vimrc#plugin#check#has_rpc()
    echoerr "This version of vim does not have RPC!"
    return
  endif

  " Use xdg-open to open URI
  if !has("unix") || !executable("xdg-open")
    echoerr "No xdg-open found!"
    return
  endif

  call jobstart('xdg-open ' . a:uri, {})
endfunction

" Asynchronously open URL in browser
function! vimrc#async_open_url_in_browser(url)
  " Currently only support neovim
  if !vimrc#plugin#check#has_rpc()
    echoerr "This version of vim does not have RPC!"
    return
  endif

  let browser = vimrc#get_browser()
  if empty(browser)
    echoerr "No browser found!"
    return
  endif

  call jobstart(browser . ' ' . a:url, {})
endfunction

" Asynchronously search keyword in browser
function! vimrc#async_search_keyword_in_browser(keyword)
  " Currently only support neovim
  if !vimrc#plugin#check#has_rpc()
    echoerr "This version of vim does not have RPC!"
    return
  endif

  let search_command = vimrc#get_browser_search_command(a:keyword)
  if empty(search_command)
    echoerr "No browser found!"
    return
  endif

  call jobstart(search_command, {})
endfunction

" Used in command-line mode
function! vimrc#trim_cmdline()
  let length = str2nr(input('length: '))
  return getcmdline()[0 : length - 1]
endfunction
