" Statusline
" lualine.nvim
call vimrc#plugin#disable_plugins(['lualine.nvim'])
if has('nvim-0.5')
  call vimrc#plugin#enable_plugin('lualine.nvim')
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

" Which key
if !has('nvim-0.5')
  call vimrc#plugin#disable_plugin('which-key.nvim')
endif
