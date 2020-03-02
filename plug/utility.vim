" vim-mundo {{{
if vimrc#plugin#is_enabled_plugin('vim-mundo')
  Plug 'simnalamburt/vim-mundo', { 'on': 'MundoToggle' }

  if has('python3')
    let g:mundo_prefer_python3 = 1
  endif

  nnoremap <F9> :MundoToggle<CR>
endif
" }}}

" vim-unimpaired {{{
Plug 'tpope/vim-unimpaired', { 'on': [] }

call vimrc#lazy#lazy_load('unimpaired')

" Ignore [a, ]a, [A, ]A for ale
let g:nremap = {'[a': '', ']a': '', '[A': '', ']A': ''}

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

nnoremap <silent> <Leader>vv :ColorV<CR>
nnoremap <silent> <Leader>vn :ColorVName<CR>
" }}}

" vim-rooter {{{
Plug 'airblade/vim-rooter', { 'on': 'Rooter' }

let g:rooter_manual_only = 1
let g:rooter_use_lcd = 1
let g:rooter_patterns = ['Cargo.toml', '.git/', 'package.json']
nnoremap <Leader>r :Rooter<CR>
" }}}

" vimwiki {{{
Plug 'vimwiki/vimwiki'

augroup vimwiki_settings
  autocmd!
  autocmd FileType vimwiki call vimrc#vimwiki#mappings()
augroup END
" }}}

" orgmode {{{
Plug 'jceb/vim-orgmode'
" }}}

" vimoutliner {{{
Plug 'vimoutliner/vimoutliner'
" }}}

" indentLine {{{
Plug 'Yggdroot/indentLine', { 'on': ['IndentLinesEnable', 'IndentLinesToggle'] }

let g:indentLine_enabled = 0
let g:indentLine_color_term = 243
let g:indentLine_color_gui = '#AAAAAA'

nnoremap <Space>il :IndentLinesToggle<CR>
nnoremap <Space>iL :call vimrc#indent_line#toggle_enabled()<CR>

augroup indent_line_syntax
  autocmd!
  autocmd User indentLine doautocmd indentLine Syntax
augroup END
" }}}

" AnsiEsc.vim {{{
Plug 'powerman/vim-plugin-AnsiEsc', { 'on': 'AnsiEsc' }

nnoremap coa :AnsiEsc<CR>
" }}}

" vim-lastplace {{{
Plug 'farmergreg/vim-lastplace'

let g:lastplace_ignore = 'gitcommit,gitrebase,sv,hgcommit'
let g:lastplace_ignore_buftype = 'quickfix,nofile,help,terminal'
let g:lastplace_open_folds = 0
" }}}

" vim-localvimrc {{{
Plug 'embear/vim-localvimrc'

" Be careful of malicious localvimrc
let g:localvimrc_sandbox = 0
let g:localvimrc_whitelist = [$HOME.'/.tmux']
if exists('g:localvimrc_secret_whitelist')
  let g:localvimrc_whitelist += g:localvimrc_secret_whitelist
endif
" }}}

" vim-qfreplace {{{
Plug 'thinca/vim-qfreplace'

augroup qfreplace_settings
  autocmd!
  autocmd FileType qf call vimrc#qfreplace#mappings()
augroup END
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

nnoremap <Leader>do :Copen<CR>
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

" context.vim {{{
Plug 'wellle/context.vim'

let g:context_enabled = 0

nnoremap <F6> :ContextToggle<CR>
" }}}

" vim-visual-multi {{{
Plug 'mg979/vim-visual-multi'

" imap <BS> & <CR> is overwritten, need to be careful of bugs
" FIXME Cannot use sandwich command
" }}}

" firenvim {{{
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" }}}

" Colorizer {{{
Plug 'chrisbra/Colorizer'

let g:colorizer_auto_filetype = 'css,html'
let g:colorizer_disable_bufleave = 1

nnoremap <Leader>vt :ColorToggle<CR>
nnoremap <Leader>vc :ColorClear<CR>
" }}}

Plug 'tpope/vim-dadbod', { 'on': 'DB' }
Plug 'tpope/vim-abolish', { 'on': ['Abolish', 'Subvert', 'S'] }
Plug 'will133/vim-dirdiff', { 'on': 'DirDiff' }
Plug 'AndrewRadev/linediff.vim', { 'on': 'Linediff' }
" Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/vinarise.vim', { 'on': 'Vinarise' }
Plug 'alx741/vinfo', { 'on': 'Vinfo' }
Plug 'mattn/webapi-vim'
Plug 'kana/vim-arpeggio'
Plug 'kopischke/vim-fetch'
Plug 'Valloric/ListToggle'
Plug 'tpope/vim-eunuch'
Plug 'DougBeney/pickachu', { 'on': 'Pick' }
Plug 'tweekmonster/helpful.vim', { 'on': 'HelpfulVersion' }
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
Plug 'gyim/vim-boxdraw'

" " nvim-gdb {{{
" Disabled for now as neovim's neovim_gdb.vim seems not exists
" if has("nvim")
"   Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
" endif
" " }}}
