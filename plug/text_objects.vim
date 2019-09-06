Plug 'kana/vim-textobj-user'

" vim-textobj-function {{{
Plug 'kana/vim-textobj-function'

" Search in function
map <Space>sF :call vimrc#incsearch#clear_nohlsearch()<CR>vaf<M-/>
" }}}

Plug 'michaeljsmith/vim-indent-object'
Plug 'coderifous/textobj-word-column.vim'
