" Functions
" Escape backslash and space
function! vimrc#utility#commandline_escape_symbol(expr) abort
  let l:expr = a:expr
  let l:expr = substitute(l:expr, '\\', '\\\\', 'g')
  let l:expr = substitute(l:expr, ' ', '\\ ', 'g')

  return l:expr
endfunction

function! vimrc#utility#warn(message) abort
  echohl WarningMsg
  echomsg a:message
  echohl None
  return 0
endfunction

function! vimrc#utility#get_visual_selection() abort
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

function! vimrc#utility#quit_tab() abort
  try
    tabclose!
  catch /E784/ " Can't close last tab
    qall
  endtry
endfunction

function! vimrc#utility#window_equal() abort
  windo setlocal nowinfixheight nowinfixwidth
  1wincmd w
  wincmd =
endfunction

" vimrc#utility#execute_command() for executing command with query
function! vimrc#utility#execute_command(command, prompt, ...) abort
  let no_space = a:0 > 0 && type(a:1) == type(0) ? a:1 : 0
  " TODO input completion
  let query = input(a:prompt)
  if query !=# ''
    execute a:command . (no_space ? '' : ' ') . query
  else
    echo "\r"
    echohl WarningMsg
    echo 'Cancelled!'
    echohl None
  endif
endfunction

function! vimrc#utility#ask_execute(command, message) abort
  if vimrc#utility#ask(a:message)
    execute a:command
  endif
endfunction

" Borrowed from vim-plug
function! vimrc#utility#ask(message, ...) abort
  call inputsave()
  echohl WarningMsg
  let answer = input(a:message.(a:0 ? ' (y/N/a) ' : ' (y/N) '))
  echohl None
  call inputrestore()
  echo "\r"
  return (a:0 && answer =~? '^a') ? 2 : (answer =~? '^y') ? 1 : 0
endfunction

" sdcv
function! vimrc#utility#get_sdcv_command(...) abort
  let use_vimrc_float = a:0 > 0 && type(a:1) == type(v:true) ? a:1 : v:false
  return vimrc#terminal#get_open_command('sdcv', use_vimrc_float)
endfunction

" xdg-open
function! vimrc#utility#get_xdg_open(...) abort
  let use_vimrc_float = a:0 > 0 && type(a:1) == type(v:true) ? a:1 : v:false
  return vimrc#terminal#get_open_command('xdg-open', use_vimrc_float)
endfunction

" translate-shell
function! vimrc#utility#get_translate_shell_command(...) abort
  let use_vimrc_float = a:0 > 0 && type(a:1) == type(v:true) ? a:1 : v:false
  " Use bing as google is blocking request
  return vimrc#terminal#get_open_command('trans -e bing', use_vimrc_float)
endfunction

" DiffOrig
function! vimrc#utility#diff_original() abort
  vertical new
  set buftype=nofile
  read ++edit #
  0d_
  diffthis
  wincmd p
  diffthis
endfunction

function! vimrc#utility#file_size(path) abort
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

function! vimrc#utility#set_tab_size(size) abort
  let &l:tabstop     = a:size
  let &l:shiftwidth  = a:size
  let &l:softtabstop = a:size
endfunction

" Borrowed from gv.vim
function! vimrc#utility#get_cursor_syntax() abort
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" Find the cursor {{{
function! vimrc#utility#blink_cursor_location() abort
  let cursorline = &cursorline
  let cursorcolumn = &cursorcolumn

  let &cursorline = 1
  let &cursorcolumn = 1

  call timer_start(500, function('s:blink_cursor_location_callback', [cursorline, cursorcolumn]))
endfunction

function! s:blink_cursor_location_callback(cursorline, cursorcolumn, timer_id) abort
  let &cursorline = a:cursorline
  let &cursorcolumn = a:cursorcolumn
endfunction
" }}}

function! vimrc#utility#get_tmux_env(variable) abort
  " Currently only support environment variable that tmux will show as
  " following format: '{key}={value}'
  return split(systemlist('tmux show-environment '.a:variable)[0], '=')[1]
endfunction

