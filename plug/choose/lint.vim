" Choose Lint plugin
" syntastic, ale
if vimrc#plugin#check#has_async()
  call vimrc#plugin#disable_plugin('syntastic')
else
  call vimrc#plugin#disable_plugin('ale')
end

" Disable Lint if vim_mode is 'reader'
if vimrc#get_vim_mode() == 'reader'
  call vimrc#plugin#disable_plugin('ale')
  call vimrc#plugin#disable_plugin('syntastic')
end
