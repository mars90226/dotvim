" Choose file explorer
" Defx requires python 3.6.1+
call vimrc#plugin#disable_plugins(
      \ ['defx.nvim', 'nvim-tree.lua', 'vimfiler', 'dirvish.vim'])
if has('nvim') && vimrc#plugin#check#python_version() >=# '3.6.1'
  call vimrc#plugin#enable_plugin('defx.nvim')
else
  call vimrc#plugin#enable_plugin('dirvish.vim')
endif
" elseif has('nvim')
"   call vimrc#plugin#enable_plugin('nvim-tree.lua')
" else
"   call vimrc#plugin#enable_plugin('vimfiler')
" endif
