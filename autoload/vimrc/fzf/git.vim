" Utilities
let s:fugitive_fzf_action = vimrc#fzf#wrap_actions_for_trigger(extend({
      \ 'enter':  'Gedit',
      \ 'ctrl-t': 'Gtabedit',
      \ 'ctrl-s': 'Gsplit',
      \ 'ctrl-x': 'Gsplit',
      \ 'alt-g':  'Gsplit',
      \ 'ctrl-v': 'Gvsplit',
      \ 'alt-v':  'Gvsplit',
      \ }, g:misc_fzf_action))
function! vimrc#fzf#git#get_fugitive_fzf_action() abort
  return s:fugitive_fzf_action
endfunction

function! vimrc#fzf#git#use_fugitive_fzf_action(function) abort
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
function! s:escape(path) abort
  let path = fnameescape(a:path)
  return v:lua.require("vimrc.check").os_is('windows') ? escape(path, '$') : path
endfunction

function! s:open(cmd, target) abort
  if stridx('edit', a:cmd) == 0 && fnamemodify(a:target, ':p') ==# expand('%:p')
    return
  endif
  execute a:cmd s:escape(a:target)
endfunction

function! s:git_grep_to_qf(line, has_commit, with_column) abort
  let parts = split(a:line, ':')
  let indexs = { 'commit': 0, 'filename': 0, 'lnum': 1, 'col': 2, 'text': 2 }
  if a:has_commit
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
        \ 'filename': (a:has_commit ? parts[indexs['commit']] . ':' : '') . (&autochdir ? fnamemodify(parts[indexs['filename']], ':p') : parts[indexs['filename']]),
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
function! vimrc#fzf#git#grep_commit_sink(has_commit, with_column, lines) abort
  if len(a:lines) < 2
    return
  endif

  let cmd = vimrc#fzf#action_for_with_table(s:fugitive_fzf_action, a:lines[0], 'Gedit')
  let list = map(filter(a:lines[1:], 'len(v:val)'), 's:git_grep_to_qf(v:val, a:has_commit, a:with_column)')
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

function! vimrc#fzf#git#diff_commit_sink(start_commit, end_commit, lines) abort
  if len(a:lines) < 2
    return
  endif

  " only support function
  let Cmd = vimrc#fzf#action_for_with_table(s:fugitive_fzf_action, a:lines[0], 'Gedit')
  let list = a:lines[1:]

  if type(Cmd) == type(function('call'))
    call Cmd(list)
  else
    let current_tabnr = tabpagenr()
    for file in list
      execute 'tabedit ' . file
    endfor
    let last_tabnr = tabpagenr()
    let range = current_tabnr + 1 . ',' . last_tabnr

    execute range . 'tabdo Gedit ' . a:start_commit . ':%'
    execute range . 'tabdo Gdiff ' . a:end_commit
  endif
endfunction

function! vimrc#fzf#git#files_commit_sink(commit, lines) abort
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

function! vimrc#fzf#git#keywords_sink(lines) abort
  if len(a:lines) < 2
    return
  endif

  let cmd = vimrc#fzf#action_for(a:lines[0], 'edit')
  let qfl = []
  let candidates = a:lines[1:]
  for candidate in candidates
    let matches = matchlist(candidate, '\v^\x{7,40}\s(\S+)*\s+\(\S+\s+\S+\s\S+\s\S+\s+(\d+)\)\s(.*)$')
    let filename = matches[1]
    let line_number = matches[2]
    let text = matches[3]
    call add(qfl, {'filename': filename, 'lnum': line_number, 'text': text})
  endfor

  let first = qfl[0]
  execute cmd . ' +' . first.lnum . ' ' . first.filename
  normal! zzzv

  call vimrc#fzf#fill_quickfix(qfl)
endfunction

function! vimrc#fzf#git#keywords_by_me_sink(lines) abort
  if len(a:lines) < 2
    return
  endif

  let cmd = vimrc#fzf#action_for(a:lines[0], 'edit')
  let qfl = []
  let candidates = a:lines[1:]
  for candidate in candidates
    let matches = matchlist(candidate, '\v^\x{7,40}\s(\S+)*\s+\(\S+\s+\S+\s\S+\s\S+\s+(\d+)\)\s(.*)$')
    let filename = matches[1]
    let line_number = matches[2]
    let text = matches[3]
    call add(qfl, {'filename': filename, 'lnum': line_number, 'text': text})
  endfor

  let first = qfl[0]
  execute cmd . ' +' . first.lnum . ' ' . first.filename
  normal! zzzv

  call vimrc#fzf#fill_quickfix(qfl)
