" netrw {{{
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro' " add line number
" }}}

" vim-vinegar {{{
Plug 'tpope/vim-vinegar'

nmap <silent> \-       <Plug>VinegarUp
nmap <silent> _        <Plug>VinegarVerticalSplitUp
nmap <silent> <Space>- <Plug>VinegarSplitUp
nmap <silent> <Space>_ <Plug>VinegarTabUp

augroup vinegar_settings
  autocmd!
  autocmd FileType netrw call vimrc#vinegar#mappings()
augroup END
" }}}

" vimfiler {{{
if vimrc#plugin#is_enabled_plugin('vimfiler')
  Plug 'Shougo/vimfiler.vim'
  Plug 'Shougo/neossh.vim'

  call vimrc#source('vimrc/plugins/vimfiler.vim')
endif
" }}}

" defx.nvim {{{
if vimrc#plugin#is_enabled_plugin('defx.nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'kristijanhusak/defx-git'
  " Font not supported
  " Plug 'kristijanhusak/defx-icons'

  call vimrc#source('vimrc/plugins/defx.vim')
endif
" }}}

" nvim-tree.lua {{{
if vimrc#plugin#is_enabled_plugin('nvim-tree.lua')
  Plug 'kyazdani42/nvim-tree.lua'

  call vimrc#source('vimrc/plugins/nvim_tree_lua.vim')
endif
" }}}

" dirvish.vim {{{
if vimrc#plugin#is_enabled_plugin('dirvish.vim')
  Plug 'justinmk/vim-dirvish'

  call vimrc#source('vimrc/plugins/dirvish.vim')
endif
" }}}
