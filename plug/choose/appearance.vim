" Statusline
" lualine.nvim, lightline.vim, vim-airline
call vimrc#plugin#disable_plugins(['lualine.nvim', 'lightline.vim', 'vim-airline'])
" TODO: Disable lualine.nvim for now, the active tab is constantly messed up.
if has('nvim') && has('nvim-0.5.0')
  call vimrc#plugin#enable_plugin('lualine.nvim')
elseif vimrc#get_vim_mode() !=# 'full'
  call vimrc#plugin#enable_plugin('lightline.vim')
else
  call vimrc#plugin#enable_plugin('vim-airline')
endif

" Tabline
" tabby.nvim, luatab.nvim, tabline.nvim, barbar.nvim, or tabline bundled in statusline
call vimrc#plugin#disable_plugins(['tabby.nvim', 'luatab.nvim', 'tabline.nvim', 'barbar.nvim'])
if vimrc#plugin#is_enabled_plugin('lualine.nvim')
  call vimrc#plugin#enable_plugin('tabby.nvim')
  " TODO: Disable luatab.nvim due to not showing current tab when too many
  " tabs
  " call vimrc#plugin#enable_plugin('luatab.nvim')
  " TODO: Disable tabline.nvim due to lack of normal tabline
  " call vimrc#plugin#enable_plugin('tabline.nvim')
  " TODO: Disable barbar.nvim due to slowness
  " TODO: Is fast in LunarVim, need to study why
  " call vimrc#plugin#enable_plugin('barbar.nvim')
endif
