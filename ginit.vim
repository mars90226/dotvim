let g:guifont = 'DejaVu Sans Mono for Powerline'
let g:guifont_size = 'h16'
let g:guifont_character_set = 'cANSI'

let &guifont = g:guifont.':'.g:guifont_size.':'.g:guifont_character_set
if exists(':GuiFont') == 2
  " nvim-qt
  execute 'GuiFont '.g:guifont.':'.g:guifont_size
elseif exists('g:neovide')
  " neovide
endif

set winaltkeys=no

set lines=44
set columns=110
