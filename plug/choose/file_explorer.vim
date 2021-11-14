" Choose file explorer
" defx.nvim, nvim-tree.lua, dirvish.vim
call vimrc#plugin#disable_plugins(
      \ ['defx.nvim', 'nvim-tree.lua', 'dirvish.vim'])
if has('nvim') && vimrc#plugin#check#python_version() >=# '3.6.1'
  call vimrc#plugin#enable_plugin('defx.nvim')
" elseif has('nvim')
"   call vimrc#plugin#enable_plugin('nvim-tree.lua')
else
  call vimrc#plugin#enable_plugin('dirvish.vim')
endif
