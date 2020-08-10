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

" TODO not working, disabled for now
" if !has('nvim-0.4')
"   call vimrc#plugin#disable_plugin('indent-blankline.nvim')
" endif
