Plug 'kana/vim-textobj-user'

" vim-textobj-function {{{
Plug 'kana/vim-textobj-function'

" Search in function
map <Space>sF :call vimrc#incsearch#clear_nohlsearch()<CR>vaf<M-/>
" }}}

" textobj-word-column.vim {{{
Plug 'coderifous/textobj-word-column.vim'

let g:skip_default_textobj_word_column_mappings = 1

xnoremap <silent> an :<C-u>call TextObjWordBasedColumn("aw")<cr>
xnoremap <silent> aN :<C-u>call TextObjWordBasedColumn("aW")<cr>
xnoremap <silent> in :<C-u>call TextObjWordBasedColumn("iw")<cr>
xnoremap <silent> iN :<C-u>call TextObjWordBasedColumn("iW")<cr>
onoremap <silent> an :call TextObjWordBasedColumn("aw")<cr>
onoremap <silent> aN :call TextObjWordBasedColumn("aW")<cr>
onoremap <silent> in :call TextObjWordBasedColumn("iw")<cr>
onoremap <silent> iN :call TextObjWordBasedColumn("iW")<cr>
" }}}

Plug 'michaeljsmith/vim-indent-object'
