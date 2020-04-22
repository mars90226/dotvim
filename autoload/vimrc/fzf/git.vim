" Utilities
let s:fugitive_fzf_action = extend({
      \ 'enter': 'Gedit',
      \ 'ctrl-t': 'Gtabedit',
      \ 'ctrl-s': 'Gsplit',
      \ 'ctrl-x': 'Gsplit',
      \ 'ctrl-v': 'Gvsplit',
      \ 'alt-v': 'Gvsplit',
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
  return vimrc#plugin#check#get_os() ==# 'windows' ? escape(path, '$') : path
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
        \ 'filename': (empty(a:commit) ? '' : parts[indexs['commit']] . ':') . (&autochdir ? fnamemodify(parts[indexs['filename']], ':p') : parts[indexs['filename']]),
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

  let cmd = vimrc#fzf#action_for_with_table(s:fugitive_fzf_action, a:lines[0], 'Gedit')
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

function! vimrc#fzf#git#diff_commit_sink(start_commit, end_commit, lines)
  let current_tabnr = tabpagenr()
  for file in a:lines
    execute 'tabedit ' . file
  endfor
  let last_tabnr = tabpagenr()
  let range = current_tabnr + 1 . ',' . last_tabnr

  execute range . 'tabdo Gedit ' . a:start_commit . ':%'
  execute range . 'tabdo Gdiff ' . a:end_commit
endfunction

function! vimrc#fzf#git#files_commit_sink(commit, lines)
  if len(a:lines) < 2
    return
  endif
  let Cmd = vimrc#fzf#action_for_with_table(s:fugitive_fzf_action, a:lines[0], 'Gedit')
  let list = map(a:lines[1:], { _, filename -> a:commit.':'.filename })
  if type(Cmd) == type(function('call'))
    call Cmd(list)
  else
    for filename in list
      execute Cmd . ' ' . filename
    endfor
  endif
endfunction

function! vimrc#fzf#git#commits_in_commandline_sink(results, lines)
  if len(a:lines) < 2
    return
  endif

  " TODO: Make vimrc#fzf#git#commits_in_commandline() do not use expect key
  " Currently vimrc#fzf#git#commits_in_commandline() use vimrc#fzf#fzf() which
  " always add expect key.
  let line = type(a:lines) == type([]) ? a:lines[1] : a:lines

  let pat = '[0-9a-f]\{7,9}'
  let sha = matchstr(line, pat)
  if !empty(sha)
    call add(a:results, sha)
  endif
endfunction

function! vimrc#fzf#git#branches_in_commandline_sink(results, line)
  call add(a:results, a:line)
endfunction

" Commands
let s:git_diff_tree_command = 'git diff-tree --no-commit-id --name-only -r '

" vimrc#fzf#git#diff_tree([bang], [commit], [folder])
function! vimrc#fzf#git#diff_tree(...)
  if a:0 > 3
    return vimrc#utility#warn('Invalid argument number')
  endif

  let bang   = a:0 >= 1 ? a:1 : 0
  let commit = a:0 >= 2 ? a:2 : 'HEAD'
  let folder = a:0 == 3 ? a:3 : ''

  let git_dir = FugitiveExtractGitDir(expand(folder))
  if empty(git_dir)
    return vimrc#utility#warn('not in git repo')
  endif

  call fzf#vim#files(
        \ folder,
        \ fzf#vim#with_preview({ 'source': s:git_diff_tree_command . commit }),
        \ bang)
endfunction

let s:rg_git_diff_command = 'git -C %s diff -z --name-only %s | xargs -0 ' . vimrc#fzf#rg#get_base_command() . ' -- %s'

" vimrc#fzf#git#rg_diff([bang], [pattern], [commit], [folder])
function! vimrc#fzf#git#rg_diff(...)
  if a:0 > 4
    return vimrc#utility#warn('Invalid argument number')
  endif

  let bang    = a:0 >= 1 ? a:1 : 0
  let pattern = a:0 >= 2 ? a:2 : '.'
  let commit  = a:0 >= 3 ? a:3 : 'HEAD'
  let folder  = a:0 == 4 ? a:4 : '.'

  let git_dir = FugitiveExtractGitDir(expand(folder))
  if empty(git_dir)
    return vimrc#utility#warn('not in git repo')
  endif

  let command = printf(s:rg_git_diff_command, folder, commit, shellescape(pattern))

  call fzf#vim#grep(
        \ command, 1,
        \ vimrc#fzf#rg#with_preview(bang, { 'options': ['--prompt', 'RgDiff> '] }),
        \ bang)
