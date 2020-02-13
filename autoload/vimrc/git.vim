" Utility functions
function! vimrc#git#include_git_mappings(get_commit_sha_function_call)
  execute 'nnoremap <silent><buffer> <Leader>gd :call vimrc#fzf#git#diff_commit('.a:get_commit_sha_function_call.')<CR>'
  xnoremap <silent><buffer> <Leader>gd :<C-U>call vimrc#gv#visual_diff_commits()<CR>
  execute 'nnoremap <silent><buffer> <Leader>gf :call vimrc#fzf#git#files_commit('.a:get_commit_sha_function_call.')<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gg :call vimrc#fzf#git#grep_commit('.a:get_commit_sha_function_call.', input("Git grep: "))<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gt :execute "Git show --stat ".'.a:get_commit_sha_function_call.'<CR>'

  " Command line mapping
  execute 'cnoremap <buffer><expr> <C-G><C-S> '.a:get_commit_sha_function_call
endfunction
