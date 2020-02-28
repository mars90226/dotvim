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
  Plug 'airblade/vim-gitgutter', { 'on': [] }

  call vimrc#lazy#lazy_load('gitgutter')

  nmap <silent> [g <Plug>(GitGutterPrevHunk)
  nmap <silent> ]g <Plug>(GitGutterNextHunk)
  nnoremap cog :GitGutterToggle<CR>
  nnoremap <Leader>gT :GitGutterAll<CR>

  omap ig <Plug>(GitGutterTextObjectInnerPending)
  omap ag <Plug>(GitGutterTextObjectOuterPending)
  xmap ig <Plug>(GitGutterTextObjectInnerVisual)
  xmap ag <Plug>(GitGutterTextObjectOuterVisual)
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
