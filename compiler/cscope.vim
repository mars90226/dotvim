if exists('current_compiler')
  finish
endif
let current_compiler = 'cscope'

let s:cpo_save = &cpoptions
set cpoptions-=C

" FIXME: Required by vim-dispatch, but not work due to space and symbols
" Need to use :Dispatch -compiler=cscope to force vim-dispatch to use cscope
" compiler
" CompilerSet makeprg=cscope
let &l:makeprg = "rg -g '*.{c,cpp,h,hpp}' --files > cscope.files && cscope -Rbq -i cscope.files"

let &cpoptions = s:cpo_save
unlet s:cpo_save
