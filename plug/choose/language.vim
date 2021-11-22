" Highlight {{{
" nvim-treesitter for builtin neovim treesitter
call vimrc#plugin#disable_plugin('nvim-treesitter')
if has('nvim-0.5.1')
      \ && vimrc#get_vim_mode() !=# 'reader'
      \ && vimrc#get_vim_mode() !=# 'gitcommit'
      \ && vimrc#plugin#check#has_linux_build_env()
  call vimrc#plugin#enable_plugin('nvim-treesitter')
endif

" Enable lsp-based highlighting
" vim-lsp-cxx-highlight for highlighting using lsp
" Do not vim-lsp-cxx-highlight when nvim-treesitter as nvim-treesitter cannot
" recognize C/C++ macro semantics.
call vimrc#plugin#disable_plugin('vim-lsp-cxx-highlight')
if vimrc#plugin#is_enabled_plugin('coc.nvim') || vimrc#plugin#is_enabled_plugin('nvim-lsp')
  call vimrc#plugin#enable_plugin('vim-lsp-cxx-highlight')
endif
" }}}

" Lint {{{
" Choose Lint plugin
" null-ls.nvim, ale
call vimrc#plugin#disable_plugins(['null-ls.nvim', 'ale'])
if has('nvim-0.5')
  call vimrc#plugin#enable_plugin('null-ls.nvim')
else
  call vimrc#plugin#enable_plugin('ale')
end

" Disable Lint if vim_mode is 'reader'
if vimrc#get_vim_mode() ==# 'reader' || vimrc#get_vim_mode() ==# 'gitcommit'
  call vimrc#plugin#disable_plugin('ale')
end
" }}}

" Choose markdown-preview plugin
" vim-markdown-composer, markdown-preview.nvim, markdown-preview.vim
call vimrc#plugin#disable_plugins(['vim-markdown-composer', 'markdown-preview.nvim', 'markdown-preview.vim'])
if vimrc#plugin#check#has_cargo()
  call vimrc#plugin#enable_plugin('vim-markdown-composer')
elseif has('nvim')
  call vimrc#plugin#enable_plugin('markdown-preview.nvim')
else
  call vimrc#plugin#enable_plugin('markdown-preview.vim')
endif

" Enable language documentation generation
" vim-doge for generating documentation
call vimrc#plugin#disable_plugin('vim-doge')
if executable('node') && executable('npm')
  call vimrc#plugin#enable_plugin('vim-doge')
endif

" Choose context plugin
" nvim-treesitter-context, context.vim
call vimrc#plugin#disable_plugins(['nvim-treesitter-context', 'context.vim'])
if vimrc#plugin#is_enabled_plugin('nvim-treesitter')
  call vimrc#plugin#enable_plugin('nvim-treesitter-context')
else
  call vimrc#plugin#enable_plugin('context.vim')
end

" Context in statusline
if vimrc#plugin#is_disabled_plugin('nvim-treesitter')
  call vimrc#plugin#disable_plugin('nvim-gps')
endif
