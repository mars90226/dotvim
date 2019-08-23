let s:git_diff_tree_command = 'git diff-tree --no-commit-id --name-only -r '

" vimrc#fzf#git#diff_tree([bang], [commit], [folder])
function! vimrc#fzf#git#diff_tree(...)
  if a:0 > 3
    return vimrc#warn('Invalid argument number')
  endif

  let bang   = a:0 >= 1 ? a:1 : 0
  let commit = a:0 >= 2 ? a:2 : 'HEAD'
  let folder = a:0 == 3 ? a:3 : ''

  let git_dir = FugitiveExtractGitDir(expand(folder))
  if empty(git_dir)
    return vimrc#warn('not in git repo')
  endif

  call fzf#vim#files(
        \ folder,
        \ fzf#vim#with_preview({ 'source': s:git_diff_tree_command . commit }),
        \ bang)
endfunction

let s:rg_git_diff_tree_command = 'git -C %s diff-tree -z --no-commit-id --name-only -r %s | xargs -0 ' . vimrc#fzf#rg#get_base_command() . ' -- %s'

" vimrc#fzf#git#rg_diff_tree([bang], [pattern], [commit], [folder])
function! vimrc#fzf#git#rg_diff_tree(...)
  if a:0 > 4
    return vimrc#warn('Invalid argument number')
  endif

  let bang    = a:0 >= 1 ? a:1 : 0
  let pattern = a:0 >= 2 ? a:2 : '.'
  let commit  = a:0 >= 3 ? a:3 : 'HEAD'
  let folder  = a:0 == 4 ? a:4 : '.'

  let git_dir = FugitiveExtractGitDir(expand(folder))
  if empty(git_dir)
    return vimrc#warn('not in git repo')
  endif

  let command = printf(s:rg_git_diff_tree_command, folder, commit, shellescape(pattern))

  call fzf#vim#grep(
        \ command, 1,
        \ bang ? fzf#vim#with_preview('up:60%')
        \      : fzf#vim#with_preview('right:50%:hidden', '?'),
        \ bang)
endfunction
