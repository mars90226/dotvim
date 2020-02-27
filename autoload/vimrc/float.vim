" Functions
" Borrowed from vim-floaterm
" TODO Add border float window
function! vimrc#float#open(bufnr, width, height) abort
  let col = (&columns - a:width) / 2
  let row = (&lines - a:height) / 2
  let opts = {
    \ 'relative': 'editor',
    \ 'anchor': 'NW',
    \ 'row': row,
    \ 'col': col,
    \ 'width': a:width,
    \ 'height': a:height,
    \ 'style':'minimal'
    \ }
  let winid = nvim_open_win(a:bufnr, v:true, opts)
endfunction

function! vimrc#float#is_float(winid)
  try
    return !empty(nvim_win_get_config(a:winid).relative)
  catch /E5555: API call: Invalid window id:/
    return v:false
  endtry
endfunction
