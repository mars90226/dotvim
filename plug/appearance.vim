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

" indentLine {{{
Plug 'Yggdroot/indentLine', { 'on': ['IndentLinesEnable', 'IndentLinesToggle'] }

let g:indentLine_enabled = 0
let g:indentLine_color_term = 243
let g:indentLine_color_gui = '#AAAAAA'

function! s:toggle_indentline_enabled()
  if g:indentLine_enabled == 0
    let g:indentLine_enabled = 1
  else
    let g:indentLine_enabled = 0
  endif
endfunction

nnoremap <Space>il :IndentLinesToggle<CR>
nnoremap <Space>iL :call <SID>toggle_indentline_enabled()<CR>

augroup indent_line_syntax
  autocmd!
  autocmd User indentLine doautocmd indentLine Syntax
augroup END
" }}}

" vim-devicons {{{
" Disable for now as Fira Code nerd fonts is not patched
Plug 'ryanoasis/vim-devicons', { 'for': [] }
" }}}

" Colors {{{
Plug 'morhetz/gruvbox'

" Disabled as not used
Plug 'junegunn/seoul256.vim', { 'for': [] }
Plug 'chriskempson/base16-vim', { 'for': [] }
Plug 'altercation/vim-colors-solarized', { 'for': [] }
" }}}
