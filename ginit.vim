let g:guifont = 'DejaVu Sans Mono for Powerline'
let g:guifont_size = 'h12'
let g:guifont_character_set = 'cANSI'

if has('nvim')
  if exists(':GuiFont')
    " nvim-qt
    execute 'GuiFont '.g:guifont.':'.g:guifont_size
  endif
else
  let &guifont = g:guifont.':'.g:guifont_size.':'.g:guifont_character_set
end

set winaltkeys=no

set lines=44
set columns=110
