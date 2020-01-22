nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gD :Gdiff!<CR>
nnoremap <silent> <Leader>gc :Gcommit<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>ge :Gedit<CR>
nnoremap <silent> <Leader>gE :Gedit<space>
nnoremap <silent> <Leader>gl :Glog<CR>
nnoremap <silent> <Leader>gL :0Glog<CR>
xnoremap <silent> <Leader>gl :<C-U>execute 'Git log -L '.getpos("'<")[1].','.getpos("'>")[1].':%'<CR>
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
  autocmd FileType gitcommit       call vimrc#fugitive#gitcommit_settings()
  autocmd FileType fugitive        call vimrc#fugitive#mappings()
  autocmd FileType git             call vimrc#fugitive#git_mappings()
  autocmd FileType fugitiveblame   call vimrc#fugitive#blame_mappings()
  autocmd BufReadPost fugitive://* call vimrc#fugitive#fugitive_buffer_settings()
augroup END

let g:fugitive_gitlab_domains = []
let g:fugitive_gitlab_domains += g:fugitive_gitlab_secret_domains

" Borrowed and modified from vim-fugitive s:Dispatch
command! -nargs=* GitDispatch call vimrc#fugitive#git_dispatch(<q-args>)
