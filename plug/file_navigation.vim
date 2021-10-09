" Choose matcher {{{
if has('python3')
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

" TODO: Raise neomru limit
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
" fzf#install() only install binary
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" TODO: Make Quickfix use g:fzf_action
Plug 'fszymanski/fzf-quickfix', { 'on': 'Quickfix' }
Plug 'stsewd/fzf-checkout.vim'
Plug 'laher/fuzzymenu.vim'

call vimrc#source('vimrc/plugins/fzf.vim')
call vimrc#source('vimrc/plugins/fuzzymenu.vim')
" }}}

" vim-clap {{{
if vimrc#plugin#is_enabled_plugin('vim-clap')
  if vimrc#plugin#check#has_cargo()
    Plug 'liuchengxu/vim-clap', { 'do': ':call vimrc#clap#install()', 'on': [] }
  else
    Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!', 'on': [] }
  endif

  call vimrc#source('vimrc/plugins/clap.vim')
endif
" }}}

" telescope.nvim {{{
if vimrc#plugin#is_enabled_plugin('telescope.nvim')
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-project.nvim'
  Plug 'jvgrootveld/telescope-zoxide'
  Plug 'sudormrfbin/cheatsheet.nvim'
  Plug 'nvim-telescope/telescope-media-files.nvim'

  if vimrc#plugin#is_enabled_plugin('telescope-fzf-native.nvim')
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  endif

  call vimrc#source('vimrc/plugins/telescope.vim')
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

call vimrc#source('vimrc/plugins/vista.vim')
" }}}

" any-jump.nvim {{{
if vimrc#plugin#is_enabled_plugin('any-jump.nvim')
  Plug 'pechorin/any-jump.nvim'

  let [g:any_jump_window_width_ratio, g:any_jump_window_height_ratio] = vimrc#float#get_default_ratio()
  let [_, g:any_jump_window_top_offset] = vimrc#float#calculate_pos_from_ratio(g:any_jump_window_width_ratio, g:any_jump_window_height_ratio)

  let g:any_jump_disable_default_keybindings = 1

  nnoremap <Leader>aj :AnyJump<CR>
  nnoremap <Leader>aa :AnyJumpArg<Space>
  xnoremap <Leader>aj :AnyJumpVisual<CR>
  nnoremap <Leader>ab :AnyJumpBack<CR>
  nnoremap <Leader>al :AnyJumpLastResults<CR>

  augroup any_jump_settings
    autocmd!
    autocmd FileType any-jump call vimrc#any_jump#settings()
  augroup END
endif
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
Plug 'dyng/ctrlsf.vim'

nmap <Space><C-F> <Plug>CtrlSFPrompt

nmap <Leader><C-F> <Plug>CtrlSFCwordExec
xmap <Leader><C-F> <Plug>CtrlSFVwordExec

nnoremap <F5> :CtrlSFToggle<CR>
" }}}

" Window Switching {{{
" vim-choosewin {{{
if vimrc#plugin#is_enabled_plugin('vim-choosewin')
  Plug 't9md/vim-choosewin'

  call vimrc#source('vimrc/plugins/choosewin.vim')
endif
" }}}

" nvim-window {{{
if vimrc#plugin#is_enabled_plugin('nvim-window')
  Plug 'https://gitlab.com/yorickpeterse/nvim-window.git'

  nnoremap <silent> =- <Cmd>lua require('nvim-window').pick()<CR>
endif
" }}}
" }}}

" alternate.vim {{{
Plug 'pchynoweth/a.vim'

augroup alternate_settings
  autocmd!
  autocmd VimEnter * call vimrc#alternative#settings()
augroup END
" }}}
