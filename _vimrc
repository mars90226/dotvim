"
" Bootstrap {{{
" ====================================================================
" Map Leader
let g:mapleader = ","

" Language
" Always use English to avoid plugin not catching exception due to translation
" E.g. vim-subversive tries to catch 'Unknown Exception'
if !has('nvim')
  " neovim current seems not using system locale
  " And language C seems to break :Denite file
  language C
endif

" Change Menu language
" This should happen before loading plugins to avoid deleting plugins' menus
if has('gui')
  if &langmenu != 'en_US.UTF-8'
    set langmenu=en_US.UTF-8
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
  endif
endif

" Set Encoding
if vimrc#plugin#check#get_os() =~ "windows"
  set encoding=utf8
endif

" plugin choosing {{{
" enabled plugin management {{{
command! ListDisabledPlugins call vimrc#plugin#get_disabled_plugins()
" }}}

" plugin config cache {{{
command! UpdatePluginConfigCache call vimrc#plugin#config_cache#update()

call vimrc#plugin#config_cache#read()
call vimrc#plugin#config_cache#init()
" }}}

" Start choosing
call vimrc#plugin#choose#start($VIM_MODE, $NVIM_TERMINAL)
" }}}

" Autoinstall vim-plug {{{
if empty(glob(vimrc#get_vimhome().'/autoload/plug.vim'))
  silent! !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://rawgithubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup plug_install
    autocmd!
    autocmd VimEnter * PlugInstall
  augroup END
endif
" }}}
" }}}

" Plugin Settings Begin {{{
" vim-plug
call plug#begin(vimrc#get_vimhome().'/plugged')
" }}}

" Appearance {{{
" ====================================================================
" vim-airline {{{
if vimrc#plugin#is_enabled_plugin('vim-airline')
  call vimrc#source('vimrc/plugins/plug/airline.vim')

  call vimrc#source('vimrc/plugins/airline.vim')
endif
" }}}

" lightline.vim {{{
if vimrc#plugin#is_enabled_plugin('lightline.vim')
  Plug 'itchyny/lightline.vim'
  Plug 'maximbaz/lightline-ale'
  Plug 'shinchu/lightline-gruvbox.vim'

  call vimrc#source('vimrc/plugins/lightline.vim')
endif
" }}}

" indentLine {{{
Plug 'Yggdroot/indentLine', { 'on': ['IndentLinesEnable', 'IndentLinesToggle'] }

let g:indentLine_enabled = 0
let g:indentLine_color_term = 243
let g:indentLine_color_gui = '#AAAAAA'

function! s:toggle_indentline_enabled()
  if g:indentLine_enabled == 0
    let g:indentLine_enabled = 1
  else
    let g:indentLine_enabled = 0
  endif
endfunction

nnoremap <Space>il :IndentLinesToggle<CR>
nnoremap <Space>iL :call <SID>toggle_indentline_enabled()<CR>

augroup indent_line_syntax
  autocmd!
  autocmd User indentLine doautocmd indentLine Syntax
augroup END
" }}}

" vim-devicons {{{
" Disable for now as Fira Code nerd fonts is not patched
Plug 'ryanoasis/vim-devicons', { 'for': [] }
" }}}

" Colors {{{
Plug 'morhetz/gruvbox'
Plug 'junegunn/seoul256.vim'
Plug 'chriskempson/base16-vim'
Plug 'altercation/vim-colors-solarized'
" }}}
" }}}

" Completion {{{
" ====================================================================
" completion setting {{{
" FIXME Completion popup still appear after select completion.
" inoremap <expr> <Esc>      pumvisible() ? "\<C-E>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-Y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-N>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-P>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-P>\<C-N>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-P>\<C-N>" : "\<PageUp>"
inoremap <expr> <Tab>      pumvisible() ? "\<C-N>" : "\<Tab>"

" Workaround of supertab bug
if vimrc#plugin#is_disabled_plugin('supertab')
  inoremap <expr> <S-Tab>    pumvisible() ? "\<C-P>" : "\<S-Tab>"
endif
" }}}

" coc.nvim {{{
if vimrc#plugin#is_enabled_plugin('coc.nvim')
  Plug 'Shougo/neco-vim'
  Plug 'neoclide/coc-neco'
  Plug 'neoclide/coc.nvim', { 'do': { -> coc#util#install() } }
  Plug 'neoclide/coc-denite'

  call vimrc#source('vimrc/plugins/coc.vim')
endif
" }}}

" deoplete.nvim {{{
if vimrc#plugin#is_enabled_plugin('deoplete.nvim')
  call vimrc#source('vimrc/plugins/plug/deoplete.vim')

  call vimrc#source('vimrc/plugins/deoplete.vim')
endif
" }}}

" completor.vim {{{
if vimrc#plugin#is_enabled_plugin('completor.vim')
  Plug 'maralla/completor.vim'

  if vimrc#plugin#check#has_linux_build_env()
    let g:completor_clang_binary = "/usr/lib/llvm-8/lib/clang"
  end
endif
" }}}

" YouCompleteMe {{{
if vimrc#plugin#is_enabled_plugin('YouCompleteMe')
  Plug 'Valloric/YouCompleteMe', { 'do': 'python install.py --clang_completer' }

  call vimrc#source('vimrc/plugins/YouCompleteMe.vim')
endif
" }}}

" supertab {{{
if vimrc#plugin#is_enabled_plugin('supertab')
  Plug 'ervandew/supertab'
endif
" }}}

" neosnippet {{{
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

let g:neosnippet#snippets_directory = vimrc#get_vimhome().'/plugged/neosnippet-snippets/neosnippets'
let g:neosnippet#snippets_directory = vimrc#get_vimhome().'/plugged/vim-snippets/snippets'

" Plugin key-mappings.
" <C-J>: expand or jump or select completion
imap <silent><expr> <C-J>
      \ pumvisible() && !neosnippet#expandable_or_jumpable() ?
      \ "\<C-Y>" :
      \ "\<Plug>(neosnippet_expand_or_jump)"
smap <C-J> <Plug>(neosnippet_expand_or_jump)
xmap <C-J> <Plug>(neosnippet_expand_target)

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" }}}

" tmux-complete.vim {{{
if executable('tmux')
  Plug 'wellle/tmux-complete.vim'
endif
" }}}
" }}}

" File Navigation {{{
" ====================================================================
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
Plug 'sgur/ctrlp-extensions.vim'
Plug 'tacahiroy/ctrlp-funky'
Plug 'mattn/ctrlp-hackernews'
Plug 'fisadev/vim-ctrlp-cmdpalette'
Plug 'ivalkeen/vim-ctrlp-tjump'

call vimrc#source('vimrc/plugins/ctrlp.vim')
" }}}

" Vinegar {{{
Plug 'tpope/vim-vinegar'

nmap <silent> \-       <Plug>VinegarUp
nmap <silent> _        <Plug>VinegarVerticalSplitUp
nmap <silent> <Space>- <Plug>VinegarSplitUp
nmap <silent> <Space>_ <Plug>VinegarTabUp
" }}}

" tagbar {{{
Plug 'majutsushi/tagbar', { 'on': ['TagbarToggle', 'TagbarOpenAutoClose'] }

call vimrc#source('vimrc/plugins/tagbar.vim')
" }}}

" vista.vim {{{
Plug 'liuchengxu/vista.vim'

nnoremap <F7> :Vista!!<CR>
nnoremap <Space><F7> :Vista finder<CR>

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

" Unite {{{
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'
Plug 'Shougo/unite-session'
Plug 'tsukkee/unite-tag'
Plug 'blindFS/unite-workflow', { 'on': [] }
Plug 'kmnk/vim-unite-giti'
Plug 'Shougo/vinarise.vim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neoyank.vim'
Plug 'Shougo/unite-help'
Plug 'thinca/vim-unite-history'
Plug 'hewes/unite-gtags'
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
Plug 'dyng/ctrlsf.vim', { 'on': 'CtrlSF' }

nnoremap <Space><C-F> :execute 'CtrlSF ' . input('CtrlSF: ')<CR>
nnoremap <F5> :CtrlSFToggle<CR>
" }}}

" ranger.vim {{{
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim', { 'on': 'Ranger' }

let g:ranger_map_keys = 0
nnoremap <Space>rr :Ranger<CR>
nnoremap <Space>rs :split     <Bar> Ranger<CR>
nnoremap <Space>rv :vsplit    <Bar> Ranger<CR>
nnoremap <Space>rt :tab split <Bar> Ranger<CR>
" }}}

" fzf {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

call vimrc#source('vimrc/plugins/fzf.vim')
" }}}
" }}}

" skim {{{
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }

call vimrc#source('vimrc/plugins/skim.vim')
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
Plug 'brooth/far.vim', { 'on': ['Far', 'Farp', 'F'] }

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

" }}}

" Text Navigation {{{
" ====================================================================
" matchit {{{
runtime macros/matchit.vim
Plug 'voithos/vim-python-matchit'
" }}}

" EasyMotion {{{
Plug 'easymotion/vim-easymotion', { 'on': [] }

call vimrc#lazy#lazy_load('easymotion')

let g:EasyMotion_leader_key = '<Space>'
let g:EasyMotion_smartcase = 1

map ; <Plug>(easymotion-s2)

map \w <Plug>(easymotion-bd-wl)
map \f <Plug>(easymotion-bd-fl)
map \s <Plug>(easymotion-sl2)

map <Leader>f <Plug>(easymotion-bd-f)
map <Space><Space>l <Plug>(easymotion-bd-jk)
map <Plug>(easymotion-prefix)s <Plug>(easymotion-bd-f2)
map <Plug>(easymotion-prefix)w <Plug>(easymotion-bd-w)

nmap <Leader>' <Plug>(easymotion-next)
nmap <Leader>; <Plug>(easymotion-prev)
nmap <Leader>. <Plug>(easymotion-repeat)

map <Plug>(easymotion-prefix)J <Plug>(easymotion-eol-j)
map <Plug>(easymotion-prefix)K <Plug>(easymotion-eol-k)

map <Plug>(easymotion-prefix); <Plug>(easymotion-jumptoanywhere)

" overwin is slow, disabled
" if vimrc#plugin#check#get_os() !~ "synology"
"   nmap <Leader>f <Plug>(easymotion-overwin-f)
"   nmap <Plug>(easymotion-prefix)s <Plug>(easymotion-overwin-f2)
"   nmap <Plug>(easymotion-prefix)L <Plug>(easymotion-overwin-line)
"   nmap <Plug>(easymotion-prefix)w <Plug>(easymotion-overwin-w)
" endif
" }}}

" vim-asterisk {{{
Plug 'haya14busa/vim-asterisk'

map *   <Plug>(incsearch-nohl)<Plug>(asterisk-*)
map #   <Plug>(incsearch-nohl)<Plug>(asterisk-#)
map g*  <Plug>(incsearch-nohl)<Plug>(asterisk-g*)
map g#  <Plug>(incsearch-nohl)<Plug>(asterisk-g#)
map z*  <Plug>(incsearch-nohl0)<Plug>(asterisk-z*)
map gz* <Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
map z#  <Plug>(incsearch-nohl0)<Plug>(asterisk-z#)
map gz# <Plug>(incsearch-nohl0)<Plug>(asterisk-gz#)
" }}}

" vim-anzu {{{
Plug 'osyo-manga/vim-anzu'

call vimrc#source('vimrc/plugins/anzu.vim')
" }}}

" incsearch {{{
Plug 'haya14busa/incsearch.vim'

" :h g:incsearch#auto_nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1

" Replace by vim-anzu
"map n  <Plug>(incsearch-nohl-n)
"map N  <Plug>(incsearch-nohl-N)

" Replace by vim-asterisk
"map *  <Plug>(incsearch-nohl-*)
"map #  <Plug>(incsearch-nohl-#)
"map g* <Plug>(incsearch-nohl-g*)
"map g# <Plug>(incsearch-nohl-g#)

" For original search incase need to insert special characters like NULL
nnoremap \\/ /
nnoremap \\? ?

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Search within visual selection
xmap <M-/> <Esc><Plug>(incsearch-forward)\%V
xmap <M-?> <Esc><Plug>(incsearch-backward)\%V

augroup incsearch_settings
  autocmd!
  autocmd BufWinLeave,WinLeave * call vimrc#incsearch#clear_nohlsearch()
augroup END

command! ClearIncsearchAutoNohlsearch call vimrc#incsearch#clear_auto_nohlsearch()
" }}}

" incsearch-fuzzy {{{
Plug 'haya14busa/incsearch-fuzzy.vim'

map z/  <Plug>(incsearch-fuzzy-/)
map z?  <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)
" }}}

" incsearch-easymotion {{{
Plug 'haya14busa/incsearch-easymotion.vim'

map <Leader>/  <Plug>(incsearch-easymotion-/)
map <Leader>?  <Plug>(incsearch-easymotion-?)
map <Leader>g/ <Plug>(incsearch-easymotion-stay)
" }}}

" incsearch.vim x fuzzy x vim-easymotion {{{
noremap <silent><expr> \/ incsearch#go(vimrc#incsearch#config_easyfuzzymotion())
noremap <silent><expr> Z/ incsearch#go(vimrc#incsearch#config_easyfuzzymotion())
" }}}

" CamelCaseMotion {{{
Plug 'bkad/CamelCaseMotion'

map <Leader>mw <Plug>CamelCaseMotion_w
map <Leader>mb <Plug>CamelCaseMotion_b
map <Leader>me <Plug>CamelCaseMotion_e
map <Leader>mge <Plug>CamelCaseMotion_ge

omap <silent> imw <Plug>CamelCaseMotion_iw
xmap <silent> imw <Plug>CamelCaseMotion_iw
omap <silent> imb <Plug>CamelCaseMotion_ib
xmap <silent> imb <Plug>CamelCaseMotion_ib
omap <silent> ime <Plug>CamelCaseMotion_ie
xmap <silent> ime <Plug>CamelCaseMotion_ie
" }}}

" vim-edgemotion {{{
Plug 'haya14busa/vim-edgemotion'

map <Space><Space>j <Plug>(edgemotion-j)
map <Space><Space>k <Plug>(edgemotion-k)
" }}}

" vim-indentwise {{{
Plug 'jeetsukumaran/vim-indentwise', { 'on': [] }

call vimrc#lazy#lazy_load('indentwise')
" }}}

Plug 'wellle/targets.vim'
" }}}

" Text Manipulation {{{
" ====================================================================
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

nmap s <Plug>(SubversiveSubstitute)
nmap ss <Plug>(SubversiveSubstituteLine)
nmap sS <Plug>(SubversiveSubstituteToEndOfLine)

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
nmap =s "+<Plug>(SubversiveSubstitute)
nmap =ss "+<Plug>(SubversiveSubstituteLine)
nmap =sS "+<Plug>(SubversiveSubstituteToEndOfLine)
" }}}

Plug 'editorconfig/editorconfig-vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" }}}

" Text Objects {{{
" ====================================================================
Plug 'kana/vim-textobj-user'

" vim-textobj-function {{{
Plug 'kana/vim-textobj-function'

" Search in function
map <Space>sF :call vimrc#incsearch#clear_nohlsearch()<CR>vaf<M-/>
" }}}

Plug 'michaeljsmith/vim-indent-object'
Plug 'coderifous/textobj-word-column.vim'
" }}}

" Languages {{{
" ====================================================================
" emmet {{{
Plug 'mattn/emmet-vim', { 'on': [] }

call vimrc#lazy#lazy_load('emmet')

let g:user_emmet_leader_key = '<C-E>'
" }}}

" cscope-macros.vim {{{
Plug 'mars90226/cscope_macros.vim', { 'on': [] }

call vimrc#source('vimrc/plugins/cscope.vim')
" }}}

" vim-seeing-is-believing {{{
Plug 'hwartig/vim-seeing-is-believing', { 'for': 'ruby' }

augroup seeingIsBelievingSettings
  autocmd!
  autocmd FileType ruby call s:seeing_is_believing_settings()
augroup END

function! s:seeing_is_believing_settings()
  nmap <silent><buffer> <Leader>r<CR> <Plug>(seeing-is-believing-mark-and-run)
  xmap <silent><buffer> <Leader>r<CR> <Plug>(seeing-is-believing-mark-and-run)

  nmap <silent><buffer> <Leader>rm <Plug>(seeing-is-believing-mark)
  xmap <silent><buffer> <Leader>rm <Plug>(seeing-is-believing-mark)
  imap <silent><buffer> <Leader>rm <Plug>(seeing-is-believing-mark)

  nmap <silent><buffer> <Leader>rr <Plug>(seeing-is-believing-run)
  imap <silent><buffer> <Leader>rr <Plug>(seeing-is-believing-run)
endfunction
" }}}

" syntastic {{{
if vimrc#plugin#is_enabled_plugin('syntastic')
  Plug 'vim-syntastic/syntastic'

  call vimrc#source('vimrc/plugins/syntastic.vim')
end
" }}}

" ale {{{
if vimrc#plugin#is_enabled_plugin('ale')
  Plug 'w0rp/ale'

  call vimrc#source('vimrc/plugins/ale.vim')
end
" }}}

" markdown-preview.vim {{{
if vimrc#plugin#is_enabled_plugin('markdown-preview.vim')
  Plug 'iamcco/markdown-preview.vim'
endif
" }}}

" markdown-preview.nvim {{{
if vimrc#plugin#is_enabled_plugin('markdown-preview.nvim')
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
endif
" }}}

" vim-markdown-composer {{{
if executable('cargo')
  function! BuildComposer(info)
    if a:info.status != 'unchanged' || a:info.force
      if has('nvim')
        !cargo build --release
      else
        !cargo build --release --no-default-features --features json-rpc
      endif
    endif
  endfunction

  Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

  " Manually execute :ComposerStart instead
  let g:markdown_composer_autostart = 0
endif
" }}}

" vim-go {{{
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

let g:go_decls_mode = 'fzf'

" TODO Add key mappings for vim-go commands
" }}}

" vim-polyglot {{{
Plug 'sheerun/vim-polyglot'

" Avoid conflict with vim-go, must after vim-go loaded
let g:polyglot_disabled = ['go']
" }}}

" tern_for_vim {{{
Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }

augroup tern_for_vim_settings
  autocmd!
  autocmd FileType javascript call s:tern_for_vim_settings()
augroup END

function! s:tern_for_vim_settings()
  nnoremap <silent><buffer> <C-X><C-K> :TernDoc<CR>
  nnoremap <silent><buffer> <C-X><C-B> :TernDocBrowse<CR>
  nnoremap <silent><buffer> <C-X><C-T> :TernType<CR>
  " To avoid accidentally delete
  nnoremap <silent><buffer> <C-X><C-D> :TernDef<CR>
  nnoremap <silent><buffer> <C-X><C-P> :TernDefPreview<CR>
  nnoremap <silent><buffer> <C-X><C-S> :TernDefSplit<CR>
  nnoremap <silent><buffer> <C-X><C-N> :TernDefTab<CR>
  nnoremap <silent><buffer> <C-X>c :TernRefs<CR>
  nnoremap <silent><buffer> <C-X><C-R> :TernRename<CR>
endfunction
" }}}

" jedi-vim {{{
if vimrc#plugin#check#has_jedi()
  Plug 'davidhalter/jedi-vim', { 'for': 'python' }

  let g:jedi#completions_enabled = 1

  let g:jedi#goto_command             = "<C-X><C-G>"
  let g:jedi#goto_assignments_command = "<C-X>a"
  let g:jedi#goto_definitions_command = "<C-X><C-D>"
  let g:jedi#documentation_command    = "<C-X><C-K>"
  let g:jedi#usages_command           = "<C-X>c"
  let g:jedi#completions_command      = "<C-X><C-X>"
  let g:jedi#rename_command           = "<C-X><C-R>"

  augroup jedi_vim_settings
    autocmd!
    autocmd FileType python call s:jedi_vim_settings()
  augroup END

  function! s:jedi_vim_settings()
    nnoremap <silent><buffer> <C-X><C-L> :call jedi#remove_usages()<CR>
    nnoremap <silent><buffer> <C-X><C-N> :tab split <Bar> call jedi#goto()<CR>
  endfunction
endif
" }}}

Plug 'moll/vim-node', { 'for': [] }
Plug 'tpope/vim-rails', { 'for': [] }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
" Plug 'amadeus/vim-jsx', { 'for': 'jsx' } " It's included in vim-polyglot
Plug 'scrooloose/vim-slumlord'
Plug 'mars90226/perldoc-vim'
Plug 'gyim/vim-boxdraw'
Plug 'fs111/pydoc.vim'
" }}}

" Git {{{
" ====================================================================
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

nmap <silent> [h <Plug>GitGutterPrevHunk
nmap <silent> ]h <Plug>GitGutterNextHunk
nnoremap cog :GitGutterToggle<CR>
nnoremap <Leader>gt :GitGutterAll<CR>

omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual
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

" Gina {{{
Plug 'lambdalisue/gina.vim'

nnoremap <Space>gb :Gina branch<CR>
nnoremap <Space>gB :Gina blame<CR>
xnoremap <Space>gB :Gina blame<CR>
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
" }}}

" Utility {{{
" ====================================================================
" vim-mundo {{{
if vimrc#plugin#is_enabled_plugin('vim-mundo')
  Plug 'simnalamburt/vim-mundo', { 'on': 'MundoToggle' }

  if has("python3")
    let g:mundo_prefer_python3 = 1
  endif

  nnoremap <F9> :MundoToggle<CR>
endif
" }}}

" vim-unimpaired {{{
Plug 'tpope/vim-unimpaired', { 'on': [] }

call vimrc#lazy#lazy_load('unimpaired')

" Ignore [a, ]a, [A, ]A for ale
let g:nremap = {"[a": "", "]a": "", "[A": "", "]A": ""}

nmap \[u  <Plug>unimpaired_url_encode
nmap \[uu <Plug>unimpaired_line_url_encode
nmap \]u  <Plug>unimpaired_url_decode
nmap \]uu <Plug>unimpaired_line_url_decode

nnoremap coc :set termguicolors!<CR>
nnoremap coe :set expandtab!<CR>
nnoremap com :set modifiable!<CR>
nnoremap coo :set readonly!<CR>
nnoremap cop :set paste!<CR>
" }}}

" vim-characterize {{{
Plug 'tpope/vim-characterize'

nmap gA <Plug>(characterize)
" }}}

" vim-peekaboo {{{
Plug 'junegunn/vim-peekaboo'

let g:peekaboo_window = 'vertical botright ' . float2nr(&columns * 0.3) . 'new'
let g:peekaboo_delay = 400
" }}}

" colorv {{{
Plug 'Rykka/colorv.vim', { 'on': ['ColorV', 'ColorVName'] }

nnoremap <silent> <Leader>cN :ColorVName<CR>
" }}}

" VimShell {{{
Plug 'Shougo/vimshell.vim', { 'on': ['VimShell', 'VimShellCurrentDir', 'VimShellBufferDir', 'VimShellTab'] }

nnoremap <silent> <Leader>vv :VimShell<CR>
nnoremap <silent> <Leader>vc :VimShellCurrentDir<CR>
nnoremap <silent> <Leader>vb :VimShellBufferDir<CR>
nnoremap <silent> <Leader>vt :VimShellTab<CR>
" }}}

" deol.nvim {{{
if has("nvim")
  Plug 'Shougo/deol.nvim'
endif
" }}}

" vim-rooter {{{
Plug 'airblade/vim-rooter', { 'on': 'Rooter' }

let g:rooter_manual_only = 1
let g:rooter_use_lcd = 1
let g:rooter_patterns = ['Cargo.toml', '.git/']
nnoremap <Leader>r :Rooter<CR>
" }}}

" vimwiki {{{
Plug 'vimwiki/vimwiki'

nnoremap <Leader>wg :VimwikiToggleListItem<CR>
" }}}

" orgmode {{{
Plug 'jceb/vim-orgmode'
" }}}

" vimoutliner {{{
Plug 'vimoutliner/vimoutliner'
" }}}

" AnsiEsc.vim {{{
Plug 'powerman/vim-plugin-AnsiEsc', { 'on': 'AnsiEsc' }

nnoremap coa :AnsiEsc<CR>
" }}}

" vim-lastplace {{{
Plug 'farmergreg/vim-lastplace'

let g:lastplace_ignore = "gitcommit,gitrebase,sv,hgcommit"
let g:lastplace_ignore_buftype = "quickfix,nofile,help"
let g:lastplace_open_folds = 0
" }}}

" neoterm {{{
if has("nvim")
  Plug 'kassio/neoterm', { 'on': [] }

  call vimrc#source('vimrc/plugins/neoterm.vim')
endif
" }}}

" vim-localvimrc {{{
Plug 'embear/vim-localvimrc'

let g:localvimrc_whitelist = ['/synosrc/[^/]*/source/.*']
" }}}

" vim-qfreplace {{{
Plug 'thinca/vim-qfreplace'

augroup qfreplace_settings
  autocmd!
  autocmd FileType qf call s:qfreplace_settings()
augroup END

function! s:qfreplace_settings()
  nnoremap <silent><buffer> r :<C-U>Qfreplace<CR>
endfunction
" }}}

" vim-caser {{{
Plug 'arthurxavierx/vim-caser', { 'on': [] }

call vimrc#lazy#lazy_load('caser')
" }}}

" vim-highlightedyank {{{
if vimrc#plugin#is_enabled_plugin('vim-highlightedyank')
  Plug 'machakann/vim-highlightedyank'

  let g:highlightedyank_highlight_duration = 200
endif
" }}}

" goyo.vim {{{
Plug 'junegunn/goyo.vim'

nnoremap <Leader>gy :Goyo<CR>
" }}}

" limelight.vim {{{
Plug 'junegunn/limelight.vim'

nnoremap <Leader><C-L> :Limelight!!<CR>
" }}}

" vim-dispatch {{{
Plug 'tpope/vim-dispatch', { 'on': [] }

call vimrc#lazy#lazy_load('dispatch')

nnoremap <Leader>co :Copen<CR>
" }}}

" securemodelines {{{
" See https://www.reddit.com/r/vim/comments/bwp7q3/code_execution_vulnerability_in_vim_811365_and/
" and https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md for more details
Plug 'ciaranm/securemodelines'
" }}}

" vim-scriptease {{{
Plug 'tpope/vim-scriptease', { 'on': [] }

call vimrc#lazy#lazy_load('scriptease')
" }}}

" open-browser.vim {{{
if vimrc#plugin#is_enabled_plugin('open-browser.vim')
  Plug 'tyru/open-browser.vim'
endif
" }}}

Plug 'tpope/vim-dadbod', { 'on': 'DB' }
Plug 'tpope/vim-abolish', { 'on': ['Abolish', 'Subvert', 'S'] }
Plug 'will133/vim-dirdiff', { 'on': 'DirDiff' }
Plug 'AndrewRadev/linediff.vim', { 'on': 'Linediff' }
Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'alx741/vinfo', { 'on': 'Vinfo' }
Plug 'mattn/webapi-vim'
Plug 'kana/vim-arpeggio'
Plug 'kopischke/vim-fetch'
Plug 'Valloric/ListToggle'
Plug 'tpope/vim-eunuch'
Plug 'DougBeney/pickachu', { 'on': 'Pick' }
Plug 'tweekmonster/helpful.vim'
Plug 'tweekmonster/startuptime.vim'

" " nvim-gdb {{{
" Disabled for now as neovim's neovim_gdb.vim seems not exists
" if has("nvim")
"   Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
" endif

" " }}}

" }}}

" Plugin Settings End {{{
" vim-plug
call plug#end()
" }}}

" Post-loaded Plugin Settings {{{
" TODO Move all plugin settings to post-loaded settings

" coc.nvim {{{
if vimrc#plugin#is_enabled_plugin('coc.nvim')
  call vimrc#source('vimrc/plugins/coc_after.vim')
endif
" }}}

" deoplete.nvim {{{
if vimrc#plugin#is_enabled_plugin('deoplete.nvim')
  " Use smartcase.
  call deoplete#custom#option('smart_case', v:true)
endif
" }}}

" Unite {{{
augroup post_loaded_unite_mappings
  autocmd!
  autocmd VimEnter * call vimrc#unite#post_loaded_mappings()
augroup END
" }}}

" Denite {{{
if vimrc#plugin#is_enabled_plugin('denite.nvim')
  call vimrc#source('vimrc/plugins/denite_after.vim')
endif
" }}}

" Defx {{{
if vimrc#plugin#is_enabled_plugin("defx")
  call vimrc#source('vimrc/plugins/defx_after.vim')
endif
" }}}

" Gina {{{
call vimrc#source('vimrc/plugins/gina_after.vim')
" }}}

" Arpeggio {{{
call arpeggio#load()

" Quickly escape insert mode
Arpeggio inoremap jk <Esc>
" }}}
" }}}

" General Settings {{{
" ====================================================================
call vimrc#source('vimrc/settings.vim')
" }}}

" Indention {{{
" ====================================================================
call vimrc#source('vimrc/indent.vim')
" }}}

" Search {{{
" ====================================================================
call vimrc#source('vimrc/search.vim')
" }}}

" Colors and Highlights {{{
" ====================================================================
call vimrc#source('vimrc/colors.vim')
" }}}

" Key Mappings {{{
" ====================================================================
call vimrc#source('vimrc/mappings.vim')
" }}}

" Terminal {{{
" ====================================================================
call vimrc#source('vimrc/terminal.vim')
" }}}

" Autocommands {{{
" ====================================================================
call vimrc#source('vimrc/autocmd.vim')
" }}}

" Fix and Workarounds {{{
" ====================================================================
call vimrc#source('vimrc/workaround.vim')
" }}}

" vim: set sw=2 ts=2 sts=2 et foldlevel=0 foldmethod=marker:
