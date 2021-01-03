" Settings
function! vimrc#merginal#settings() abort
  nnoremap <silent><buffer> cb :call vimrc#merginal#checkout_branch(expand('<cWORD>'))<CR>
endfunction

" Functions
" checkout branch with remote branch support
function! vimrc#merginal#checkout_branch(branch) abort
  let branch = a:branch
  if branch =~# '^remotes/'
    let branch = substitute(branch, '\v^remotes/[^/]+/', '', '')
  endif

  execute 'Git checkout '.branch
endfunction
