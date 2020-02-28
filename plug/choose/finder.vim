if !(vimrc#plugin#check#has_async()
      \ && vimrc#plugin#check#has_rpc()
      \ && has("python3")
      \ && vimrc#plugin#check#python_version() >= "3.6.1")
  call vimrc#plugin#disable_plugin('denite.nvim')
end

" Currently, disable vim-clap for vanilla vim due to bufname() arguments error
" in yanks provider
if !has('nvim')
  call vimrc#plugin#disable_plugin('vim-clap')
endif
