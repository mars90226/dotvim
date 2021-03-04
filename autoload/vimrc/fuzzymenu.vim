" Functions
function! vimrc#fuzzymenu#try_add(name, def) abort
  silent let menu_item = fuzzymenu#Get(a:name)
  " Vim function return 0 if it has no return value
  " But, fuzzymenu#Get() normally return dictionary.
  " So the check for type is necessary.
  if type(menu_item) == type(0) && menu_item == 0
    call fuzzymenu#Add(a:name, a:def)
  endif
endfunction
