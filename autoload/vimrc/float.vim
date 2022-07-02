" Functions
let s:float_default_width_ratio = 0.9
let s:float_default_height_ratio = 0.8
let s:float_default_width = float2nr(&columns * s:float_default_width_ratio)
let s:float_default_height = float2nr(&lines * s:float_default_height_ratio)
let s:float_default_ratio = [s:float_default_width_ratio, s:float_default_height_ratio]
let s:float_default_size = [s:float_default_width, s:float_default_height]

function! vimrc#float#get_default_size() abort
  return s:float_default_size
endfunction

function! vimrc#float#get_default_ratio() abort
  return s:float_default_ratio
endfunction

function! vimrc#float#calculate_pos(width, height) abort
  let col = (&columns - a:width) / 2
  let row = (&lines - a:height) / 2
  return [col, row]
endfunction

function! vimrc#float#calculate_pos_from_ratio(width_ratio, height_ratio) abort
  let col_ratio = (1 - a:width_ratio) / 2
  let row_ratio = (1 - a:height_ratio) / 2
  let col = float2nr(&columns * col_ratio)
  let row = float2nr(&lines * row_ratio)
  return [col, row]
endfunction

" Borrowed from vim-floaterm
" TODO Add border float window
function! vimrc#float#open(bufnr, width, height, ...) abort
  let default_options = { 'listed': v:false, 'scratch': v:true }
  let options = a:0 >= 1 && type(a:0) == type({}) ? extend(default_options, a:1) : default_options
  let bufnr = a:bufnr >= 0 ? a:bufnr : nvim_create_buf(options.listed, options.scratch)

  let [col, row] = vimrc#float#calculate_pos(a:width, a:height)
  let opts = {
    \ 'relative': 'editor',
    \ 'anchor': 'NW',
    \ 'row': row,
    \ 'col': col,
    \ 'width': a:width,
    \ 'height': a:height,
    \ 'style':'minimal',
    \ 'border': 'rounded'
    \ }
  " FIXME noautocmd to prevent terminal startinsert WinEnter autocmd
  " This may be a bug that nvim_open_win() trigger WinEnter autocmd and <afile>
  " is not buffer name in new window but in original window
  noautocmd let winid = nvim_open_win(bufnr, v:true, opts)

  call nvim_win_set_var(winid, 'vimrc_float', v:true)
  return [bufnr, winid]
endfunction

function! vimrc#float#is_float(winid) abort
  try
    return !empty(nvim_win_get_config(a:winid).relative) && getwinvar(a:winid, 'vimrc_float', v:false)
  catch /E5555: API call: Invalid window id:/
    return v:false
  endtry
endfunction
function! vimrc#float#is_float_winnr(winnr) abort
  return vimrc#float#is_float(win_getid(a:winnr))
endfunction

" Functions
" Borrowed from https://github.com/voldikss/vim-floaterm/blob/master/autoload/floaterm.vim
function! vimrc#float#new(...) abort
  call vimrc#float#hide()

  let command = a:0 >= 1 && type(a:1) == type('') ? a:1 : ''
  let prior_float_open = a:0 >= 2 && type(a:2) == type(0) ? a:2 : 0

  let bufnr = -1
  if prior_float_open && !empty(command)
    let command = a:1
    execute command
    let bufnr = bufnr()
    close
  endif

  let [width, height] = vimrc#float#get_default_size()
  let [bufnr, winid] = vimrc#float#open(bufnr, width, height)

  if !prior_float_open && !empty(command)
    let command = a:1
    execute command
    " bufnr may changed after executing command
    let bufnr = bufnr()
  endif

  call vimrc#float#buflist#add(bufnr)
  return bufnr
endfunction

" Find **one** floaterm window
function! s:find_term_win() abort
  let found_winnr = 0
  for winnr in range(1, winnr('$'))
    if vimrc#float#is_float_winnr(winnr)
      let found_winnr = winnr
      break
    endif
  endfor
  return found_winnr
endfunction

function! vimrc#float#hide() abort
  while v:true
    let found_winnr = s:find_term_win()
    if found_winnr > 0
      execute found_winnr . 'hide'
    else
      break
    endif
  endwhile
endfunction

function! vimrc#float#next()  abort
  call vimrc#float#hide()
  let next_bufnr = vimrc#float#buflist#find_next()
  if next_bufnr == -1
    echo 'No more vimrc_floats'
  else
    let [width, height] = vimrc#float#get_default_size()
    call vimrc#float#open(next_bufnr, width, height)
  endif
endfunction

function! vimrc#float#prev()  abort
  call vimrc#float#hide()
  let prev_bufnr = vimrc#float#buflist#find_prev()
  if prev_bufnr == -1
    echo 'No more vimrc_floats'
  else
    let [width, height] = vimrc#float#get_default_size()
    call vimrc#float#open(prev_bufnr, width, height)
  endif
endfunction

function! vimrc#float#curr(...) abort
  let curr_bufnr = vimrc#float#buflist#find_curr()
  if curr_bufnr == -1
    let command = a:0 >= 1 ? a:1 : ''
    let prior_float_open = a:0 >= 2 ? a:2 : 0
    let curr_bufnr = vimrc#float#new(command, prior_float_open)
  else
    let [width, height] = vimrc#float#get_default_size()
    call vimrc#float#open(curr_bufnr, width, height)
  endif
  return curr_bufnr
endfunction

function! vimrc#float#toggle(...)  abort
  if vimrc#float#is_float(win_getid())
    hide
  else
    let found_winnr = s:find_term_win()
    if found_winnr > 0
      execute found_winnr . 'wincmd w'
      if has('nvim')
        startinsert
      elseif mode() ==# 'n'
        normal! i
      endif
    else
      let command = a:0 >= 1 ? a:1 : ''
      let prior_float_open = a:0 >= 2 ? a:2 : 0
      call vimrc#float#curr(command, prior_float_open)
    endif
  endif
endfunction

function! vimrc#float#remove() abort
  return vimrc#float#buflist#remove_curr()
endfunction
