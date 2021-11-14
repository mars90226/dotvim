" Statusline
" lualine.nvim, lightline.vim
call vimrc#plugin#disable_plugins(['lualine.nvim', 'lightline.vim'])
" TODO: Disable lualine.nvim for now, the active tab is constantly messed up.
if has('nvim') && has('nvim-0.5.0')
  call vimrc#plugin#enable_plugin('lualine.nvim')
else
  call vimrc#plugin#enable_plugin('lightline.vim')
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

" Devicons
" nvim-web-devicons, vim-devicons
call vimrc#plugin#disable_plugins(['nvim-web-devicons'])
if has('nvim-0.5')
  call vimrc#plugin#enable_plugin('nvim-web-devicons')
endif
