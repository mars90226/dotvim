if !has('python')
  call vimrc#plugin#disable_plugin('github-issues.vim')
endif

if v:version < 730 || !(has('python') || has('python3'))
  call vimrc#plugin#disable_plugin('vim-mundo')
endif

" Choose markdown-preview plugin
if has('nvim')
  call vimrc#plugin#disable_plugin('markdown-preview.vim')
else
  call vimrc#plugin#disable_plugin('markdown-preview.nvim')
endif

" neovim master will crash for unknown reason, checkout b996205969d5c56e9110158e48cef559e9de0969
" ref: https://github.com/neovim/neovim/issues/12387
if !exists('##TextYankPost')
  call vimrc#plugin#disable_plugin('vim-highlightedyank')
endif

if !(has('job') || (has('nvim') && exists('*jobwait'))) || (has('nvim') && vimrc#plugin#check#nvim_terminal() ==# 'yes')
  call vimrc#plugin#disable_plugin('vim-gutentags')
endif

if !vimrc#plugin#check#has_browser()
  call vimrc#plugin#disable_plugin('open-browser.vim')
endif

if !has('nvim-0.4') && !exists('*popup_menu')
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
" allow virt_text overlay at any column in 'NVIM v0.5.0-dev+1103-g7bcac75f3'
if has('nvim-0.5') && vimrc#plugin#check#nvim_patch_version() >= 1103
  call vimrc#plugin#enable_plugin('indent-blankline.nvim')
else
  call vimrc#plugin#enable_plugin('indentLine')
endif

if !has('nvim-0.5')
  call vimrc#plugin#disable_plugin('nvim-web-devicons')
endif

if !has('nvim-0.5') || vimrc#plugin#is_disabled_plugin('nvim-web-devicons')
  call vimrc#plugin#disable_plugin('diffview.nvim')
endif
