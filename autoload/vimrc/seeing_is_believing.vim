" Mappings
function! vimrc#seeing_is_believing#mappings() abort
  nmap <silent><buffer> <Leader>r<CR> <Plug>(seeing-is-believing-mark-and-run)
  xmap <silent><buffer> <Leader>r<CR> <Plug>(seeing-is-believing-mark-and-run)

  nmap <silent><buffer> <Leader>rm <Plug>(seeing-is-believing-mark)
  xmap <silent><buffer> <Leader>rm <Plug>(seeing-is-believing-mark)
  imap <silent><buffer> <Leader>rm <Plug>(seeing-is-believing-mark)

  nmap <silent><buffer> <Leader>rr <Plug>(seeing-is-believing-run)
  imap <silent><buffer> <Leader>rr <Plug>(seeing-is-believing-run)
endfunction
