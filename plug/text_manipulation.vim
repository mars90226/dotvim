" EasyAlign {{{
Plug 'junegunn/vim-easy-align'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

xmap <Space>ga <Plug>(LiveEasyAlign)
" }}}

" auto-pairs {{{
Plug 'jiangmiao/auto-pairs'

call vimrc#source('vimrc/plugins/auto_pairs.vim')
" }}}

" eraseSubword {{{
Plug 'vim-scripts/eraseSubword'

let g:EraseSubword_insertMap = '<C-B>'
" }}}

" tcomment_vim {{{
Plug 'tomtom/tcomment_vim', { 'on': [] }

call vimrc#lazy#lazy_load('tcomment')
" }}}

" vim-subversive {{{
Plug 'svermeulen/vim-subversive'

nmap ss <Plug>(SubversiveSubstitute)
nmap sS <Plug>(SubversiveSubstituteLine)
nmap sl <Plug>(SubversiveSubstituteToEndOfLine)

nmap <Leader>s <Plug>(SubversiveSubstituteRange)
xmap <Leader>s <Plug>(SubversiveSubstituteRange)
nmap <Leader>ss <Plug>(SubversiveSubstituteWordRange)

nmap <Leader>cr <Plug>(SubversiveSubstituteRangeConfirm)
xmap <Leader>cr <Plug>(SubversiveSubstituteRangeConfirm)
nmap <Leader>crr <Plug>(SubversiveSubstituteWordRangeConfirm)

nmap <Leader><Leader>s <Plug>(SubversiveSubvertRange)
xmap <Leader><Leader>s <Plug>(SubversiveSubvertRange)
nmap <Leader><Leader>ss <Plug>(SubversiveSubvertWordRange)

" ie = inner entire buffer
onoremap ie :exec "normal! ggVG"<CR>

" iv = current viewable text in the buffer
onoremap iv :exec "normal! HVL"<CR>

" Quick substitute from system clipboard
nmap =ss "+<Plug>(SubversiveSubstitute)
nmap =sS "+<Plug>(SubversiveSubstituteLine)
nmap =sl "+<Plug>(SubversiveSubstituteToEndOfLine)
" }}}

" vim-sandwich {{{
Plug 'machakann/vim-sandwich'

xmap iss <Plug>(textobj-sandwich-auto-i)
xmap ass <Plug>(textobj-sandwich-auto-a)
omap iss <Plug>(textobj-sandwich-auto-i)
omap ass <Plug>(textobj-sandwich-auto-a)

xmap il <Plug>(textobj-sandwich-literal-query-i)
xmap al <Plug>(textobj-sandwich-literal-query-a)
omap il <Plug>(textobj-sandwich-literal-query-i)
omap al <Plug>(textobj-sandwich-literal-query-a)
" }}}

Plug 'editorconfig/editorconfig-vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-repeat'
