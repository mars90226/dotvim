" Don't use :Vista! or :Vista!! to close Vista window.
" It will make :Vista coc not open Vista window.
nnoremap <F7>        :Vista<CR>
nnoremap <Space><F7> :Vista coc<CR>
nnoremap <Space>vq   :Vista focus<CR>:close<CR>
nnoremap <Space>vf   :Vista finder<CR>
nnoremap <Space>vc   :Vista finder coc<CR>
nnoremap <Space>vs   :Vista show<CR>
nnoremap <Space>vt   :Vista toc<CR>
nnoremap <Space>vv   :Vista focus<CR>
nnoremap <Space>vi   :Vista info<CR>
nnoremap <Space>vI   :Vista info+<CR>

let g:vista_sidebar_width = 40
let g:vista_fzf_preview = ['right:50%']

augroup vista_load_nearest_method_or_function
  autocmd!
  autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
augroup END

augroup vista_settings
  autocmd!
  autocmd FileType vista call vimrc#vista#mappings()
augroup END
