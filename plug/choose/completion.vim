" Choose autocompletion plugin
" nvim-cmp

" nvim-lsp for builtin neovim lsp
" builtin neovim lsp should be fast enough to be used in light vim mode

" Choose auto pairs plugin
" nvim-autopairs

" Context in winbar
call vimrc#plugin#disable_plugin('nvim-navic')
if has('nvim-0.8') && vimrc#plugin#is_enabled_plugin('nvim-lsp') 
  call vimrc#plugin#enable_plugin('nvim-navic')
endif

" Context in statusbar
if vimrc#plugin#is_disabled_plugin('nvim-lsp') || vimrc#plugin#is_enabled_plugin('nvim-navic')
  call vimrc#plugin#disable_plugin('lsp-status')
endif
