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
Plug 'honza/vim-snippets'

" tmux-complete.vim {{{
if executable('tmux')
  Plug 'wellle/tmux-complete.vim'
endif
" }}}
" }}}

" Auto Pairs {{{
" auto-pairs {{{
if vimrc#plugin#is_enabled_plugin('auto-pairs')
  Plug 'jiangmiao/auto-pairs'

  call vimrc#source('vimrc/plugins/auto_pairs.vim')
endif
" }}}
" }}}
