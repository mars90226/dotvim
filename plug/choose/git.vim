" Choose between git-gutter plugin
" gitsigns.nvim
call vimrc#plugin#disable_plugins(['gitsigns.nvim'])
" TODO: Check for git version >= 2.13.0
if has('nvim-0.5')
  call vimrc#plugin#enable_plugin('gitsigns.nvim')
endif

" Choose git-blame plugin
" gitsigns.nvim
call vimrc#plugin#disable_plugins(['gitsigns.nvim'])
" TODO: Check for git version >= 2.13.0
if has('nvim-0.5')
  call vimrc#plugin#enable_plugin('gitsigns.nvim')
endif
