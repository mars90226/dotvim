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
