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
nnorema <Space>ca     :Clap loclist<CR>
nnorema <Space>cb     :Clap buffers<CR>
nnorema <Space>cc     :Clap bcommits<CR>
nnorema <Space>cC     :Clap commits<CR>
nnorema <Space>cd     :Clap git_diff_files<CR>
nnorema <Space>cf     :Clap files<CR>
nnorema <Space>cg     :Clap git_files<CR>
nnorema <Space>ch     :Clap help_tags<CR>
nnorema <Space>cl     :Clap blines<CR>
nnorema <Space>cL     :Clap lines<CR>
nnorema <Space>cj     :Clap jumps<CR>
nnorema <Space>cm     :Clap history<CR>
nnorema <Space>cp     :Clap providers<CR>
nnorema <Space>cq     :Clap quickfix<CR>
nnorema <Space>cr     :Clap grep<CR>
nnorema <Space>ct     :Clap tags<CR>
nnorema <Space>cv     :Clap colors<CR>
nnorema <Space>cw     :Clap windows<CR>
nnorema <Space>cy     :Clap yanks<CR>
nnorema <Space>c'     :Clap registers<CR>
nnorema <Space>c`     :Clap marks<CR>
nnorema <Space>c:     :Clap command<CR>
nnorema <Space>c;     :Clap command_history<CR>
nnorema <Space>c/     :Clap search_history<CR>
nnorema <Space>c<Tab> :Clap maps<CR>
" }}}

" Clap buffer key mappings {{{
augroup clap_mappings
  autocmd!
  autocmd FileType clap_input call vimrc#clap#settings()
  autocmd FileType clap_input call vimrc#clap#mappings()
augroup END
" }}}
