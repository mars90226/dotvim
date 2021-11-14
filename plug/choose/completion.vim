" Choose autocompletion plugin
" nvim-cmp, coc.nvim, completor.vim
" TODO: Add nvim-compe
call vimrc#plugin#disable_plugins(
      \ ['nvim-cmp', 'coc.nvim', 'completor.vim'])

if has('nvim') && has('nvim-0.5.1')
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
" TODO: Use nvim_exec_lua() instead. Currently it's in document but not exist.
" Check if `vim.lsp` is a table, not a nil
call vimrc#plugin#disable_plugin('nvim-lsp')
" if has('nvim') && trim(execute('lua print(type(vim.lsp) == type({}))')) ==# 'true'
" TODO: Currently, use approximate check for nvim-0.5.0 to improve performance
" Only enable nvim-lsp when using completor.vim
if has('nvim')
      \ && has('nvim-0.5.1')
      \ && vimrc#get_vim_mode() !=# 'reader'
      \ && vimrc#get_vim_mode() !=# 'gitcommit'
  call vimrc#plugin#enable_plugin('nvim-lsp')
endif
