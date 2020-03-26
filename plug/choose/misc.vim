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

if !exists('##TextYankPost')
  call vimrc#plugin#disable_plugin('vim-highlightedyank')
endif

if !(has('job') || (has('nvim') && exists('*jobwait'))) || vimrc#plugin#check#nvim_terminal() ==# 'yes'
  call vimrc#plugin#disable_plugin('vim-gutentags')
endif

if !vimrc#plugin#check#has_browser()
  call vimrc#plugin#disable_plugin('open-browser.vim')
endif

if !has('nvim-0.4') && !exists('*popup_menu')
  call vimrc#plugin#disable_plugin('any-jump.nvim')
endif
