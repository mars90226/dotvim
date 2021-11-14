" Choose terminal plugin
" vim-floaterm, neoterm
call vimrc#plugin#disable_plugins(
      \ ['vim-floaterm', 'neoterm'])

" Currently, always enable neoterm plugin
if has('nvim-0.4.4')
  call vimrc#plugin#enable_plugin('vim-floaterm')
  call vimrc#plugin#enable_plugin('neoterm')
else
  call vimrc#plugin#enable_plugin('neoterm')
endif
