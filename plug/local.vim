" Machine-Local config
let s:local_config = $HOME . '/.vim_local.vim'

if filereadable(s:local_config)
  execute 'source ' . s:local_config
endif
