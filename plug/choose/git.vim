" Choose between coc-git and vim-gitgutter
" If coc.nvim is enabled, then coc-git is enabled.
" if vimrc#plugin#is_enabled_plugin('coc.nvim')
"   call vimrc#plugin#disable_plugin('vim-gitgutter')
" endif

" Choose git-blame plugin
" coc-git, blamer.nvim
if vimrc#plugin#is_enabled_plugin('coc.nvim') || !has('nvim')
  call vimrc#plugin#disable_plugin('blamer.nvim')
endif
