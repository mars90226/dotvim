" Here is the place for config/script to use plugin autoload functions
" TODO Move all plugin settings to post-loaded settings

" coc.nvim {{{
if vimrc#plugin#is_enabled_plugin('coc.nvim')
  call vimrc#source('vimrc/plugins/coc_after.vim')
endif
" }}}

" deoplete.nvim {{{
if vimrc#plugin#is_enabled_plugin('deoplete.nvim')
  " Use smartcase.
  call deoplete#custom#option('smart_case', v:true)
endif
" }}}

" nvim-lsp {{{
if vimrc#plugin#is_enabled_plugin('nvim-lsp')
  call vimrc#source('vimrc/plugins/nvim_lsp_after.vim')
endif
" }}}

" Unite {{{
augroup post_loaded_unite_mappings
  autocmd!
  autocmd VimEnter * call vimrc#unite#post_loaded_mappings()
augroup END
" }}}

" Denite {{{
if vimrc#plugin#is_enabled_plugin('denite.nvim')
  call vimrc#source('vimrc/plugins/denite_after.vim')
endif
" }}}

" Defx {{{
if vimrc#plugin#is_enabled_plugin('defx.nvim')
  call vimrc#source('vimrc/plugins/defx_after.vim')
endif
" }}}

" vim-sandwich {{{
call vimrc#source('vimrc/plugins/sandwich_after.vim')
" }}}

" vim-textobj-user {{{
call vimrc#source('vimrc/plugins/textobj_user_after.vim')
" }}}

" fuzzymenu {{{
call vimrc#source('vimrc/plugins/fuzzymenu_after.vim')
" }}}

" arpeggio {{{
call arpeggio#load()

" Quickly escape insert mode
Arpeggio inoremap jk <Esc>
" }}}
