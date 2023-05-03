if exists('current_compiler')
  finish
endif
let current_compiler = 'markdownlint'

setlocal makeprg=markdownlint
setlocal efm+=%f:%l:%c\ %m
