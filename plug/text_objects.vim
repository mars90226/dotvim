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

" vim-textobj-functioncall {{{
" Should already be bundled in vim-sandwich, but not work
" So, explicitly install this plugin
Plug 'machakann/vim-textobj-functioncall'

let g:textobj_functioncall_no_default_key_mappings = 1

xmap id <Plug>(textobj-functioncall-i)
omap id <Plug>(textobj-functioncall-i)
xmap ad <Plug>(textobj-functioncall-a)
omap ad <Plug>(textobj-functioncall-a)
" }}}

Plug 'michaeljsmith/vim-indent-object'
Plug 'glts/vim-textobj-comment'