endfunction

" Git commit command {{{
if vimrc#plugin#check#git_version() >=# 'git version 2.19.0'
  let s:git_grep_commit_command = 'git grep -n --column'
else
  let s:git_grep_commit_command = 'git grep -n'
endif
function! vimrc#fzf#git#grep_commit(commit, ...)
  let query = (a:0 && type(a:1) == type('')) ? a:1 : ''
  let with_column = (vimrc#plugin#check#git_version() >=# 'git version 2.19.0') ? 1 : 0
  " TODO Think of a better way to avoid temp file and can still let bat detect language
  " Depends on bat
  " Borrowed from fzf.vim preview.sh
  let preview_command = "FILE=\"$(echo {} | awk -F ':' '{ print $2 }')\";".
        \ "LINE=\"$(echo {} | awk -F ':' '{ print $3 }')\";".
        \ 'FIRST=$(($LINE-$FZF_PREVIEW_LINES/3));'.
        \ 'FIRST=$(($FIRST < 1 ? 1 : $FIRST));'.
        \ 'LAST=$((${FIRST}+${FZF_PREVIEW_LINES}-1));'.
        \ 'TEMPFILE="/tmp/$(basename $FILE)";'.
        \ 'git show '.a:commit.':"$FILE" > "$TEMPFILE";'.
        \ vimrc#fzf#preview#get_command() . ' --line-range "$FIRST:$LAST" --highlight-line "$LINE" "$TEMPFILE";'.
        \ 'rm "$TEMPFILE"'

  call fzf#run(vimrc#fzf#wrap('GitGrepCommit', {
        \ 'source': s:git_grep_commit_command.' '.shellescape(query).' '.a:commit,
        \ 'sink*': function('vimrc#fzf#git#grep_commit_sink', [a:commit, with_column]),
        \ 'options': ['-m', '-s', '--prompt', 'GitGrepCommit> ', '--preview-window', 'right:50%', '--preview', preview_command]}, 0))
endfunction

" TODO: Handle added/deleted files
let s:git_diff_commit_command = 'git diff --name-only'
function! vimrc#fzf#git#diff_commit(commit)
  if !exists('b:git_dir')
    echo 'No git a git repository:' expand('%:p')
  endif

  let revision = a:commit . '^!'

  call fzf#run(fzf#wrap('GitDiffCommit', {
        \ 'source': s:git_diff_commit_command.' '.revision,
        \ 'sink*': function('vimrc#fzf#git#diff_commit_sink', [a:commit.'^', a:commit]),
        \ 'options': ['-m', '-s', '--prompt', 'GitDiffCommit> ']}))
endfunction

function! vimrc#fzf#git#diff_commits(start_commit, end_commit)
  if !exists('b:git_dir')
    echo 'No git a git repository:' expand('%:p')
  endif

  call fzf#run(fzf#wrap('GitDiffCommits', {
        \ 'source': s:git_diff_commit_command.' '.a:start_commit.'..'.a:end_commit,
        \ 'sink*': function('vimrc#fzf#git#diff_commit_sink', [a:start_commit, a:end_commit]),
        \ 'options': ['-m', '-s', '--prompt', 'GitDiffCommits> ']}))
endfunction

