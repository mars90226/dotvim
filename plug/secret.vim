" Secret
set runtimepath+=$HOME/.vim_secret

let s:secret_config = $HOME . '/.vim_secret.vim'

if filereadable(s:secret_config)
  execute 'source ' . s:secret_config
endif
