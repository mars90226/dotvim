" Status Line {{{
" vim-airline {{{
if vimrc#plugin#is_enabled_plugin('vim-airline')
  call vimrc#source('plug/plugins/airline.vim')

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

" lualine.nvim {{{
if vimrc#plugin#is_enabled_plugin('lualine.nvim')
  Plug 'nvim-lualine/lualine.nvim'
endif
" }}}
" }}}

" Tabline {{{
" tabby.nvim {{{
if vimrc#plugin#is_enabled_plugin('tabby.nvim')
  Plug 'nanozuki/tabby.nvim'
endif
" }}}

" luatab.nvim {{{
if vimrc#plugin#is_enabled_plugin('luatab.nvim')
  Plug 'alvarosevilla95/luatab.nvim'

  set tabline=%!v:lua.require'luatab'.tabline()
endif
" }}}

" tabline.nvim {{{
if vimrc#plugin#is_enabled_plugin('tabline.nvim')
  Plug 'kdheepak/tabline.nvim'

  set guioptions-=e " Use showtabline in gui vim
  set sessionoptions+=tabpages,globals " store tabpages and globals in session
endif
" }}}

" barbar.nvim {{{
if vimrc#plugin#is_enabled_plugin('barbar.nvim')
  Plug 'romgrk/barbar.nvim'

  " Move to previous/next
  nnoremap <silent> <C-J> :BufferPrevious<CR>
  nnoremap <silent> <C-K> :BufferNext<CR>

  " Re-order to previous/next
  nnoremap <silent> <Leader>t< :BufferMovePrevious<CR>
  nnoremap <silent> <Leader>t> :BufferMoveNext<CR>

  " Goto buffer in position
  nnoremap <silent> g4 :BufferLast<CR>
endif
" }}}

" Other tabline plugins are built in statusline plugin.
" }}}

" Devicons {{{
" vim-devicons {{{
" NOTE: Should be loaded as the very last one
" }}}

" nvim-web-devicons {{{
if vimrc#plugin#is_enabled_plugin('nvim-web-devicons')
  Plug 'kyazdani42/nvim-web-devicons'
endif
" }}}
" }}}

" Colors {{{
if vimrc#plugin#is_enabled_plugin('nvim-treesitter')
  Plug 'rktjmp/lush.nvim'
  Plug 'ellisonleao/gruvbox.nvim'

  " FIXME: lightline print error log when loading, but it's works now.
  " It's loading issue that lightline load colorschem before gruvbox.nvim load
  " lua and setup lightline support.
else
  " TODO morhetz/gruvbox seems not updated for a while, use gruvbox-community/gruvbox
  Plug 'morhetz/gruvbox'
  " TODO disabled as it change color of floating and fzf prompt
  " Plug 'gruvbox-community/gruvbox'
endif

" Disabled as not used
Plug 'junegunn/seoul256.vim', { 'for': [] }
Plug 'chriskempson/base16-vim', { 'for': [] }
Plug 'altercation/vim-colors-solarized', { 'for': [] }
" }}}
