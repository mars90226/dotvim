" vim-fugitive {{{
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'tommcdo/vim-fubitive'
Plug 'tpope/vim-rhubarb'
Plug 'idanarye/vim-merginal', { 'branch': 'develop' }

call vimrc#source('vimrc/plugins/fugitive.vim')
call vimrc#source('vimrc/plugins/merginal.vim')
" }}}

" gv.vim {{{
Plug 'junegunn/gv.vim', { 'on': 'GV' }

command! -nargs=* GVA GV --all <args>

nnoremap <Leader>gv :GV!<CR>

augroup gv_settings
  autocmd!
  autocmd FileType GV call vimrc#gv#mappings()
augroup END
" }}}


" vim-flog {{{
Plug 'rbong/vim-flog'

command! -nargs=* Floga Flog -all <args>

nnoremap <Leader>gf :execute 'Flog -- '.shellescape(expand('%'))<CR>

augroup flog_settings
  autocmd!
  autocmd FileType floggraph call vimrc#flog#mappings()
augroup END
" }}}

" " vim-gitgutter {{{
" if vimrc#plugin#is_enabled_plugin('vim-gitgutter')
"   " Plug 'airblade/vim-gitgutter', { 'on': [] }
"   Plug 'airblade/vim-gitgutter'
"
"   " call vimrc#lazy#lazy_load('gitgutter')
"
"   let g:gitgutter_grep = 'rg --hidden --follow --glob "!.git/*"'
"
"   nnoremap cog :GitGutterBufferToggle<CR>
"   nnoremap coG :GitGutterToggle<CR>
"
"   nmap <silent> [h <Plug>(GitGutterPrevHunk)
"   nmap <silent> ]h <Plug>(GitGutterNextHunk)
"
"   omap ih <Plug>(GitGutterTextObjectInnerPending)
"   omap ah <Plug>(GitGutterTextObjectOuterPending)
"   xmap ih <Plug>(GitGutterTextObjectInnerVisual)
"   xmap ah <Plug>(GitGutterTextObjectOuterVisual)
" endif
" " }}}

" vim-signify {{{
Plug 'mhinz/vim-signify'

nnoremap <Leader>hd :SignifyDiff<CR>
nnoremap <Leader>hf :SignifyFold<CR>
nnoremap <Leader>hp :SignifyHunkDiff<CR>
nnoremap <Leader>hu :SignifyHunkUndo<CR>

nmap [h <Plug>(signify-prev-hunk)
nmap ]h <Plug>(signify-next-hunk)
nmap [H 9999<Plug>(signify-prev-hunk)
nmap ]H 9999<Plug>(signify-next-hunk)

omap ih <Plug>(signify-motion-inner-pending)
xmap ih <Plug>(signify-motion-inner-visual)
omap ah <Plug>(signify-motion-outer-pending)
xmap ah <Plug>(signify-motion-outer-visual)
" }}}

" vim-tig {{{
Plug 'codeindulgence/vim-tig', { 'on': ['Tig', 'Tig!'] }

call vimrc#source('vimrc/plugins/tig.vim')
" }}}

" git-messenger.vim {{{
Plug 'rhysd/git-messenger.vim', { 'on': ['GitMessenger', '<Plug>(git-messenger)'] }

nmap <Leader>gm <Plug>(git-messenger)

augroup git_messenger_settings
  autocmd!
  autocmd FileType gitmessengerpopup call vimrc#git_messenger#mappings()
augroup END
" }}}

" Disabled as not used
Plug 'mattn/gist-vim', { 'for': [] }
