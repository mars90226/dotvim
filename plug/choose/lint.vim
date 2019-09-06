" Choose Lint plugin
" syntastic, ale
if vimrc#plugin#check#has_async()
  call vimrc#plugin#disable_plugin('syntastic')
else
  call vimrc#plugin#disable_plugin('ale')
end
