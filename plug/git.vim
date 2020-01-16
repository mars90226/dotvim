" vim-fugitive {{{
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'tommcdo/vim-fubitive'
Plug 'tpope/vim-rhubarb'
Plug 'idanarye/vim-merginal', { 'branch': 'develop' }

call vimrc#source('vimrc/plugins/fugitive.vim')
" }}}

" vim-gitgutter {{{
Plug 'airblade/vim-gitgutter', { 'on': [] }

call vimrc#lazy#lazy_load('gitgutter')

nmap <silent> [h <Plug>(GitGutterPrevHunk)
nmap <silent> ]h <Plug>(GitGutterNextHunk)
nnoremap cog :GitGutterToggle<CR>
nnoremap <Leader>gT :GitGutterAll<CR>

omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)
" }}}

" gv.vim {{{
Plug 'junegunn/gv.vim', { 'on': 'GV' }

command! -nargs=* GVA GV --all <args>

augroup gv_settings
  autocmd!
  autocmd FileType GV call vimrc#gv#mappings()
augroup END
" }}}

" vim-flog {{{
Plug 'rbong/vim-flog'

augroup flog_settings
  autocmd!
  autocmd FileType floggraph call vimrc#flog#mappings()
augroup END
" }}}

" vim-tig {{{
Plug 'codeindulgence/vim-tig', { 'on': ['Tig', 'Tig!'] }

call vimrc#source('vimrc/plugins/tig.vim')
" }}}

" git-messenger.vim {{{
Plug 'rhysd/git-messenger.vim', { 'on': ['GitMessenger', '<Plug>(git-messenger)'] }

nmap <Leader>gm <Plug>(git-messenger)
" }}}

" blamer.nvim {{{
if has('nvim')
  Plug 'APZelos/blamer.nvim'

  let g:blamer_enabled = 1
  let g:blamer_delay = 500
  let g:blamer_date_format = '%Y-%m-%d %H:%M'

  highlight! link Blamer GruvboxFg4

  nnoremap <Leader>gB :BlamerToggle<CR>
endif
" }}}

" Disabled as not used
Plug 'mattn/gist-vim', { 'for': [] }
