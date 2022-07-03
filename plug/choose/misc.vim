if !has('python') && !has('python3')
  call vimrc#plugin#disable_plugin('vim-mundo')
endif

" Choose highlight plugin
" builtin vim.highlight

" Disable vim-gutentags when in nested neovim
if vimrc#plugin#check#nvim_terminal() ==# 'yes'
  call vimrc#plugin#disable_plugin('vim-gutentags')
endif

if !vimrc#plugin#check#has_browser()
  call vimrc#plugin#disable_plugin('open-browser.vim')
endif

" Choose indent line plugin
" indent-blankline.nvim

" Choose window switching plugin
" nvim-window

" Choose colorizer plugin
" nvim-colorizer.lua