endfunction

function! vimrc#fzf#git#commits_in_commandline_sink(results, lines) abort
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

function! vimrc#fzf#git#branches_in_commandline_sink(results, line) abort
  call add(a:results, a:line)
endfunction

function! vimrc#fzf#git#tags_in_commandline_sink(results, line) abort
  call add(a:results, a:line)
endfunction

function! vimrc#fzf#git#diff_files_in_commandline_sink(results, line) abort
  call add(a:results, a:line)
endfunction

" Commands
let s:git_diff_tree_command = 'git diff-tree --no-commit-id --name-only -r '

" vimrc#fzf#git#diff_tree([bang], [commit], [folder])
function! vimrc#fzf#git#diff_tree(...) abort
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
function! vimrc#fzf#git#rg_diff(...) abort
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
        \ vimrc#fzf#preview#with_preview({ 'options': ['--prompt', 'RgDiff> '] }, bang),
        \ bang)
endfunction

" Git commit command {{{
if v:lua.require("vimrc.check").git_version() >=# 'git version 2.19.0'
  let s:git_grep_commit_command = 'git grep -nP --full-name --column'
  let s:git_grep_with_column = v:true
else
  let s:git_grep_commit_command = 'git grep -nP --full-name'
  let s:git_grep_with_column = v:false
endif
function! vimrc#fzf#git#grep_commits(commits, query, ...) abort
  let query = shellescape(a:query)
  let pathspecs = a:0 > 0 && (type(a:1) == type([]) || type(a:1) == type('')) ? a:1 : []
  " TODO Think of a better way to avoid temp file and can still let bat detect language
  " Depends on bat
  " Borrowed from fzf.vim preview.sh
  let get_variable_commands = {}
  if empty(a:commits)
    let get_variable_commands['COMMIT'] = ''
    let get_variable_commands['FILE']   = "$(echo {} | awk -F ':' '{ print $1 }')"
    let get_variable_commands['LINE']   = "$(echo {} | awk -F ':' '{ print $2 }')"
  else
    let get_variable_commands['COMMIT'] = "$(echo {} | awk -F ':' '{ print $1 }')"
    let get_variable_commands['FILE']   = "$(echo {} | awk -F ':' '{ print $2 }')"
    let get_variable_commands['LINE']   = "$(echo {} | awk -F ':' '{ print $3 }')"
  endif
  " Allow command to get commits
  let commits_string = type(a:commits) == type([]) ? join(a:commits) : a:commits
  let pathspecs_string = type(pathspecs) == type([]) ?
        \ join(map(pathspecs, { _, pathspec -> shellescape(pathspec) })) : shellescape(pathspecs)

  let final_command = s:git_grep_commit_command.' '.query.' '.commits_string
  if !empty(pathspecs_string)
    let final_command .= ' -- '.pathspecs_string
  endif

  let preview_command = "COMMIT=\"".get_variable_commands['COMMIT']."\";".
        \ "FILE=\"".get_variable_commands['FILE']."\";".
        \ "LINE=\"".get_variable_commands['LINE']."\";".
        \ 'FIRST=$(($LINE-$FZF_PREVIEW_LINES/3));'.
        \ 'FIRST=$(($FIRST < 1 ? 1 : $FIRST));'.
        \ 'LAST=$((${FIRST}+${FZF_PREVIEW_LINES}-1));'.
        \ 'TEMPFILE="/tmp/$(basename $FILE)";'.
        \ 'git show "$COMMIT":"$FILE" > "$TEMPFILE";'.
        \ vimrc#fzf#preview#get_command() . ' --line-range "$FIRST:$LAST" --highlight-line "$LINE" "$TEMPFILE";'.
        \ 'rm "$TEMPFILE"'

  " NOTE: Provide sort toggle for commits with chronological order
  call fzf#run(vimrc#fzf#wrap('GitGrepCommit', {
        \ 'source': final_command,
        \ 'sink*': function('vimrc#fzf#git#grep_commit_sink', [!empty(a:commits), s:git_grep_with_column]),
        \ 'options': ['-m', '-s', '--prompt', 'GitGrepCommit> ',
        \   '--bind=ctrl-y:toggle-sort', '--header', ':: Press '.vimrc#fzf#magenta('CTRL-Y', 'Special').' to toggle sort',
        \   '--preview-window', 'right:50%', '--preview', preview_command]}, 0))
