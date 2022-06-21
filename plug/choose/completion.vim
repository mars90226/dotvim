" Choose autocompletion plugin
" nvim-cmp
call vimrc#plugin#disable_plugins(['nvim-cmp'])

if has('nvim-0.5.1')
  call vimrc#plugin#enable_plugin('nvim-cmp')
endif

" nvim-lsp for builtin neovim lsp
" builtin neovim lsp should be fast enough to be used in light vim mode
call vimrc#plugin#disable_plugin('nvim-lsp')
if has('nvim-0.5.1')
  call vimrc#plugin#enable_plugin('nvim-lsp')
endif

" Choose auto pairs plugin
" nvim-autopairs
call vimrc#plugin#disable_plugins(['nvim-autopairs'])
if has('nvim-0.5')
  call vimrc#plugin#enable_plugin('nvim-autopairs')
end

" Context in winbar
call vimrc#plugin#disable_plugin('nvim-navic')
if has('nvim-0.8') && vimrc#plugin#is_enabled_plugin('nvim-lsp') 
  call vimrc#plugin#enable_plugin('nvim-navic')
endif

" Context in statusbar
if vimrc#plugin#is_disabled_plugin('nvim-lsp') || vimrc#plugin#is_enabled_plugin('nvim-navic')
  call vimrc#plugin#disable_plugin('lsp-status')
endif
