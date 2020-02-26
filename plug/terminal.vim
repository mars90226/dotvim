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

" vim-floaterm {{{
if vimrc#plugin#is_enabled_plugin('vim-floaterm')
  Plug 'voldikss/vim-floaterm'

  let g:floaterm_position = 'center'

  nnoremap <silent> <M-2> :FloatermToggle<CR>
  nnoremap <silent> <M-3> :FloatermPrev<CR>
  nnoremap <silent> <M-4> :FloatermNext<CR>
  nnoremap <silent> <M-5> :FloatermNew<CR>

  tnoremap <M-2> <C-\><C-N>:FloatermToggle<CR>
  tnoremap <M-3> <C-\><C-N>:FloatermPrev<CR>
  tnoremap <M-4> <C-\><C-N>:FloatermNext<CR>
  tnoremap <M-5> <C-\><C-N>:FloatermNew<CR>

  " For nested neovim
  tnoremap <M-q><M-2> <C-\><C-\><C-N>:FloatermToggle<CR>
  tnoremap <M-q><M-3> <C-\><C-\><C-N>:FloatermPrev<CR>
  tnoremap <M-q><M-4> <C-\><C-\><C-N>:FloatermNext<CR>
  tnoremap <M-q><M-5> <C-\><C-\><C-N>:FloatermNew<CR>

  " For nested nested neovim
  call vimrc#terminal#nested_neovim#register("\<M-2>", ":FloatermToggle\<CR>")
  call vimrc#terminal#nested_neovim#register("\<M-3>", ":FloatermPrev\<CR>")
  call vimrc#terminal#nested_neovim#register("\<M-4>", ":FloatermNext\<CR>")
  call vimrc#terminal#nested_neovim#register("\<M-5>", ":FloatermNew\<CR>")
endif
" }}}
