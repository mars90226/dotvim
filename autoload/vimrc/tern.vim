" Mappings
function! vimrc#tern#mappings() abort
  nnoremap <silent><buffer> <C-X><C-K> :TernDoc<CR>
  nnoremap <silent><buffer> <C-X><C-B> :TernDocBrowse<CR>
  nnoremap <silent><buffer> <C-X><C-T> :TernType<CR>
  " To avoid accidentally delete
  nnoremap <silent><buffer> <C-X><C-D> :TernDef<CR>
  nnoremap <silent><buffer> <C-X><C-P> :TernDefPreview<CR>
  nnoremap <silent><buffer> <C-X><C-S> :TernDefSplit<CR>
  nnoremap <silent><buffer> <C-X><C-N> :TernDefTab<CR>
  nnoremap <silent><buffer> <C-X>c :TernRefs<CR>
  nnoremap <silent><buffer> <C-X><C-R> :TernRename<CR>
endfunction
