" Choose file explorer
" defx.nvim
call vimrc#plugin#disable_plugins(['defx.nvim'])
if vimrc#plugin#check#python_version() >=# '3.6.1'
  call vimrc#plugin#enable_plugin('defx.nvim')
endif

" NOTE: Always use neo-tree.nvim
" TODO: Remove others
