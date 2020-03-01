set hlsearch
set ignorecase
set incsearch
set smartcase

if has('nvim')
  set inccommand=split
endif

" For builtin 'incsearch'
cnoremap <C-J> <C-G>
cnoremap <C-K> <C-T>
