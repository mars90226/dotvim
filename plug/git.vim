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
nnoremap <Leader>gt :GitGutterAll<CR>

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

" vim-tig {{{
Plug 'codeindulgence/vim-tig', { 'on': ['Tig', 'Tig!'] }

call vimrc#source('vimrc/plugins/tig.vim')
" }}}

" gina.vim {{{
if vimrc#plugin#is_enabled_plugin('gina.vim')
  Plug 'lambdalisue/gina.vim'

  nnoremap <Space>gb :Gina branch<CR>
  nnoremap <Space>gB :Gina blame<CR>
  xnoremap <Space>gB :Gina blame<CR>
endif
" }}}

" git-p.nvim {{{
" Disable git-p.nvim in nested neovim due to channel error
if vimrc#plugin#is_enabled_plugin('git-p.nvim')
  Plug 'iamcco/sran.nvim', { 'do': { -> sran#util#install() } }
  Plug 'iamcco/git-p.nvim'

  call vimrc#source('vimrc/plugins/git_p.vim')
endif
" }}}

Plug 'mattn/gist-vim'
