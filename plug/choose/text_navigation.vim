if !has('nvim-0.5')
  call vimrc#plugin#disable_plugin('hop.nvim')
endif

if !has('nvim-0.5')
  call vimrc#plugin#disable_plugin('lightspeed.nvim')
endif

" search utility
" nvim-hlslens
call vimrc#plugin#disable_plugins(['nvim-hlslens'])
if has('nvim-0.5')
  call vimrc#plugin#enable_plugin('nvim-hlslens')
endif
