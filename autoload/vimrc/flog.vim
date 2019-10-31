" Mappings
function! vimrc#flog#mappings()
  nnoremap <silent><buffer> <Leader>gd :call vimrc#fzf#git#diff_commit(vimrc#flog#sha())<CR>
  nnoremap <silent><buffer> <Leader>gf :call vimrc#fzf#git#files_commit(vimrc#flog#sha())<CR>
  nnoremap <silent><buffer> <Leader>gg :call vimrc#fzf#git#grep_commit(vimrc#flog#sha(), input('Git grep: '))<CR>
endfunction

" Functions
function! vimrc#flog#sha()
  return flog#get_commit_data(line('.')).short_commit_hash
endfunction
