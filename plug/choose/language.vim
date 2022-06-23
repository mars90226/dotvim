" Highlight {{{
" nvim-treesitter for builtin neovim treesitter
call vimrc#plugin#disable_plugin('nvim-treesitter')
if vimrc#get_vim_mode() !=# 'reader'
      \ && vimrc#get_vim_mode() !=# 'gitcommit'
      \ && vimrc#plugin#check#has_linux_build_env()
  call vimrc#plugin#enable_plugin('nvim-treesitter')
endif

" Enable lsp-based highlighting
" vim-lsp-cxx-highlight for highlighting using lsp
" Do not vim-lsp-cxx-highlight when nvim-treesitter as nvim-treesitter cannot
" recognize C/C++ macro semantics.
" }}}

" Lint {{{
" Choose Lint plugin
" null-ls.nvim
" Always enable nvim-lint

" Choose markdown-preview plugin
" vim-markdown-composer, markdown-preview.nvim
" TODO: Check if which plugin works
call vimrc#plugin#disable_plugins(['vim-markdown-composer', 'markdown-preview.nvim'])
if vimrc#plugin#check#has_cargo()
  call vimrc#plugin#enable_plugin('vim-markdown-composer')
else
  call vimrc#plugin#enable_plugin('markdown-preview.nvim')
endif

" Enable language documentation generation
" vim-doge for generating documentation
call vimrc#plugin#disable_plugin('vim-doge')
if executable('node') && executable('npm')
  call vimrc#plugin#enable_plugin('vim-doge')
endif

" Choose context plugin
" nvim-treesitter-context
call vimrc#plugin#disable_plugins(['nvim-treesitter-context'])
if vimrc#plugin#is_enabled_plugin('nvim-treesitter')
  call vimrc#plugin#enable_plugin('nvim-treesitter-context')
end

" Context in statusline
if vimrc#plugin#is_disabled_plugin('nvim-treesitter') || vimrc#plugin#is_enabled_plugin('nvim-navic')
  call vimrc#plugin#disable_plugin('nvim-gps')
endif
