" Mappings
function! vimrc#jedi#mappings()
  nnoremap <silent><buffer> <C-X><C-L> :call jedi#remove_usages()<CR>
  nnoremap <silent><buffer> <C-X><C-N> :tab split <Bar> call jedi#goto()<CR>
endfunction
