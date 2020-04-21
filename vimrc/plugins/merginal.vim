augroup merginal_settings
  autocmd!
  autocmd BufEnter Merginal:branchList:* call vimrc#merginal#settings()
augroup END