let s:git_files_commit_command = 'git ls-tree -r --name-only'
function! vimrc#fzf#git#files_commit(commit)
  " TODO Think of a better way to avoid temp file and can still let bat detect language
  " Depends on bat
  " TODO Filename not quoted, but git display error when quoted
  let preview_command = 'TEMPFILE="/tmp/$(basename {})";'.
        \ 'git show '.a:commit.':{} > "$TEMPFILE";'.
        \ vimrc#fzf#preview#get_command() . ' --line-range 1:"$FZF_PREVIEW_LINES" "$TEMPFILE";'.
        \ 'rm "$TEMPFILE"'

  call fzf#run(vimrc#fzf#wrap('GitFilesCommit', {
        \ 'source': s:git_files_commit_command.' '.a:commit,
        \ 'sink*': function('vimrc#fzf#git#files_commit_sink', [a:commit]),
        \ 'options': ['-m', '-s', '--prompt', 'GitFilesCommit> ', '--preview-window', 'right:50%', '--preview', preview_command]}, 0))
endfunction
" }}}

" Intend to be mapped in command
function! vimrc#fzf#git#commits_in_commandline(buffer_local, args)
  let s:git_root = vimrc#fzf#get_git_root()
  if empty(s:git_root)
    return vimrc#utility#warn('Not in git repository')
  endif

  let source = 'git log '.get(g:, 'fzf_commits_log_options', '--color=always '.fzf#shellescape('--format=%C(auto)%h%d %s %C(green)%cr'))
  let current = expand('%')
  let managed = 0
  if !empty(current)
    call system('git show '.fzf#shellescape(current).' 2> '.(vimrc#plugin#check#get_os() =~# 'windows' ? 'nul' : '/dev/null'))
    let managed = !v:shell_error
  endif

  if a:buffer_local
    if !managed
      return vimrc#utility#warn('The current buffer is not in the working tree')
    endif
    let source .= ' --follow '.fzf#shellescape(current)
  else
    let source .= ' --graph'
  endif

  let command = a:buffer_local ? 'BCommits' : 'Commits'
  let results = []
  let options = {
  \ 'source':  source,
  \ 'sink*':   function('vimrc#fzf#git#commits_in_commandline_sink', [results]),
  \ 'options': ['--ansi', '--tiebreak=index', '--layout=reverse-list',
  \   '--inline-info', '--prompt', command.'> ', '--bind=ctrl-s:toggle-sort',
  \   '--header', ':: Press '.vimrc#fzf#magenta('CTRL-S', 'Special').' to toggle sort, '.vimrc#fzf#magenta('CTRL-Y', 'Special').' to yank commit hashes']
  \ }

  if a:buffer_local
    let options.options[-2] .= ', '.vimrc#fzf#magenta('CTRL-D', 'Special').' to diff'
    let options.options[-1] .= ',ctrl-d'
  endif

  if vimrc#plugin#check#get_os() !~# 'windows' && &columns > vimrc#fzf#get_wide()
    call extend(options.options,
    \ ['--preview', 'echo {} | grep -o "[a-f0-9]\{7,\}" | head -1 | xargs git show --format=format: --color=always | head -200'])
  endif


  " Use tmux to avoid opening terminal in neovim
  let g:fzf_prefer_tmux = 1
  let options = extend(options, g:fzf_tmux_layout)
  call vimrc#fzf#fzf(a:buffer_local ? 'bcommits' : 'commits', options, a:args)
  let g:fzf_prefer_tmux = 0
  return get(results, 0, '')
endfunction

" Intend to be mapped in command
function! vimrc#fzf#git#branches_in_commandline()
  let source = 'git branch --format="%(refname)" --all | sed "s/refs\/[^/]\+\///"'
  let results = []
  " Use tmux to avoid opening terminal in neovim
  let g:fzf_prefer_tmux = 1
  call fzf#run(fzf#wrap('Branches', extend({
        \ 'source': source,
        \ 'sink': function('vimrc#fzf#git#branches_in_commandline_sink', [results]),
        \ 'options': ['+s', '--prompt', 'Branches> ']
        \ }, g:fzf_tmux_layout)))
  let g:fzf_prefer_tmux = 0
  return get(results, 0, '')
endfunction
