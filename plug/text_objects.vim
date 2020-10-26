Plug 'kana/vim-textobj-user'

" vim-textobj-function {{{
Plug 'kana/vim-textobj-function'

" Search in function
map <Space>sF :call vimrc#incsearch#clear_nohlsearch()<CR>vaf<M-/>
" }}}

" textobj-word-column.vim {{{
Plug 'coderifous/textobj-word-column.vim'

let g:skip_default_textobj_word_column_mappings = 1

xnoremap <silent> au :<C-u>call TextObjWordBasedColumn("aw")<cr>
xnoremap <silent> aU :<C-u>call TextObjWordBasedColumn("aW")<cr>
xnoremap <silent> iu :<C-u>call TextObjWordBasedColumn("iw")<cr>
xnoremap <silent> iU :<C-u>call TextObjWordBasedColumn("iW")<cr>
onoremap <silent> au :call TextObjWordBasedColumn("aw")<cr>
onoremap <silent> aU :call TextObjWordBasedColumn("aW")<cr>
onoremap <silent> iu :call TextObjWordBasedColumn("iw")<cr>
onoremap <silent> iU :call TextObjWordBasedColumn("iW")<cr>
" }}}

Plug 'michaeljsmith/vim-indent-object'