endfunction

function! vimrc#fzf#git#grep_commit(commit, ...) abort
  let commits = empty(a:commit) ? [] : [a:commit]
  let arguments = a:0 > 0 && type(a:1) == type('') ? split(a:1) : []
  let query = []
  let pathspecs = []
  let before_double_dash = v:true

  for arg in arguments
    if arg ==# '--'
      let before_double_dash = v:false
    else
      if before_double_dash
        call add(query, arg)
      else
        call add(pathspecs, arg)
      endif
    endif
  endfor

  call vimrc#fzf#git#grep_commits(commits, join(query), pathspecs)
endfunction

function! vimrc#fzf#git#grep_all_commits(...) abort
  " Use shell command substitution to get commits to avoid passing too long command to fzf
  call call('vimrc#fzf#git#grep_commit', ['$(git rev-list --all)'] + a:000)
endfunction

function! vimrc#fzf#git#grep_branches(...) abort
  " Use shell command substitution to get commits to avoid passing too long command to fzf
  call call('vimrc#fzf#git#grep_commit', ["$(git branch -a | sed 's/^[* ]*//; /->/d')"] + a:000)
endfunction

function! vimrc#fzf#git#grep_current_branch(...) abort
  " Use shell command substitution to get commits to avoid passing too long command to fzf
  call call('vimrc#fzf#git#grep_commit', ['$(git rev-list HEAD)'] + a:000)
endfunction

" TODO: Handle added/deleted files
let s:git_diff_commit_command = 'git diff --name-only'
let s:git_diff_commit_preview_command_fmt = 'git diff --color=always %s %s -- {}'
function! vimrc#fzf#git#diff_commit(commit) abort
  if !exists('b:git_dir')
    echo 'Not in a git repository:' expand('%:p')
  endif

  let start_commit = a:commit.'^'
  let end_commit = a:commit
  let preview_command = printf(s:git_diff_commit_preview_command_fmt, start_commit, end_commit)

  call fzf#run(vimrc#fzf#wrap('GitDiffCommit', {
        \ 'source': s:git_diff_commit_command.' '.start_commit.' '.end_commit,
        \ 'sink*': function('vimrc#fzf#git#diff_commit_sink', [start_commit, end_commit]),
        \ 'options': ['-m', '-s', '--prompt', 'GitDiffCommit> ', '--preview-window', 'right:50%', '--preview', preview_command]}, 0))
endfunction

function! vimrc#fzf#git#diff_commits(start_commit, end_commit) abort
  if !exists('b:git_dir')
    echo 'Not in a git repository:' expand('%:p')
  endif

  let preview_command = printf(s:git_diff_commit_preview_command_fmt, a:start_commit, a:end_commit)

  call fzf#run(vimrc#fzf#wrap('GitDiffCommits', {
        \ 'source': s:git_diff_commit_command.' '.a:start_commit.'..'.a:end_commit,
        \ 'sink*': function('vimrc#fzf#git#diff_commit_sink', [a:start_commit, a:end_commit]),
        \ 'options': ['-m', '-s', '--prompt', 'GitDiffCommits> ', '--preview-window', 'right:50%', '--preview', preview_command]}, 0))
endfunction

let s:git_files_commit_command = 'git ls-tree -r --name-only --full-tree'
function! vimrc#fzf#git#files_commit(commit) abort
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

let s:git_keywords_command = "git grep -ilP '%s' | xargs -n1 git blame -M -f -e 2>/dev/null | rg -i '%s'"
function! vimrc#fzf#git#keywords(keyword) abort
  let command = printf(s:git_keywords_command, a:keyword, a:keyword)

  call fzf#run(vimrc#fzf#wrap('Keywords', {
        \ 'source': command,
        \ 'sink*': function('vimrc#fzf#git#keywords_sink'),
        \ 'options': ['-m', '-s', '--prompt', 'Keywords ('.a:keyword.')> ']
        \ }, 0))
