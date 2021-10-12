" deol.nvim {{{
if vimrc#plugin#is_enabled_plugin('deol.nvim')
  Plug 'Shougo/deol.nvim'
endif
" }}}

" neoterm {{{
if vimrc#plugin#is_enabled_plugin('neoterm')
  Plug 'kassio/neoterm', { 'on': [] }

  call vimrc#lazy#lazy_load('neoterm')

  call vimrc#source('vimrc/plugins/neoterm.vim')
endif
" }}}

" vim-floaterm {{{
if vimrc#plugin#is_enabled_plugin('vim-floaterm')
  Plug 'voldikss/vim-floaterm'
  Plug 'voldikss/fzf-floaterm'

  call vimrc#source('vimrc/plugins/floaterm.vim')
endif
" }}}
