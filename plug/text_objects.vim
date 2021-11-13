" targets.vim {{{
Plug 'wellle/targets.vim'

" Reach targets
nmap <expr> ]r 'vin'.vimrc#getchar_string()."o\<Esc>"
nmap <expr> [r 'vil'.vimrc#getchar_string()."\<Esc>"
nmap <expr> ]R 'van'.vimrc#getchar_string()."o\<Esc>"
nmap <expr> [R 'val'.vimrc#getchar_string()."\<Esc>"
" }}}

Plug 'kana/vim-textobj-user'

" vim-textobj-function {{{
Plug 'kana/vim-textobj-function'

" Search in function
if vimrc#plugin#is_enabled_plugin('nvim-hlslens')
  map <Space>sF vaf<M-/>
else
  map <Space>sF :call vimrc#incsearch#clear_nohlsearch()<CR>vaf<M-/>
endif
" }}}

" textobj-word-column.vim {{{
Plug 'coderifous/textobj-word-column.vim'

let g:skip_default_textobj_word_column_mappings = 1

xnoremap <silent> au :<C-U>call TextObjWordBasedColumn("aw")<CR>
xnoremap <silent> aU :<C-U>call TextObjWordBasedColumn("aW")<CR>
xnoremap <silent> iu :<C-U>call TextObjWordBasedColumn("iw")<CR>
xnoremap <silent> iU :<C-U>call TextObjWordBasedColumn("iW")<CR>
onoremap <silent> au :call TextObjWordBasedColumn("aw")<CR>
onoremap <silent> aU :call TextObjWordBasedColumn("aW")<CR>
onoremap <silent> iu :call TextObjWordBasedColumn("iw")<CR>
onoremap <silent> iU :call TextObjWordBasedColumn("iW")<CR>
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
