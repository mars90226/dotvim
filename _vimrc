" pathogen
"call pathogen#runtime_append_all_bundles()
"let g:pathogen_disabled = ['vim-airline']
call pathogen#infect()
call pathogen#helptags()
" pathogen

set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

let mapleader=","
autocmd FileType c,cpp :call C_CPPMAP()
function! C_CPPMAP()
  map <buffer> <leader><space> :w<cr>:make<cr>
  nmap <leader>cn :cn<cr>
  nmap <leader>cp :cp<cr>
  nmap <leader>cw :cw 10<cr>
endfunction

" taglist
let Tlist_Ctags_Cmd = 'ctags'
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
map <F12> :TlistToggle<CR>
" taglist

map <C-W><C-A> :redraw!<CR>

" Pair up with 'set winaltkeys=no' in _gvimrc
nmap <M-h> <C-W>h
nmap <M-j> <C-W>j
nmap <M-k> <C-W>k
nmap <M-l> <C-W>l
set encoding=utf8 " make sure mapping is correct in UTF-8
nmap <M-h> <C-W>h
nmap <M-j> <C-W>j
nmap <M-k> <C-W>k
nmap <M-l> <C-W>l
set encoding=cp950

" Win32
"nmap <Leader>x :execute ':! "'.expand('%').'"'<CR>
nmap <Leader>x :!start cmd /c "%:p"<CR>
nmap <Leader>X :!start cmd /K cd /D %:p:h<CR>
nmap <Leader>E :!start explorer %:p:h:gs?\/?\\?<CR>

" Tabular
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>athen :Tabularize /then<CR>
vmap <Leader>athen :Tabularize /then<CR>
" Tabular

" fuzzyfinder
let g:fuf_modesDisable = []
let g:fuf_mrufile_maxItem = 400
let g:fuf_mrucmd_maxItem = 400
nnoremap <silent> <leader>fj     :FufBuffer<CR>
nnoremap <silent> <leader>fk     :FufFileWithCurrentBufferDir<CR>
nnoremap <silent> <leader>fK     :FufFileWithFullCwd<CR>
nnoremap <silent> <leader>f<C-k> :FufFile<CR>
nnoremap <silent> <leader>fl     :FufCoverageFileChange<CR>
nnoremap <silent> <leader>fL     :FufCoverageFileChange<CR>
nnoremap <silent> <leader>f<C-l> :FufCoverageFileRegister<CR>
nnoremap <silent> <leader>fd     :FufDirWithCurrentBufferDir<CR>
nnoremap <silent> <leader>fD     :FufDirWithFullCwd<CR>
nnoremap <silent> <leader>f<C-d> :FufDir<CR>
nnoremap <silent> <leader>fn     :FufMruFile<CR>
nnoremap <silent> <leader>fN     :FufMruFileInCwd<CR>
nnoremap <silent> <leader>fm     :FufMruCmd<CR>
nnoremap <silent> <leader>fu     :FufBookmarkFile<CR>
nnoremap <silent> <leader>f<C-u> :FufBookmarkFileAdd<CR>
vnoremap <silent> <leader>f<C-u> :FufBookmarkFileAddAsSelectedText<CR>
nnoremap <silent> <leader>fi     :FufBookmarkDir<CR>
nnoremap <silent> <leader>f<C-i> :FufBookmarkDirAdd<CR>
nnoremap <silent> <leader>ft     :FufTag<CR>
nnoremap <silent> <leader>fT     :FufTag!<CR>
nnoremap <silent> <leader>f<C-]> :FufTagWithCursorWord!<CR>
nnoremap <silent> <leader>f,     :FufBufferTag<CR>
nnoremap <silent> <leader>f<     :FufBufferTag!<CR>
vnoremap <silent> <leader>f,     :FufBufferTagWithSelectedText!<CR>
vnoremap <silent> <leader>f<     :FufBufferTagWithSelectedText<CR>
nnoremap <silent> <leader>f}     :FufBufferTagWithCursorWord!<CR>
nnoremap <silent> <leader>f.     :FufBufferTagAll<CR>
nnoremap <silent> <leader>f>     :FufBufferTagAll!<CR>
vnoremap <silent> <leader>f.     :FufBufferTagAllWithSelectedText!<CR>
vnoremap <silent> <leader>f>     :FufBufferTagAllWithSelectedText<CR>
nnoremap <silent> <leader>f]     :FufBufferTagAllWithCursorWord!<CR>
nnoremap <silent> <leader>fg     :FufTaggedFile<CR>
nnoremap <silent> <leader>fG     :FufTaggedFile!<CR>
nnoremap <silent> <leader>fo     :FufJumpList<CR>
nnoremap <silent> <leader>fp     :FufChangeList<CR>
nnoremap <silent> <leader>fq     :FufQuickfix<CR>
nnoremap <silent> <leader>fy     :FufLine<CR>
nnoremap <silent> <leader>fh     :FufHelp<CR>
nnoremap <silent> <leader>fe     :FufEditDataFile<CR>
nnoremap <silent> <leader>fr     :FufRenewCache<CR>
" fuzzyfinder

