" Use directory junction in Windows to link $HOME."/.vim" to $VIM."/vimfiles"
let s:vimhome = $HOME . '/.vim'

function! vimrc#get_vimhome()
  return s:vimhome
endfunction
