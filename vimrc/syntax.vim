" syntax
" Check if syntax is on and only switch on syntax when it's off
" due to git-p preview loses highlight after `:syntax on`
if !exists('g:syntax_on')
  syntax on
endif
" lowering the value to improve performance on long line
set synmaxcol=1500  " default: 3000, 0: unlimited

" filetype
" NOTE: enable filetype.lua
let g:do_filetype_lua = 1
filetype on
filetype plugin on
filetype indent on

if !exists('g:loaded_color')
  let g:loaded_color = 1

  set background=dark

  if !exists('g:gui_oni')
    if exists('g:colorscheme')
      execute 'colorscheme '.g:colorscheme
    endif
  endif
endif

" TODO Need to test in Windows
if has('nvim-0.1.5')
  set termguicolors

  highlight default link NormalFloat Pmenu
endif

" highlighting strings inside C comments.
let c_comment_strings = 1
