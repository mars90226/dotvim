nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gc :Gcommit<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>ge :Gedit<CR>
nnoremap <silent> <Leader>gE :Gedit<space>
nnoremap <silent> <Leader>gl :Glog<CR>
nnoremap <silent> <Leader>gL :Glog -- %<CR>
nnoremap <silent> <Leader>gr :Gread<CR>
nnoremap <silent> <Leader>gR :Gread<space>
nnoremap <silent> <Leader>gw :Gwrite<CR>
nnoremap <silent> <Leader>gW :Gwrite!<CR>
nnoremap <silent> <Leader>gq :Gwq<CR>
nnoremap <silent> <Leader>gQ :Gwq!<CR>
nnoremap <silent> <Leader>gM :Merginal<CR>

nnoremap <silent> <Leader>g` :call vimrc#fugitive#review_last_commit()<CR>

augroup fugitiveSettings
  autocmd!
  autocmd FileType gitcommit setlocal nolist
  autocmd FileType fugitive call vimrc#fugitive#mappings()
  autocmd FileType git      call vimrc#fugitive#git_mappings()
  autocmd BufReadPost fugitive://* setlocal bufhidden=delete
augroup END

let g:fugitive_gitlab_domains = ['https://git.synology.com']

" Borrowed and modified from vim-fugitive s:Dispatch
command! -nargs=* GitDispatch call vimrc#fugitive#git_dispatch(<q-args>)
