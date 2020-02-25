" Mappings
function! vimrc#git_messenger#mappings()
  nnoremap <silent><buffer> <Leader>gc :call vimrc#git_messenger#goto_commit('Gsplit')<CR>
  nnoremap <silent><buffer> <Leader>gC :call vimrc#git_messenger#goto_commit('Gedit')<CR>
endfunction

" Functions
function! vimrc#git_messenger#goto_commit(split)
  let commit_sha = split(getline(3))[1]
  execute a:split.' '.commit_sha
endfunction
