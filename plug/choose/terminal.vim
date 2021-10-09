" Choose terminal plugin
" vim-floaterm, deol.nvim, neoterm
call vimrc#plugin#disable_plugins(
      \ ['vim-floaterm', 'deol.nvim', 'neoterm'])

" Currently, always enable neoterm plugin
if has('nvim') && vimrc#plugin#check#has_floating_window()
  call vimrc#plugin#enable_plugin('vim-floaterm')
  call vimrc#plugin#enable_plugin('neoterm')
elseif has('nvim')
  call vimrc#plugin#enable_plugin('deol.nvim')
  call vimrc#plugin#enable_plugin('neoterm')
else
  call vimrc#plugin#enable_plugin('neoterm')
endif