endfunction

let s:git_keywords_by_me_command = s:git_keywords_command.' | rg "$(git config user.email)|not.committed.yet"'
function! vimrc#fzf#git#keywords_by_me(keyword) abort
  let command = printf(s:git_keywords_by_me_command, a:keyword, a:keyword)

  call fzf#run(vimrc#fzf#wrap('KeywordsByMe', {
        \ 'source': command,
        \ 'sink*': function('vimrc#fzf#git#keywords_by_me_sink'),
        \ 'options': ['-m', '-s', '--prompt', 'KeywordsByMe ('.a:keyword.')> ']
        \ }, 0))
endfunction
" }}}

" Intend to be mapped in command mode
function! vimrc#fzf#git#commits_in_commandline(buffer_local, args) abort
  let s:git_root = vimrc#fzf#get_git_root()
  if empty(s:git_root)
    call vimrc#utility#warn('Not in git repository')
    return ''
  endif

  let source = 'git log '.get(g:, 'fzf_commits_log_options', '--color=always '.fzf#shellescape('--format=%C(auto)%h%d %s %C(green)%cr')).' --all'
  let current = expand('%')
  let managed = 0
  if !empty(current)
    call system('git show '.fzf#shellescape(current).' 2> '.(v:lua.require("vimrc.check").os_is('windows') ? 'nul' : '/dev/null'))
    let managed = !v:shell_error
  endif

  if a:buffer_local
    if !managed
      call vimrc#utility#warn('The current buffer is not in the working tree')
      return ''
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
        \ 'options': ['--ansi', '--tiebreak=index',
        \   '--prompt', command.'> ', '--bind=ctrl-s:toggle-sort',
        \   '--header', ':: Press '.vimrc#fzf#magenta('CTRL-S', 'Special').' to toggle sort, '.vimrc#fzf#magenta('CTRL-Y', 'Special').' to yank commit hashes']
        \ }

  if a:buffer_local
    let options.options[-2] .= ', '.vimrc#fzf#magenta('CTRL-D', 'Special').' to diff'
    let options.options[-1] .= ',ctrl-d'
  endif

  if !v:lua.require("vimrc.check").os_is('windows') && &columns > vimrc#fzf#get_wide()
    call extend(options.options,
    \ ['--preview', 'echo {} | grep -o "[a-f0-9]\{7,\}" | head -1 | xargs git show --format=format: --color=always | head -200'])
  endif


  let options = extend(options, g:fzf_tmux_layout)
  call vimrc#fzf#fzf(a:buffer_local ? 'bcommits' : 'commits', options, a:args)
  return get(results, 0, '')
endfunction

" Intend to be mapped in command mode
function! vimrc#fzf#git#branches_in_commandline() abort
  let source = 'git branch --format="%(refname)" --all | sed "s/refs\/[^/]\+\///"'
  let results = []
  call fzf#run(fzf#wrap('Branches', extend({
        \ 'source': source,
        \ 'sink': function('vimrc#fzf#git#branches_in_commandline_sink', [results]),
        \ 'options': ['+s', '--prompt', 'Branches> ']
        \ }, g:fzf_tmux_layout)))
  return get(results, 0, '')
endfunction

" Intend to be mapped in command mode
function! vimrc#fzf#git#tags_in_commandline() abort
  let source = 'git tag'
  let results = []
  call fzf#run(fzf#wrap('Git Tags', extend({
    \ 'source': source,
    \ 'sink': function('vimrc#fzf#git#tags_in_commandline_sink', [results]),
    \ 'options': ['+s', '--prompt', 'Git Tags> ']
    \ }, g:fzf_tmux_layout)))
  return get(results, 0, '')
endfunction

" Intend to be mapped in command mode
function! vimrc#fzf#git#diff_files_in_commandline() abort
  let source = "git status --porcelain --untracked-files=all | awk '{ print $2 }'"
  let results = []
  call fzf#run(fzf#wrap('GitFiles?', extend({
    \ 'source': source,
    \ 'sink': function('vimrc#fzf#git#diff_files_in_commandline_sink', [results]),
    \ 'options': ['+s', '--prompt', 'GitFiles?> ']
    \ }, g:fzf_tmux_layout)))
  return get(results, 0, '')
endfunction
