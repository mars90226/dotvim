" Choose finder plugin
" telescope.nvim

if !vimrc#plugin#check#has_linux_build_env()
  call vimrc#plugin#disable_plugin('telescope-fzf-native.nvim')
endif
