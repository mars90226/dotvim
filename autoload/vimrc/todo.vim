function! vimrc#todo#make_todo() abort
  yank
  new
  norm p
  1,2delete 
  set ft=todo
  TodoFormat
endfunction
