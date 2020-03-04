" Functions
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
