" Utilities
let s:fugitive_fzf_action = extend({
      \ 'enter': 'Gedit',
      \ 'ctrl-t': 'Gtabedit',
      \ 'ctrl-s': 'Gsplit',
      \ 'ctrl-x': 'Gsplit',
      \ 'ctrl-v': 'Gvsplit',
      \ }, g:misc_fzf_action)
function! vimrc#fzf#git#get_fugitive_fzf_action()
  return s:fugitive_fzf_action
endfunction

function! vimrc#fzf#git#use_fugitive_fzf_action(function)
  let g:fzf_action = s:fugitive_fzf_action
  augroup use_fugitive_fzf_action_callback
    autocmd!
    autocmd TermClose term://*fzf*
          \ let g:fzf_action = g:default_fzf_action |
          \ autocmd! use_fugitive_fzf_action_callback
  augroup END
  call a:function()
endfunction

" Borrowed from fzf.vim {{{
function! s:escape(path)
  let path = fnameescape(a:path)
  return vimrc#plugin#check#get_os() == 'windows' ? escape(path, '$') : path
endfunction

function! s:open(cmd, target)
  if stridx('edit', a:cmd) == 0 && fnamemodify(a:target, ':p') ==# expand('%:p')
    return
  endif
  execute a:cmd s:escape(a:target)
endfunction

function! s:git_grep_to_qf(line, commit, with_column)
  let parts = split(a:line, ':')
  let indexs = { 'commit': 0, 'filename': 0, 'lnum': 1, 'col': 2, 'text': 2 }
  if !empty(a:commit)
    let indexs['filename'] += 1
    let indexs['lnum'] += 1
    let indexs['col'] += 1
    let indexs['text'] += 1
  endif
  if a:with_column
    let indexs['text'] += 1
  endif

  let text = join(parts[indexs['text']:], ':')
  let dict = {
        \ 'filename': (empty(a:commit) ? '' : parts[indexs['commit']] . ':') . (&acd ? fnamemodify(parts[indexs['filename']], ':p') : parts[indexs['filename']]),
        \ 'lnum': parts[indexs['lnum']],
        \ 'text': text }
  if a:with_column
    let dict.col = parts[indexs['col']]
  endif
  return dict
endfunction
" }}}

" Sinks
" Borrowed from fzf.vim
function! vimrc#fzf#git#grep_commit_sink(commit, with_column, lines)
  if len(a:lines) < 2
    return
  endif

  let cmd = vimrc#fzf#action_for_with_table(g:fugitive_fzf_action, a:lines[0], 'Gedit')
  let list = map(filter(a:lines[1:], 'len(v:val)'), 's:git_grep_to_qf(v:val, a:commit, a:with_column)')
  if empty(list)
    return
  endif

  let first = list[0]
  try
    call s:open(cmd, first.filename)
    execute first.lnum
    if a:with_column
      execute 'normal!' first.col.'|'
    endif
    normal! zz
  catch
  endtry

  call vimrc#fzf#fill_quickfix(list)
endfunction

function! vimrc#fzf#git#diff_commit_sink(commit, lines)
  let current_tabnr = tabpagenr()
  for file in a:lines
    execute 'tabedit ' . file
  endfor
  let last_tabnr = tabpagenr()
  let range = current_tabnr + 1 . ',' . last_tabnr

  execute range . 'tabdo Gedit ' . a:commit . '^:%'
  execute range . 'tabdo Gdiff ' . a:commit
endfunction

function! vimrc#fzf#git#files_commit_sink(commit, lines)
  if len(a:lines) < 2
    return
  endif
  let cmd = vimrc#fzf#action_for_with_table(g:fugitive_fzf_action, a:lines[0], 'Gedit')
  for target in a:lines[1:]
    let filename = a:commit . ':' . target
    if type(cmd) == type(function('call'))
      cmd(filename)
    else
      execute cmd . ' ' . filename
    endif
  endfor
endfunction

" Commands
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

" Git commit command {{{
if vimrc#plugin#check#git_version() >= 'git version 2.19.0'
  let s:git_grep_commit_command = 'git grep -n --column'
else
  let s:git_grep_commit_command = 'git grep -n'
endif
function! vimrc#fzf#git#grep_commit(commit, ...)
  let query = (a:0 && type(a:1) == type('')) ? a:1 : ''
  let with_column = (vimrc#plugin#check#git_version() >= 'git version 2.19.0') ? 1 : 0

  call fzf#run(vimrc#fzf#wrap('', {
        \ 'source': s:git_grep_commit_command.' '.shellescape(query).' '.a:commit,
        \ 'sink*': function('vimrc#fzf#git#grep_commit_sink', [a:commit, with_column]),
        \ 'options': '-m -s',
        \ 'down': '40%' }, 0))
endfunction

" TODO: Handle added/deleted files
let s:git_diff_commit_command = 'git diff --name-only'
function! vimrc#fzf#git#diff_commit(commit)
  if !exists('b:git_dir')
    echo 'No git a git repository:' expand('%:p')
  endif

  let revision = a:commit . '^!'

  call fzf#run(fzf#wrap({
        \ 'source': s:git_diff_commit_command.' '.revision,
        \ 'sink*': function('vimrc#fzf#git#diff_commit_sink', [a:commit]),
        \ 'options': '-m -s',
        \ 'down': '40%' }))
endfunction

let s:git_files_commit_command = 'git ls-tree -r --name-only'
function! vimrc#fzf#git#files_commit(commit)
  call fzf#run(vimrc#fzf#wrap('', {
        \ 'source': s:git_files_commit_command.' '.a:commit,
        \ 'sink*': function('vimrc#fzf#git#files_commit_sink', [a:commit]),
        \ 'options': '-m -s',
        \ 'down': '40%' }, 0))
endfunction
" }}}
