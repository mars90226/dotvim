" Choose between git-gutter plugin
" gitsigns.nvim, vim-signify, coc-git
call vimrc#plugin#disable_plugins(['gitsigns.nvim', 'vim-signify', 'coc-git-gutter'])
" Currently, always disable coc-git-gutter
" TODO: Check for git version >= 2.13.0
if has('nvim')
  call vimrc#plugin#enable_plugin('gitsigns.nvim')
else 
  call vimrc#plugin#enable_plugin('vim-signify')
endif

" Choose git-blame plugin
" gitsigns.nvim, coc-git, blamer.nvim
call vimrc#plugin#disable_plugins(['gitsigns.nvim', 'coc-git-blamer', 'blamer.nvim'])
" TODO: Check for git version >= 2.13.0
if has('nvim')
  call vimrc#plugin#enable_plugin('gitsigns.nvim')
elseif vimrc#plugin#is_enabled_plugin('coc.nvim')
  call vimrc#plugin#enable_plugin('coc-git-blamer')
else
  call vimrc#plugin#enable_plugin('blamer.nvim')
endif
