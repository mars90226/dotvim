" Enable lsp-based highlighting
" vim-lsp-cxx-highlight for highlighting using lsp
call vimrc#plugin#disable_plugin('vim-lsp-cxx-highlight')
if vimrc#plugin#is_enabled_plugin('coc.nvim') || vimrc#plugin#is_enabled_plugin('nvim-lsp')
  call vimrc#plugin#enable_plugin('vim-lsp-cxx-highlight')
endif

" Enable language documentation generation
" vim-doge for generating documentation
call vimrc#plugin#disable_plugin('vim-doge')
if executable('node') && executable('npm')
  call vimrc#plugin#enable_plugin('vim-doge')
endif
