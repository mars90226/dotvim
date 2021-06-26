" nvim-treesitter for builtin neovim treesitter
" TODO: Use nvim_exec_lua() instead. Currently it's in document but not exist.
" Check if `vim.treesitter` is a table, not a nil
call vimrc#plugin#disable_plugin('nvim-treesitter')
" if has('nvim') && trim(execute('lua print(type(vim.treesitter) == type({}))')) ==# 'true'
" TODO: Currently, use approximate check for nvim-0.5.0 to improve performance
" Only enable nvim-treesitter on Linux build env
if has('nvim') && has('nvim-0.5.0') && vimrc#plugin#check#has_linux_build_env()
  call vimrc#plugin#enable_plugin('nvim-treesitter')
endif

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
