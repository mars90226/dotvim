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

" Tabline
" barbar.nvim, or tabline bundled in statusline
" TODO: Disabled due to slowness
" TODO: Is fast in LunarVim, need to study why
call vimrc#plugin#disable_plugin('barbar.nvim')
" if vimrc#plugin#is_disabled_plugin('lualine.nvim')
"   call vimrc#plugin#disable_plugin('barbar.nvim')
" endif
