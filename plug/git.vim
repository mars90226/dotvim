" vim-fugitive {{{
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'tommcdo/vim-fubitive'
Plug 'tpope/vim-rhubarb'
Plug 'idanarye/vim-merginal', { 'branch': 'develop' }

call vimrc#source('vimrc/plugins/fugitive.vim')
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

" vim-gitgutter {{{
if vimrc#plugin#is_enabled_plugin('vim-gitgutter')
  " Plug 'airblade/vim-gitgutter', { 'on': [] }
  Plug 'airblade/vim-gitgutter'

  " call vimrc#lazy#lazy_load('gitgutter')

  let g:gitgutter_grep = 'rg --hidden --follow --glob "!.git/*"'

  nnoremap cog :GitGutterBufferToggle<CR>
  nnoremap coG :GitGutterToggle<CR>

  nmap <silent> [h <Plug>(GitGutterPrevHunk)
  nmap <silent> ]h <Plug>(GitGutterNextHunk)

  omap ih <Plug>(GitGutterTextObjectInnerPending)
  omap ah <Plug>(GitGutterTextObjectOuterPending)
  xmap ih <Plug>(GitGutterTextObjectInnerVisual)
  xmap ah <Plug>(GitGutterTextObjectOuterVisual)
endif
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
