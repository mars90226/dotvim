" Statusline
" lualine.nvim, lightline.vim, vim-airline
call vimrc#plugin#disable_plugins(['lualine.nvim', 'lightline.vim', 'vim-airline'])
if has('nvim') && has('nvim-0.5.0')
  call vimrc#plugin#enable_plugin('lualine.nvim')
elseif vimrc#get_vim_mode() !=# 'full'
  call vimrc#plugin#enable_plugin('lightline.vim')
else
  call vimrc#plugin#enable_plugin('vim-airline')
endif
