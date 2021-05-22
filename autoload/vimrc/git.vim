" Utility functions
function! vimrc#git#include_git_mappings(git_type, ...) abort
  let has_visual_shas = a:0 > 0 && type(a:1) == type(v:true) ? a:1 : v:false
  let git_module = 'vimrc#git#'.a:git_type
  let git_sha_fn = git_module.'#sha()'
  let git_visual_shas_fn = git_module.'#visual_shas()'

  execute 'nnoremap <silent><buffer> <Leader>gd :call vimrc#fzf#git#diff_commit('.git_sha_fn.')<CR>'
  if has_visual_shas
    execute 'xnoremap <silent><buffer> <Leader>gd :<C-U>call vimrc#git#visual_diff_commits('.git_visual_shas_fn.')<CR>'
  endif
  execute 'nnoremap <silent><buffer> <Leader>gf :call vimrc#fzf#git#files_commit('.git_sha_fn.')<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gg :call vimrc#fzf#git#grep_commit('.git_sha_fn.', input("Git grep: "))<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gt :execute "Git show --stat ".'.git_sha_fn.'<CR>'
  if has_visual_shas
    execute 'xnoremap <silent><buffer> <Leader>gt :<C-U>execute "Git diff --stat ".vimrc#git#expand_commits('.git_visual_shas_fn.')<CR>'
  endif
  execute 'nnoremap <silent><buffer> <Leader>gp :execute "Git cherry-pick -n ".'.git_sha_fn.'<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gP :execute "Git cherry-pick ".'.git_sha_fn.'<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gob :execute "Git branch --contains ".'.git_sha_fn.'<CR>'
  execute 'nnoremap <silent><buffer> <Leader>got :execute "Git tag --contains ".'.git_sha_fn.'<CR>'
  execute 'nnoremap <silent><buffer> <Leader>gT :execute "Gtabedit ".'.git_sha_fn.'<CR>'
  execute 'nnoremap <silent><buffer> <Leader>ga :execute "Git tag ".input("Git tag: ")." ".'.git_sha_fn.'<CR>'

  if vimrc#plugin#is_enabled_plugin('vim-floaterm')
    execute 'nnoremap <silent><buffer> <Leader>df :execute "FloatermNew git diff ".'.git_sha_fn.'."^!"<CR>'
  endif

  if vimrc#plugin#is_enabled_plugin('diffview.nvim')
    execute 'nnoremap <buffer> <Leader>dv :DiffviewOpen <C-R>=vimrc#git#expand_commits('.git_sha_fn.')<CR>^!<CR>'
    execute 'nnoremap <buffer> <Leader>dV :DiffviewOpen <C-R>=vimrc#git#expand_commits('.git_sha_fn.')<CR>^!'

    if has_visual_shas
      execute 'xnoremap <buffer> <Leader>dv :<C-U>DiffviewOpen <C-R>=vimrc#git#expand_commits('.git_visual_shas_fn.')<CR><CR>'
      execute 'xnoremap <buffer> <Leader>dV :<C-U>DiffviewOpen <C-R>=vimrc#git#expand_commits('.git_visual_shas_fn.')<CR>'
    endif
  endif

  " Command line mapping
  execute 'cnoremap <buffer><expr> <C-G><C-S> '.git_sha_fn
endfunction

function! vimrc#git#get_email() abort
  return systemlist('git config --get user.email')[0]
endfunction

function! vimrc#git#root() abort
  return systemlist('git rev-parse --show-toplevel')[0]
endfunction

function! vimrc#git#visual_diff_commits(commits) abort
  let [start_commit, end_commit] = a:commits

  call vimrc#fzf#git#diff_commits(start_commit, end_commit)
endfunction

" Handle both commit and commits
function! vimrc#git#expand_commits(commits) abort
  if type(a:commits) == type('')
    return a:commits
  end

  let [start_commit, end_commit] = a:commits

  return start_commit.'..'.end_commit
endfunction
