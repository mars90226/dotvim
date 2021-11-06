" Don't use :Vista!! to toggle Vista window.
" It will use :Vista not :Vista coc.
nnoremap <F7>        :Vista<CR>
nnoremap <Space>vq   :Vista!<CR>
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
elseif vimrc#plugin#is_enabled_plugin('nvim-lsp')
  nnoremap <Space><F7> :Vista nvim_lsp<CR>
  nnoremap <Space>vc   :Vista finder nvim_lsp<CR>
  nnoremap <Space>vk   :call vimrc#vista#finder_with_query('Vista finder nvim_lsp', expand('<cword>'))<CR>
  nnoremap <Space>vK   :call vimrc#vista#finder_with_query('Vista finder nvim_lsp', expand('<cword>'))<CR>
endif

let g:vista_sidebar_width = g:right_sidebar_width
let g:vista_fzf_preview = ['right:50%']

if vimrc#plugin#is_disabled_plugin('lualine.nvim')
  " Disabled in lualine.nvim, so only load when lualine.nvim is disabled
  augroup vista_load_nearest_method_or_function
    autocmd!
    autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
  augroup END
endif

augroup vista_settings
  autocmd!
  autocmd FileType vista call vimrc#vista#mappings()
augroup END
