" Lazy load
call vimrc#lazy#lazy_load('clap')

" Clap settings
let g:clap_layout = {
      \ 'relative': 'editor',
      \ 'width': '90%',
      \ 'height': '80%',
      \ 'row': '10%',
      \ 'col': '5%'
      \ }

let g:clap_theme = 'atom_dark'

" Clap key mappings {{{
nnoremap <Space>ca     :Clap loclist<CR>
nnoremap <Space>cb     :Clap buffers<CR>
nnoremap <Space>cc     :Clap bcommits<CR>
nnoremap <Space>cC     :Clap commits<CR>
nnoremap <Space>cd     :Clap git_diff_files<CR>
nnoremap <Space>cf     :Clap files<CR>
nnoremap <Space>cg     :Clap git_files<CR>
nnoremap <Space>ch     :Clap help_tags<CR>
nnoremap <Space>ci     :Clap filer<CR>
nnoremap <Space>cj     :Clap jumps<CR>
nnoremap <Space>ck     :execute 'Clap grep ++query='.expand('<cword>')<CR>
nnoremap <Space>cK     :execute 'Clap grep ++query='.expand('<cWORD>')<CR>
nnoremap <Space>cl     :Clap blines<CR>
nnoremap <Space>cL     :Clap lines<CR>
nnoremap <Space>cm     :Clap history<CR>
nnoremap <Space>cp     :Clap providers<CR>
nnoremap <Space>cq     :Clap quickfix<CR>
nnoremap <Space>cr     :execute 'Clap grep2 ++query='.input('grep2: ')<CR>
nnoremap <Space>cR     :execute 'Clap grep ++query='.input('grep: ')<CR>
" FIXME: Not work, cannot use option that need argument
nnoremap <Space>c4     :execute 'Clap grep ++opt='.vimrc#utility#commandline_escape_symbol(input('Option: ')).' ++query='.input('grep: ')<CR>
nnoremap <Space>ct     :Clap tags<CR>
nnoremap <Space>cv     :Clap colors<CR>
nnoremap <Space>cw     :Clap windows<CR>
nnoremap <Space>cy     :Clap yanks<CR>
nnoremap <Space>c'     :Clap registers<CR>
nnoremap <Space>c`     :Clap marks<CR>
nnoremap <Space>c:     :Clap command_history<CR>
nnoremap <Space>c;     :Clap command<CR>
nnoremap <Space>c/     :Clap search_history<CR>
nnoremap <Space>c<Tab> :Clap maps<CR>

if vimrc#plugin#is_enabled_plugin('coc.nvim')
  nnoremap <Space>cT     :Clap tags coc<CR>
endif
" }}}

" Clap buffer key mappings {{{
augroup clap_mappings
  autocmd!
  autocmd FileType clap_input call vimrc#clap#settings()
  autocmd FileType clap_input call vimrc#clap#mappings()
augroup END
" }}}