function! vimrc#utility#refresh_env_from_tmux(variable) abort
  call setenv(a:variable, vimrc#utility#get_tmux_env(a:variable))
endfunction

function! vimrc#utility#refresh_display() abort
  " $TMUX_DISPLAY should be the viable $DISPLAY
  call vimrc#utility#refresh_env_from_tmux('TMUX_DISPLAY')
  call setenv('DISPLAY', $TMUX_DISPLAY)
endfunction

function! vimrc#utility#refresh_ssh_agent() abort
  call vimrc#utility#refresh_env_from_tmux('SSH_AUTH_SOCK')
  call vimrc#utility#refresh_env_from_tmux('SSH_AGENT_PID')
endfunction

function! vimrc#utility#refresh_ssh_client() abort
  let ssh_client_ip = split(vimrc#utility#get_tmux_env('SSH_CONNECTION'))[0]
  " TODO: Improve username setting
  let ssh_client_host = 'mars@'.ssh_client_ip

  call setenv('SSH_CLIENT_IP', ssh_client_ip)
  call setenv('SSH_CLIENT_HOST', ssh_client_host)
endfunction

" Trim whitespace
function! vimrc#utility#trim_whitespace() abort
  let l:save = winsaveview()
  let line_number = 1
  for line in getline(1, '$')
    call setline(line_number, substitute(line, '\s\+$', '', 'e'))
    let line_number += 1
  endfor
  call winrestview(l:save)
endfunction

function! vimrc#utility#set_scratch() abort
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
endfunction

" Ref: https://vi.stackexchange.com/a/6709
function! vimrc#utility#get_window_non_text_area_width() abort
  redir => l:a | execute 'sil sign place buffer='.bufnr('') | redir end
  let signlist = split(a, '\n')
  let non_window_text_area_width = &numberwidth + &foldcolumn + (len(signlist) > 2 ? 2 : 0)

  return non_window_text_area_width
endfunction

function! vimrc#utility#get_window_text_area_width() abort
  let window_text_area_width = winwidth(0) - vimrc#utility#get_window_non_text_area_width()

  return window_text_area_width
endfunction

function! vimrc#utility#resize_to_selected() abort
  call vimrc#utility#resize_height_to_selected()
  call vimrc#utility#resize_width_to_selected()
endfunction

function! vimrc#utility#reset_sidebar_size() abort
  if winnr() == 1
    " Left sidebar
    setlocal winfixwidth
    execute 'vertical resize '.g:left_sidebar_width
  elseif winnr() == winnr('$')
    " Right sidebar
    setlocal winfixwidth
    execute 'vertical resize '.g:right_sidebar_width
  endif
endfunction

function! vimrc#utility#resize_height_to_selected() abort
  let height = line("'>") - line("'<") + 1
  execute 'resize '.height
endfunction

function! vimrc#utility#resize_width_to_selected() abort
  let width = col("'>") - col("'<") + vimrc#utility#get_window_non_text_area_width()
  execute 'vertical resize '.width
endfunction

function! vimrc#utility#sort_copied_words() abort
  let copied = getreg('"')
  let sorted_copied = join(sort(split(copied)), ' ')
  return sorted_copied
endfunction

function! vimrc#utility#delete_buffers(Filter) abort
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let filtered_buffers = filter(buffers, a:Filter)

  if !empty(filtered_buffers)
    execute 'bdelete '.join(filtered_buffers, ' ')
  endif
endfunction

" ref: https://stackoverflow.com/a/39216373
function! vimrc#utility#get_script_id(script_name) abort
  let snr = trim(matchstr(matchstr(split(execute('scriptnames'), "\n"), a:script_name), '^\s*\d\+'))
  return snr
endfunction

function! vimrc#utility#get_script_function_name(snr, function_name) abort
  return '<SNR>'.a:snr.'_'.a:function_name
endfunction

function! vimrc#utility#get_script_function(snr, function_name) abort
  return function(vimrc#utility#get_script_function_name(a:snr, a:function_name))
endfunction

function! vimrc#utility#replace_sid_with_snr(snr, mapping) abort
  return substitute(a:mapping, '<SID>', '<SNR>'.a:snr.'_', '')
endfunction

function! vimrc#utility#get_tab_win_nr() abort
  return [tabpagenr(), winnr()]
endfunction

function! vimrc#utility#goto_tab_win_nr(tab_win_nr) abort
  let [tabnr, winnr] = a:tab_win_nr

  execute tabnr.'tabn'
  execute winnr.'wincmd w'
endfunction

function! vimrc#utility#execute_retain_tab_win(function) abort
  let origin_tab_win_nr = vimrc#utility#get_tab_win_nr()
  call a:function()
  call vimrc#utility#goto_tab_win_nr(origin_tab_win_nr)
endfunction

function! vimrc#utility#all_tab_win_execute(function) abort
  let origin_tab_win_nr = vimrc#utility#get_tab_win_nr()
  tabdo windo call a:function()
  call vimrc#utility#goto_tab_win_nr(origin_tab_win_nr)
endfunction

function! vimrc#utility#clear_registers(registers) abort
  for i in range(len(a:registers))
    call setreg(a:registers[i], '')
  endfor
endfunction
