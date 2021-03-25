" Utility functions
function! vimrc#git#include_git_mappings(get_commit_sha_function_call, ...) abort
  let get_commit_sha_of_current_line_function_call = a:0 > 0 && type(a:1) == type('') ? a:1 : ''

  execute 'nnoremap <silent><buffer> <Leader>gd :call vimrc#fzf#git#diff_commit('.a:get_commit_sha_function_call.')<CR>'

  if !empty(get_commit_sha_of_current_line_function_call)
    execute 'xnoremap <silent><buffer> <Leader>gd :<C-U>call '.get_commit_sha_of_current_line_function_call.'<CR>'
  endif

  execute 'nnoremap <silent><buffer> <Leader>gf :call vimrc#fzf#git#files_commit('.a:get_commit_sha_function_call.')<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gg :call vimrc#fzf#git#grep_commit('.a:get_commit_sha_function_call.', input("Git grep: "))<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gt :execute "Git show --stat ".'.a:get_commit_sha_function_call.'<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gp :execute "Git cherry-pick -n ".'.a:get_commit_sha_function_call.'<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gP :execute "Git cherry-pick ".'.a:get_commit_sha_function_call.'<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gob :execute "Git branch --contains ".'.a:get_commit_sha_function_call.'<CR>'
  execute 'nnoremap <silent><buffer> <Leader>got :execute "Git tag --contains ".'.a:get_commit_sha_function_call.'<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gT :execute "Gtabedit ".'.a:get_commit_sha_function_call.'<CR>'
  if vimrc#plugin#is_enabled_plugin('vim-floaterm')
    execute 'nnoremap <silent><buffer> <Leader>df :execute "FloatermNew git diff ".'.a:get_commit_sha_function_call.'."^!"<CR>'
  endif

  " Command line mapping
  execute 'cnoremap <buffer><expr> <C-G><C-S> '.a:get_commit_sha_function_call
endfunction

function! vimrc#git#get_email() abort
  return systemlist('git config --get user.email')[0]
endfunction

function! vimrc#git#root() abort
  return systemlist('git rev-parse --show-toplevel')[0]
endfunction
