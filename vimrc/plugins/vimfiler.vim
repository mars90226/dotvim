if vimrc#plugin#is_enabled_plugin('lightline.vim')
  let g:vimfiler_force_overwrite_statusline = 0
endif

let g:vimfiler_as_default_explorer = 1
nnoremap <F4> :VimFilerExplorer -split -simple -parent -winwidth=35 -toggle -no-quit<CR>
nnoremap <Space><F4> :VimFilerExplorer -split -simple -parent -winwidth=35 -toggle -no-quit -find<CR>

augroup vimfiler_mappings
  autocmd!
  autocmd FileType vimfiler call vimrc#vimfiler#mappings()
augroup END
