let g:dirvish_sidebar_width = 35

nnoremap <F4> :call vimrc#dirvish#toggle()<CR>

augroup dirvish_mappings
  autocmd!
  autocmd FileType dirvish call vimrc#dirvish#mappings()
augroup END
