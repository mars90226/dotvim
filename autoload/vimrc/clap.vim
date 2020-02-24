" Settings
function! vimrc#clap#settings()
  " FIXME Should make scroll full window, but does not work
  let &l:scroll *= 2
endfunction

" Mappings
function! vimrc#clap#mappings()
  " Press <Esc> to exit
  nnoremap <silent><buffer> <Esc> :call clap#handler#exit()<CR>
  inoremap <silent><buffer> <Esc> <Esc>:<C-U>call clap#handler#exit()<CR>

  " Use <C-O> to goto normal mode
  inoremap <silent><buffer> <C-O> <Esc>

  " Use <C-S> to open in split
  nnoremap <silent><buffer> <C-S> :<C-U>call clap#handler#try_open("ctrl-x")<CR>
  inoremap <silent><buffer> <C-S> <Esc>:<C-U>call clap#handler#try_open("ctrl-x")<CR>

  " Use <M-j>/<M-k> to scroll down/up
  nnoremap <silent><buffer> <M-j> :call clap#navigation#scroll('down')<CR>
  nnoremap <silent><buffer> <M-k> :call clap#navigation#scroll('up')<CR>
  inoremap <silent><buffer> <M-j> <C-R>=clap#navigation#scroll('down')<CR>
  inoremap <silent><buffer> <M-k> <C-R>=clap#navigation#scroll('up')<CR>
endfunction
