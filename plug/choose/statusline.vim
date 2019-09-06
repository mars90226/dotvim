" airline, lightline
if vimrc#get_vim_mode() == 'full'
  call vimrc#plugin#disable_plugin('lightline.vim')
else
  call vimrc#plugin#disable_plugin('vim-airline')
endif
