" Choose file explorer
" Defx requires python 3.6.1+
if has("nvim") && vimrc#plugin#check#python_version() >= "3.6.1"
  call vimrc#plugin#disable_plugin("vimfiler")
else
  call vimrc#plugin#disable_plugin("defx")
endif
