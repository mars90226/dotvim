" Choose matcher {{{
if has('python3')
  " Temporarily use bug fixing branch, wait for merging to master
  Plug 'raghur/fruzzy', { 'branch': 'master', 'do': { -> fruzzy#install() } }

  let g:fruzzy#usenative = 1
  let g:ctrlp_match_func = { 'match': 'fruzzy#ctrlp#matcher' }
elseif has('python')
  Plug 'FelikZ/ctrlp-py-matcher'

  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif
" }}}

" neomru.vim & neoyank.vim {{{
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neoyank.vim'
" }}}

" Finders {{{
" ctrlp.vim {{{
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky'
Plug 'ivalkeen/vim-ctrlp-tjump'

call vimrc#source('vimrc/plugins/ctrlp.vim')
" }}}

" unite.vim {{{
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'
Plug 'blindFS/unite-workflow', { 'on': [] }
Plug 'thinca/vim-unite-history'
Plug 'osyo-manga/unite-quickfix'

call vimrc#source('vimrc/plugins/unite.vim')
" }}}

" denite.nvim {{{
if vimrc#plugin#is_enabled_plugin('denite.nvim')
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neoclide/denite-extra'
  Plug 'kmnk/denite-dirmark'

  call vimrc#source('vimrc/plugins/denite.vim')
endif
" }}}

" fzf {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

call vimrc#source('vimrc/plugins/fzf.vim')
" }}}

" vim-clap {{{
if vimrc#plugin#is_enabled_plugin('vim-clap')
  if vimrc#plugin#check#has_cargo()
    Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
  else
    Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
  endif

  call vimrc#source('vimrc/plugins/clap.vim')
endif
" }}}
" }}}

" Goto Definitions {{{
" tagbar {{{
Plug 'majutsushi/tagbar'

call vimrc#source('vimrc/plugins/tagbar.vim')
" }}}

" vista.vim {{{
Plug 'liuchengxu/vista.vim'

nnoremap <F7> :Vista!!<CR>
nnoremap <Space><F7> :Vista finder<CR>
nnoremap <M-F7> :Vista finder coc<CR>
nnoremap <Space><M-F7> :Vista coc<CR>

let g:vista_sidebar_width = 40
let g:vista_fzf_preview = ['right:50%']

augroup vista_load_nearest_method_or_function
  autocmd!
  autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
augroup END
" }}}

" any-jump.nvim {{{
Plug 'pechorin/any-jump.nvim'

nnoremap <Leader>aj :AnyJump<CR>
nnoremap <Leader>ab :AnyJumpBack<CR>
nnoremap <Leader>al :AnyJumpLastResults<CR>
" }}}

" vim-gutentags {{{
" Automatically update tags
if vimrc#plugin#is_enabled_plugin('vim-gutentags')
  Plug 'ludovicchabant/vim-gutentags'

  " Don't update cscope, workload is too heavy
  let g:gutentags_modules = ['ctags']
  let g:gutentags_ctags_exclude = ['.git', 'node_modules', '.ccls-cache']
endif
" }}}
" }}}

" ctrlsf.vim {{{
Plug 'dyng/ctrlsf.vim', { 'on': ['CtrlSF', 'CtrlSFToggle'] }

nnoremap <Space><C-F> :execute 'CtrlSF ' . input('CtrlSF: ')<CR>
nnoremap <F5> :CtrlSFToggle<CR>
" }}}

" alternate.vim {{{
Plug 'pchynoweth/a.vim'

augroup alternate_settings
  autocmd!
  autocmd VimEnter * call vimrc#alternative#settings()
augroup END
" }}}
