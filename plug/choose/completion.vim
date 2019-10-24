" Choose autocompletion plugin {{{
" coc.nvim, deoplete.nvim, completor.vim, YouCompleteMe, supertab
call vimrc#plugin#disable_plugins(
      \ ['coc.nvim', 'deoplete.nvim', 'completor.vim', 'YouCompleteMe', 'supertab'])
if vimrc#plugin#check#has_async()
      \ && vimrc#plugin#check#has_rpc()
      \ && executable('node')
      \ && executable('yarn')
      \ && vimrc#get_vim_mode() != 'reader'
      \ && vimrc#get_vim_mode() != 'gitcommit'
  " coc.nvim
  call vimrc#plugin#enable_plugin('coc.nvim')
elseif vimrc#plugin#check#has_async()
      \ && vimrc#plugin#check#has_rpc()
      \ && has("python3")
      \ && vimrc#plugin#check#python_version() >= "3.6.1"
      \ && vimrc#get_vim_mode() != 'reader'
      \ && vimrc#get_vim_mode() != 'gitcommit'
  " deoplete.nvim
  call vimrc#plugin#enable_plugin('deoplete.nvim')
elseif has("python") || has("python3")
  " completor.vim
  call vimrc#plugin#enable_plugin('completor.vim')
elseif vimrc#plugin#check#has_linux_build_env()
  " YouCompleteMe
  call vimrc#plugin#enable_plugin('YouCompleteMe')
else
  " supertab
  call vimrc#plugin#enable_plugin('supertab')
endif
" }}}
