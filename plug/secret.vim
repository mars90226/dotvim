" Secret
let s:secret_config = $HOME . '/.vim_secret.vim'

if filereadable(s:secret_config)
  execute 'source ' . s:secret_config
endif
