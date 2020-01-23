" VimShell {{{
if vimrc#plugin#is_enabled_plugin('vimshell.vim')
  Plug 'Shougo/vimshell.vim', { 'on': ['VimShell', 'VimShellCurrentDir', 'VimShellBufferDir', 'VimShellTab'] }

  nnoremap <silent> <Leader>vv :VimShell<CR>
  nnoremap <silent> <Leader>vc :VimShellCurrentDir<CR>
  nnoremap <silent> <Leader>vb :VimShellBufferDir<CR>
  nnoremap <silent> <Leader>vt :VimShellTab<CR>
endif
" }}}

" deol.nvim {{{
if vimrc#plugin#is_enabled_plugin('deol.nvim')
  Plug 'Shougo/deol.nvim'
endif
" }}}

" neoterm {{{
if vimrc#plugin#is_enabled_plugin('neoterm')
  Plug 'kassio/neoterm', { 'on': [] }

  call vimrc#source('vimrc/plugins/neoterm.vim')
endif
" }}}
