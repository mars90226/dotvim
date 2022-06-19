" TODO: Remove denite.nvim
if !(has('nvim') && has('python3') && vimrc#plugin#check#python_version() >=# '3.6.1')
  call vimrc#plugin#disable_plugin('denite.nvim')
end

if !has('nvim-0.5')
  call vimrc#plugin#disable_plugin('telescope.nvim')
endif

if vimrc#plugin#is_disabled_plugin('telescope.nvim') || !vimrc#plugin#check#has_linux_build_env()
  call vimrc#plugin#disable_plugin('telescope-fzf-native.nvim')
endif
