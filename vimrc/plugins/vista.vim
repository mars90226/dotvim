" Don't use :Vista! or :Vista!! to close Vista window.
" It will make :Vista coc not open Vista window.
nnoremap <F7>        :Vista<CR>
nnoremap <Space>vq   :Vista focus<CR>:close<CR>
nnoremap <Space>vf   :Vista finder<CR>
nnoremap <Space>vl   :call vimrc#vista#finder_with_query('Vista finder', expand('<cword>'))<CR>
nnoremap <Space>vL   :call vimrc#vista#finder_with_query('Vista finder', expand('<cWORD>'))<CR>
nnoremap <Space>vs   :Vista show<CR>
nnoremap <Space>vt   :Vista toc<CR>
nnoremap <Space>vv   :Vista focus<CR>
nnoremap <Space>vi   :Vista info<CR>
nnoremap <Space>vI   :Vista info+<CR>

if vimrc#plugin#is_enabled_plugin('coc.nvim')
  nnoremap <Space><F7> :Vista coc<CR>
  nnoremap <Space>vc   :Vista finder coc<CR>
  nnoremap <Space>vk   :call vimrc#vista#finder_with_query('Vista finder coc', expand('<cword>'))<CR>
  nnoremap <Space>vK   :call vimrc#vista#finder_with_query('Vista finder coc', expand('<cword>'))<CR>
endif

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
