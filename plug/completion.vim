" completion setting {{{
inoremap <expr> <CR>       pumvisible() ? "\<C-Y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-N>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-P>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-P>\<C-N>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-P>\<C-N>" : "\<PageUp>"
inoremap <expr> <Tab>      pumvisible() ? "\<C-N>" : "\<Tab>"
inoremap <expr> <S-Tab>    pumvisible() ? "\<C-P>" : "\<S-Tab>"

" mapping for decrease number
nnoremap <C-X><C-X> <C-X>
" }}}

" Completion {{{
" coc.nvim {{{
if vimrc#plugin#is_enabled_plugin('coc.nvim')
  Plug 'Shougo/neco-vim'
  Plug 'neoclide/coc-neco'
  Plug 'neoclide/coc.nvim', { 'branch': 'release', 'do': { -> coc#util#install() } }
  Plug 'neoclide/coc-denite'
  Plug 'antoinemadec/coc-fzf'

  call vimrc#source('vimrc/plugins/coc.vim')
endif
" }}}

" completor.vim {{{
if vimrc#plugin#is_enabled_plugin('completor.vim')
  Plug 'maralla/completor.vim'
  Plug 'maralla/completor-neosnippet'

  call vimrc#source('vimrc/plugins/completor.vim')
endif
" }}}

" nvim-lsp {{{
if vimrc#plugin#is_enabled_plugin('nvim-lsp')
  Plug 'neovim/nvim-lsp'
  Plug 'neovim/nvim-lspconfig'
  Plug 'kabouzeid/nvim-lspinstall'

  call vimrc#source('vimrc/plugins/nvim_lsp.vim')
endif
" }}}
" }}}

" Completion Source {{{
" neosnippet {{{
" Plug 'Shougo/neosnippet.vim'
" Plug 'Shougo/neosnippet-snippets'
" NOTE: Use coc-snippets
Plug 'honza/vim-snippets'

" let g:neosnippet#snippets_directory = [
"       \ vimrc#get_vim_plug_dir().'/neosnippet-snippets/neosnippets',
"       \ vimrc#get_vim_plug_dir().'/vim-snippets/snippets',
"       \ vimrc#get_vimhome().'/my-snippets',
"       \ $HOME.'/.vim_secret/my-snippets'
"       \ ]
"
" " Plugin key-mappings.
" " <C-J>: expand or jump or select completion
" imap <silent><expr> <C-J>
"       \ pumvisible() && !neosnippet#expandable_or_jumpable() ?
"       \ "\<C-Y>" :
"       \ "\<Plug>(neosnippet_expand_or_jump)"
" smap <C-J> <Plug>(neosnippet_expand_or_jump)
" xmap <C-J> <Plug>(neosnippet_expand_target)
"
" " For snippet_complete marker.
" if has('conceal')
"   set conceallevel=2 concealcursor=i
" endif
"
" " Enable snipMate compatibility feature.
" let g:neosnippet#enable_snipmate_compatibility = 1
"
" augroup neosnippet_settings
"   autocmd!
"   autocmd BufNewFile,BufReadPost *.snip setlocal filetype=neosnippet
" augroup END
" }}}

" tmux-complete.vim {{{
if executable('tmux')
  Plug 'wellle/tmux-complete.vim'
endif
" }}}
" }}}
