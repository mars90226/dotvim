" Choose autocompletion plugin
" coc.nvim, deoplete.nvim, completor.vim, YouCompleteMe, supertab
call vimrc#plugin#disable_plugins(
      \ ['coc.nvim', 'deoplete.nvim', 'completor.vim', 'YouCompleteMe', 'supertab'])
if vimrc#plugin#check#has_async()
      \ && vimrc#plugin#check#has_rpc()
      \ && executable('node')
      \ && executable('yarn')
      \ && vimrc#get_vim_mode() !=# 'reader'
      \ && vimrc#get_vim_mode() !=# 'gitcommit'
  call vimrc#plugin#enable_plugin('coc.nvim')
elseif vimrc#plugin#check#has_async()
      \ && vimrc#plugin#check#has_rpc()
      \ && has('python3')
      \ && vimrc#plugin#check#python_version() >=# '3.6.1'
      \ && vimrc#get_vim_mode() !=# 'reader'
      \ && vimrc#get_vim_mode() !=# 'gitcommit'
  call vimrc#plugin#enable_plugin('deoplete.nvim')
elseif has('python') || has('python3')
  call vimrc#plugin#enable_plugin('completor.vim')
elseif vimrc#plugin#check#has_linux_build_env()
  call vimrc#plugin#enable_plugin('YouCompleteMe')
else
  call vimrc#plugin#enable_plugin('supertab')
endif

" nvim-lsp for builtin neovim lsp
" TODO: Use nvim_exec_lua() instead. Currently it's in document but not exist.
" Check if `vim.lsp` is a table, not a nil
call vimrc#plugin#disable_plugin('nvim-lsp')
if has('nvim') && trim(execute('lua print(type(vim.lsp) == type({}))')) ==# 'true'
  call vimrc#plugin#enable_plugin('nvim-lsp')
endif
