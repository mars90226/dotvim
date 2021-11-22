" Choose autocompletion plugin
" nvim-cmp, coc.nvim, completor.vim
call vimrc#plugin#disable_plugins(
      \ ['nvim-cmp', 'coc.nvim', 'completor.vim'])

if has('nvim-0.5.1')
  call vimrc#plugin#enable_plugin('nvim-cmp')
elseif has('nvim')
      \ && executable('node')
      \ && executable('yarn')
      \ && vimrc#get_vim_mode() !=# 'reader'
      \ && vimrc#get_vim_mode() !=# 'gitcommit'
  call vimrc#plugin#enable_plugin('coc.nvim')
elseif has('python') || has('python3')
  call vimrc#plugin#enable_plugin('completor.vim')
endif

" nvim-lsp for builtin neovim lsp
call vimrc#plugin#disable_plugin('nvim-lsp')
if has('nvim-0.5.1')
      \ && vimrc#get_vim_mode() !=# 'reader'
      \ && vimrc#get_vim_mode() !=# 'gitcommit'
  call vimrc#plugin#enable_plugin('nvim-lsp')
endif

" Choose auto pairs plugin
" nvim-autopairs, auto-pairs
call vimrc#plugin#disable_plugins(['nvim-autopairs', 'auto-pairs'])
if has('nvim-0.5')
  call vimrc#plugin#enable_plugin('nvim-autopairs')
else
  call vimrc#plugin#enable_plugin('auto-pairs')
end