" zencoding
"let g:user_zen_leader_key = '<c-e>'
" zencoding
" emmet
let g:user_emmet_leader_key = '<c-e>'
" emmet

" AutoComplPop
let g:acp_behaviorSnipmateLength = -1
nnoremap <silent> <leader>ad     :AcpDisable<CR>
nnoremap <silent> <leader>ae     :AcpEnable<CR>
nnoremap <silent> <leader>al     :AcpLock<CR>
nnoremap <silent> <leader>au     :AcpUnlock<CR>
" AutoComplPop

" delimitMate
"inoremap <silent> <C-Y> <Plug>delimitMateS-Tab
" delimitMate

" nerdtree
let NERDTreeWinPos = "right"
"nnoremap <silent> <F5> :NERDTreeToggle<CR>
" nerdtreetabs
nnoremap <silent> <F4> :NERDTreeFind<CR>
nnoremap <silent> <F5> :NERDTreeTabsToggle<CR>
nnoremap <silent> <F6> :NERDTreeMirrorToggle<CR>
let g:nerdtree_tabs_open_on_gui_startup = 0
" nerdtree

" powerline
"let g:Powerline_symbols = 'fancy'
"set rtp+=$VIM/vimfiles/bundle/powerline/powerline/bindings/vim
"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup
set laststatus=2
" powerline

" neocomplcache begin
" Disable AutoComplPop. Comment out this line if AutoComplPop is not installed.
let g:acp_enableAtStartup = 0
" Launches neocomplcache automatically on vim startup.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underscore completion.
let g:neocomplcache_enable_underbar_completion = 1
" Sets minimum char length of syntax keyword.
let g:neocomplcache_min_syntax_length = 3
" buffer file name pattern that locks neocomplcache. e.g. ku.vim or fuzzyfinder
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define file-type dependent dictionaries.
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
      \ }

" Define keyword, for minor languages
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion. Not required if they are already set elsewhere in .vimrc
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion, which require computational power and may stall the vim.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
" neocomplcache end

" completion setting
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
" completion setting

" neosnippet
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" neosnippet

