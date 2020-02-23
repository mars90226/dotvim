" mappings
function! vimrc#clap#mappings()
  " Press <Esc> to exit
  nnoremap <silent><buffer> <Esc> :call clap#handler#exit()<CR>
  inoremap <silent><buffer> <Esc> <Esc>:<C-U>call clap#handler#exit()<CR>

  " Use <C-o> to goto normal mode
  inoremap <silent><buffer> <C-o> <Esc>

  " Use <C-s> to open in split
  nnoremap <silent><buffer> <C-s> :<C-U>call clap#handler#try_open("ctrl-x")<CR>
  inoremap <silent><buffer> <C-s> <Esc>:<C-U>call clap#handler#try_open("ctrl-x")<CR>
endfunction
