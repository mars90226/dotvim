if !has('python') && !has('python3')
  call vimrc#plugin#disable_plugin('vim-mundo')
endif

if !exists('##TextYankPost')
  call vimrc#plugin#disable_plugin('vim-highlightedyank')
endif

" Disable vim-gutentags when in nested neovim
if has('nvim') && vimrc#plugin#check#nvim_terminal() ==# 'yes'
  call vimrc#plugin#disable_plugin('vim-gutentags')
endif

if !vimrc#plugin#check#has_browser()
  call vimrc#plugin#disable_plugin('open-browser.vim')
endif

if !has('nvim-0.5')
  call vimrc#plugin#disable_plugin('any-jump.nvim')
endif

if !has('nvim-0.4')
  call vimrc#plugin#disable_plugin('firenvim')
endif

if vimrc#plugin#check#python_version() <# '3.6'
  call vimrc#plugin#disable_plugin('aerojump.nvim')
endif

" Choose indent line plugin
" indent-blankline.nvim, indentLine
call vimrc#plugin#disable_plugins(['indent-blankline.nvim', 'indentLine'])
if has('nvim-0.5')
  call vimrc#plugin#enable_plugin('indent-blankline.nvim')
else
  call vimrc#plugin#enable_plugin('indentLine')
endif

if !has('nvim-0.5') || vimrc#plugin#is_disabled_plugin('nvim-web-devicons')
  call vimrc#plugin#disable_plugin('diffview.nvim')
endif

" Choose window switching plugin
" nvim-window, vim-choosewin
call vimrc#plugin#disable_plugins(['nvim-window', 'vim-choosewin'])
if has('nvim-0.5')
  call vimrc#plugin#enable_plugin('nvim-window')
else
  call vimrc#plugin#enable_plugin('vim-choosewin')
endif

" Choose colorizer plugin
" nvim-colorizer.lua, Colorizer
call vimrc#plugin#disable_plugins(['nvim-colorizer.lua', 'Colorizer'])
if has('nvim-0.4.0')
  call vimrc#plugin#enable_plugin('nvim-colorizer.lua')
else
  call vimrc#plugin#enable_plugin('Colorizer')
endif

if !(has('nvim-0.5') && vimrc#plugin#check#has_linux_build_env())
  call vimrc#plugin#disable_plugin('wilder.nvim')
endif
