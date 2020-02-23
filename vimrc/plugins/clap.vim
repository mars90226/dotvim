" Clap settings
let g:clap_layout = {
      \ 'relative': 'editor',
      \ 'width': '90%',
      \ 'height': '60%',
      \ 'row': '20%',
      \ 'col': '5%'
      \ }

let g:clap_theme = 'atom_dark'

" Clap key mappings {{{
nnorema <Space>cp :Clap files<CR>
nnorema <Space>cj :Clap jumps<CR>
" }}}

" Clap buffer key mappings {{{
augroup clap_mappings
  autocmd!
  autocmd FileType clap_input call vimrc#clap#mappings()
augroup END
" }}}
