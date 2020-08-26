" EasyAlign {{{
Plug 'junegunn/vim-easy-align'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

nmap <Leader>ga <Plug>(LiveEasyAlign)
xmap <Leader>ga <Plug>(LiveEasyAlign)
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

let g:tcomment_textobject_inlinecomment = 'ilc'
" }}}

" vim-subversive {{{
Plug 'svermeulen/vim-subversive'

nmap ss <Plug>(SubversiveSubstitute)
nmap sS <Plug>(SubversiveSubstituteLine)
nmap sl <Plug>(SubversiveSubstituteToEndOfLine)

nmap <Leader>s <Plug>(SubversiveSubstituteRange)
xmap <Leader>s <Plug>(SubversiveSubstituteRange)
nmap <Leader>ss <Plug>(SubversiveSubstituteWordRange)

nmap scr <Plug>(SubversiveSubstituteRangeConfirm)
xmap scr <Plug>(SubversiveSubstituteRangeConfirm)
nmap scrr <Plug>(SubversiveSubstituteWordRangeConfirm)

nmap <Leader><Leader>s <Plug>(SubversiveSubvertRange)
xmap <Leader><Leader>s <Plug>(SubversiveSubvertRange)
nmap <Leader><Leader>ss <Plug>(SubversiveSubvertWordRange)

" ie = inner entire buffer
onoremap ie :exec "normal! ggVG"<CR>
xnoremap ie :<C-U>exec "normal! ggVG"<CR>

" iV = current viewable text in the buffer
onoremap iV :exec "normal! HVL"<CR>
xnoremap iV :<C-U>exec "normal! HVL"<CR>

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

" To avoid mis-deleting character when cancelling sandwich operator
nnoremap s<Esc> <NOP>
" }}}

" vim-exchange {{{
" FIXME Due to usage of clipboard, it's slow in neovim in WSL
Plug 'tommcdo/vim-exchange'
" }}}

" far.vim {{{
Plug 'brooth/far.vim'

if has('python3')
  if has('nvim')
    if executable('rg')
      let g:far#source = 'rgnvim'
    elseif executable('ag')
      let g:far#source = 'agnvim'
    elseif executable('ack')
      let g:far#source = 'acknvim'
    endif
  else
    if executable('rg')
      let g:far#source = 'rg'
    elseif executable('ag')
      let g:far#source = 'ag'
    elseif executable('ack')
      let g:far#source = 'ack'
    endif
  endif
else
  " Default behavior
  " g:far#source = 'vimgrep'
endif

let g:far#ignore_files = [$HOME.'/.gitignore']

let g:far#mapping = {
      \ 'replace_do': 'S'
      \ }
" }}}

" ferret {{{
Plug 'wincent/ferret'

let g:FerretMap = 0
let g:FerretQFCommands = 0

nmap <Leader>fa <Plug>(FerretAck)
nmap <Leader>fl <Plug>(FerretLack)
nmap <Leader>fs <Plug>(FerretAckWord)
nmap <Leader>fr <Plug>(FerretAcks)
" }}}

Plug 'editorconfig/editorconfig-vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-repeat'
