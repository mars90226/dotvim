" Lazy load
function! vimrc#lazy#unimpaired#load()
  call vimrc#lazy#unimpaired#settings()
  call plug#load('vim-unimpaired')
endfunction

" Settings
function! vimrc#lazy#unimpaired#settings()
  " Ignore [a, ]a, [A, ]A for ale
  let g:nremap = {"[a": "", "]a": "", "[A": "", "]A": ""}

  nmap \[u  <Plug>unimpaired_url_encode
  nmap \[uu <Plug>unimpaired_line_url_encode
  nmap \]u  <Plug>unimpaired_url_decode
  nmap \]uu <Plug>unimpaired_line_url_decode

  nnoremap coc :set termguicolors!<CR>
  nnoremap coe :set expandtab!<CR>
  nnoremap com :set modifiable!<CR>
  nnoremap coo :set readonly!<CR>
  nnoremap cop :set paste!<CR>
endfunction
