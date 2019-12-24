" Choose matcher {{{
if has("python3")
  " Temporarily use bug fixing branch, wait for merging to master
  Plug 'raghur/fruzzy', { 'branch': 'bug-19-crash', 'do': { -> fruzzy#install() } }

  let g:fruzzy#usenative = 1
  let g:ctrlp_match_func = { 'match': 'fruzzy#ctrlp#matcher' }
elseif has("python")
  Plug 'FelikZ/ctrlp-py-matcher'

  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif
" }}}

" CtrlP {{{
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky'
Plug 'ivalkeen/vim-ctrlp-tjump'

call vimrc#source('vimrc/plugins/ctrlp.vim')
" }}}

" netrw {{{
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro' " add line number
" }}}

" Vinegar {{{
Plug 'tpope/vim-vinegar'

nmap <silent> \-       <Plug>VinegarUp
nmap <silent> _        <Plug>VinegarVerticalSplitUp
nmap <silent> <Space>- <Plug>VinegarSplitUp
nmap <silent> <Space>_ <Plug>VinegarTabUp

augroup vinegar_settings
  autocmd!
  autocmd FileType netrw call vimrc#vinegar#mappings()
augroup END
" }}}

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

" vimfiler {{{
if vimrc#plugin#is_enabled_plugin("vimfiler")
  Plug 'Shougo/vimfiler.vim'
  Plug 'Shougo/neossh.vim'

  call vimrc#source('vimrc/plugins/vimfiler.vim')
endif
" }}}

" Defx {{{
if vimrc#plugin#is_enabled_plugin("defx")
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'kristijanhusak/defx-git'
  " Font not supported
  " Plug 'kristijanhusak/defx-icons'

  call vimrc#source('vimrc/plugins/defx.vim')
endif
" }}}

" vim-choosewin {{{
if vimrc#plugin#is_enabled_plugin("vimfiler")
  " Only used in vimfiler
  Plug 't9md/vim-choosewin'

  call vimrc#source('vimrc/plugins/choosewin.vim')
endif
" }}}

" neomru.vim & neoyank.vim {{{
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neoyank.vim'
" }}}

" Unite {{{
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'
Plug 'blindFS/unite-workflow', { 'on': [] }
Plug 'thinca/vim-unite-history'
Plug 'osyo-manga/unite-quickfix'

call vimrc#source('vimrc/plugins/unite.vim')
" }}}

" Denite {{{
if vimrc#plugin#is_enabled_plugin('denite.nvim')
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neoclide/denite-extra'
  Plug 'kmnk/denite-dirmark'

  call vimrc#source('vimrc/plugins/denite.vim')
endif
" }}}

" ctrlsf.vim {{{
Plug 'dyng/ctrlsf.vim', { 'on': ['CtrlSF', 'CtrlSFToggle'] }

nnoremap <Space><C-F> :execute 'CtrlSF ' . input('CtrlSF: ')<CR>
nnoremap <F5> :CtrlSFToggle<CR>
" }}}

" fzf {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

call vimrc#source('vimrc/plugins/fzf.vim')
" }}}

" vifm {{{
Plug 'vifm/vifm.vim'
" }}}

" vim-gutentags {{{
if vimrc#plugin#is_enabled_plugin('vim-gutentags')
  Plug 'ludovicchabant/vim-gutentags'

  " Don't update cscope, workload is too heavy
  let g:gutentags_modules = ['ctags']
  let g:gutentags_ctags_exclude = ['.git', 'node_modules', '.ccls-cache']
endif
" }}}

" alternate.vim {{{
Plug 'pchynoweth/a.vim'

augroup AlternateSettings
  autocmd!
  autocmd VimEnter * call <SID>alternate_settings()
augroup END
function! s:alternate_settings()
  " ReactJS
  let g:alternateExtensionsDict["javascript.jsx"] = {}
  let g:alternateExtensionsDict["javascript.jsx"]["js"] = "css,scss"
  let g:alternateExtensionsDict["css"] = {}
  let g:alternateExtensionsDict["css"]["css"] = "js"
  let g:alternateExtensionsDict["scss"] = {}
  let g:alternateExtensionsDict["scss"]["scss"] = "js"
endfunction
" }}}

" far.vim {{{
Plug 'brooth/far.vim'

if has("python3")
  if has("nvim")
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
" }}}