" vim gitgutter
nmap <silent> ]h :<C-U>execute v:count1 . "GitGutterNextHunk"<CR>
nmap <silent> [h :<C-U>execute v:count1 . "GitGutterPrevHunk"<CR>
nmap <silent> <leader>gt :GitGutterToggle<CR>
" vim gitgutter

" tagbar
nmap <F8> :TagbarToggle<CR>
let g:tagbar_expand = 1
" tagbar

" EasyMotion
let g:EasyMotion_leader_key = '<Space>'
" EasyMotion

" C++ Syntax Support
au BufNewFile,BufRead *.cpp set syntax=cpp11
" C++ Syntax Support

" CamelCaseMotion
map ,mw <Plug>CamelCaseMotion_w
map ,mb <Plug>CamelCaseMotion_b
map ,me <Plug>CamelCaseMotion_e
" CamelCaseMotion

" vim-easy-align
vnoremap <silent> <CR> :EasyAlign<CR>
" vim-easy-align

" vim-ruby-xmpfilter
nmap <leader>rr <Plug>(xmpfilter-run)
xmap <leader>rr <Plug>(xmpfilter-run)
imap <leader>rr <Plug>(xmpfilter-run)

nmap <leader>rm <Plug>(xmpfilter-mark)
xmap <leader>rm <Plug>(xmpfilter-mark)
imap <leader>rm <Plug>(xmpfilter-mark)"
" vim-ruby-xmpfilter

" background toggle
nmap <leader>bg :let &background = ( &background == "dark" ? "light" : "dark" )<CR>
" background toggle

" vim-latex
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_ViewRule_pdf='D:/Program Files (x86)/SumatraPDF/SumatraPDF.exe'
let g:Tex_CompileRule_pdf = 'xelatex --synctex=-1 -src-specials -interaction=nonstopmode $*'
function CompileXeLaTeXAndView()
  call Tex_RunLaTeX()
  call Tex_ViewLaTeX()
endfunction
map <Leader>lx :<C-U>call CompileXeLaTeXAndView()<CR>
" vim-latex

" Gundo
nnoremap <F9> :GundoToggle<CR>
" Gundo

" colorv
nnoremap <silent> <leader>cN :ColorVName<CR>
" colorv

" VimShell
nnoremap <silent> <leader>vv :VimShell<CR>
nnoremap <silent> <leader>vc :VimShellCurrentDir<CR>
nnoremap <silent> <leader>vb :VimShellBufferDir<CR>
nnoremap <silent> <leader>vt :VimShellTab<CR>
" VimShell

" Unite
let g:unite_source_history_yank_enable = 1
" nnoremap <space>p :Unite file_rec/async<CR>
nnoremap <space>p :Unite file<CR>
nnoremap <space>P :Unite -start-insert file_rec<CR>
nnoremap <space>/ :Unite grep:.<CR>
nnoremap <space>? :Unite grep:.:-r<CR>
nnoremap <space>y :Unite history/yank<CR>
nnoremap <space>s :Unite -quick-match tab<CR>
nnoremap <space>S :Unite source<CR>
nnoremap <space>m :Unite file_mru<CR>
nnoremap <space>M :Unite -buffer-name=files -default-action=lcd directory_mru<CR>
" Unite

" Syntastic
let g:syntastic_ruby_checkers = ['mri', 'rubylint']
let g:syntastic_tex_checkers = ['lacheck']
" Syntastic

if has("balloon_eval")
  set noballooneval
endif
set directory=.,$TEMP
set nu
set autoindent
set hlsearch&
set ignorecase
set incsearch
set smartcase
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set expandtab
set shellslash
set grepprg=grep\ -nH\ $*
set t_Co=256
set wildmenu
set foldlevelstart=99
let $TMP="C:/tmp"
filetype on
filetype plugin on
filetype indent on
colorscheme torte

" Source the vimrc file after saving it
" autocmd bufwritepost _vimrc source $MYVIMRC
" autocmd bufwritepost _vimrc source $MYGVIMRC

" ru
augroup filetypedetect
  au! BufRead,BufNewFile *.ru setfiletype ruby
augroup END

" ruby
augroup ruby
  " avoid performance problem
  "au BufRead,BufNewFile *.rb set fdm=syntax
augroup END

nmap <F7> :call ToggleFoldBetweenManualAndSyntax()<CR>
function! ToggleFoldBetweenManualAndSyntax()
  if &foldmethod == 'manual'
    set foldmethod=syntax
  else
    set foldmethod=manual
  endif
endfunction

let g:lasttab = 1
nmap <M-1> :exe "tabn ".g:lasttab<CR>
set encoding=utf8 " make sure mapping is correct in UTF-8
nmap <M-1> :exe "tabn ".g:lasttab<CR>
set encoding=cp950
au TabLeave * let g:lasttab = tabpagenr()
