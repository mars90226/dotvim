" For vim-tig

" Functions
function! vimrc#tig#log(opts, bang, is_current_file)
  execute 'Tig log ' . (a:bang ? '-p ' : '') . a:opts . (a:is_current_file ? ' -- ' . expand('%:p') : '')
endfunction
