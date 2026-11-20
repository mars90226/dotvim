" Run with: nvim --headless -u NONE -i NONE -S spec/fzf_sync_spec.vim
set runtimepath^=.

function! s:finish(opts, code, timer) abort
  call a:opts.exit(a:code)
  if a:code == 0
    call a:opts.sink('selected path')
  endif
endfunction

function! s:runner(opts) abort
  if get(a:opts, 'fail', 0)
    throw 'launch failed'
  endif
  if get(a:opts, 'async', 0)
    call timer_start(20, function('s:finish', [a:opts, a:opts.code]))
  else
    call s:finish(a:opts, a:opts.code, 0)
  endif
  return []
endfunction

function! s:sink(results, value) abort
  call add(a:results, a:value)
endfunction

function! s:exit(codes, code) abort
  call add(a:codes, a:code)
endfunction

for s:async in [0, 1]
  for s:code in [0, 1, 2, 130]
    let s:results = []
    let s:codes = []
    let s:opts = {'async': s:async, 'code': s:code,
          \ 'sink': function('s:sink', [s:results]),
          \ 'exit': function('s:exit', [s:codes])}
    let s:Exit = s:opts.exit
    call assert_equal([], vimrc#fzf#call_sync(function('s:runner'), [s:opts], 0))
    call assert_equal(s:code == 0 ? ['selected path'] : [], s:results)
    call assert_equal([s:code], s:codes)
    call assert_equal(s:Exit, s:opts.exit)
  endfor
endfor

try
  call vimrc#fzf#call_sync(function('s:runner'), [{'fail': 1}], 0)
  call assert_report('Expected launch failure')
catch /launch failed/
endtry

function! s:terminal_runner(opts) abort
  enew
  call nvim_open_term(bufnr(), {})
  setfiletype fzf
  call timer_start(20, function('s:finish', [a:opts, 130]))
  return []
endfunction

" A terminal fallback must return to the input loop before fzf can exit.
let s:codes = []
let s:results = []
call vimrc#fzf#call_sync(function('s:terminal_runner'), [{
      \ 'exit': function('s:exit', [s:codes]),
      \ 'sink': function('s:sink', [s:results])}], 0)
call assert_equal([], s:codes, 'terminal fallback must not wait for exit')
call assert_equal('terminal', &buftype)
call assert_equal(0, wait(1000, { -> !empty(s:codes) }, 10))
call assert_equal([130], s:codes)
call assert_equal([], s:results)
bwipeout!

" Exercise all value-returning helpers against an asynchronous fzf API.
set runtimepath^=spec/fixtures/fzf
let g:misc_fzf_action = {}
let g:fzf_action = {}
let g:fzf_tmux_layout = {'tmux': '90%,80%'}
let g:neomru#file_mru_path = tempname()
let g:neomru#directory_mru_path = tempname()
call writefile(['header'], g:neomru#file_mru_path)
call writefile(['header'], g:neomru#directory_mru_path)
lua package.loaded['vimrc.plugins.blink_cmp'] = {disable=function() end, enable=function() end}
source autoload/vimrc/fzf/mru.vim
source autoload/vimrc/fzf/git.vim
source autoload/vimrc/fzf/chinese.vim
source autoload/vimrc/rg.vim
let s:helpers = [
      \ ['vimrc#fzf#files_in_commandline', [], 'path with spaces', 'path with spaces'],
      \ ['vimrc#fzf#shell_outputs_in_commandline', ['printf chosen'], 'chosen', 'chosen'],
      \ ['vimrc#fzf#choices_in_commandline', [['first', 'second']], 'second', 'second'],
      \ ['vimrc#fzf#mru#mru_in_commandline', [], 'recent', 'recent'],
      \ ['vimrc#fzf#mru#directory_mru_in_commandline', [], '/directory', '/directory'],
      \ ['vimrc#fzf#git#commits_in_commandline', [0, []], 'abcdef12 subject', 'abcdef12'],
      \ ['vimrc#fzf#git#branches_in_commandline', [], 'branch', 'branch'],
      \ ['vimrc#fzf#git#tags_in_commandline', [], 'tag', 'tag'],
      \ ['vimrc#fzf#git#diff_files_in_commandline', [], 'changed', 'changed'],
      \ ['vimrc#rg#types_in_commandline', [], 'python', '-tpy'],
      \ ['vimrc#fzf#chinese#punctuations_in_insert_mode', [], "comma\t，", '，']]
for s:helper in s:helpers
  for s:code in [0, 130]
    let g:fzf_test_code = s:code
    let g:fzf_test_selection = s:helper[2]
    call assert_equal(s:code == 0 ? s:helper[3] : '', call(s:helper[0], s:helper[1]), s:helper[0])
  endfor
endfor

" Commit pickers reserve Ctrl-S for sorting.
let g:fzf_action = {'ctrl-s': 'split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit'}
let g:fzf_test_code = 0
let g:fzf_test_accept_key = 'ctrl-y'
let g:fzf_test_selection = 'abcdef12 subject'
edit justfile
for s:buffer_local in [0, 1]
  call assert_equal('abcdef12', vimrc#fzf#git#commits_in_commandline(s:buffer_local, []))
  call assert_true(index(g:fzf_test_options, '--bind=ctrl-s:toggle-sort') >= 0)
  let s:expect = filter(copy(g:fzf_test_options), { _, option -> option =~# '^--expect=' })
  call assert_equal(1, len(s:expect))
  let s:keys = split(strpart(get(s:expect, 0, ''), len('--expect=')), ',')
  call assert_equal(s:buffer_local ? ['ctrl-d', 'ctrl-v', 'ctrl-x', 'ctrl-y']
        \ : ['ctrl-v', 'ctrl-x', 'ctrl-y'], sort(s:keys))
  call assert_equal('split', g:fzf_action['ctrl-s'])
endfor

lua require("vimrc.plugins.fzf").setup_command()
let s:actions = copy(g:fzf_action)
let s:commit_actions = {'ctrl-x': 'split', 'ctrl-v': 'vsplit'}
call cursor(4, 3)
let s:view = winsaveview()
unlet! g:fzf_test_commits
Commits --max-count=2
call assert_equal([0, 1, line('$'), '--max-count=2', {'placeholder': ''}, 0, s:commit_actions, s:view],
      \ get(g:, 'fzf_test_commits', []))
call assert_equal(s:actions, g:fzf_action)

let s:view = winsaveview()
unlet! g:fzf_test_commits
2,3BCommits! --all
call assert_equal([1, 2, 3, '--all', {'placeholder': ''}, 1, s:commit_actions, s:view],
      \ get(g:, 'fzf_test_commits', []))
call assert_equal(s:actions, g:fzf_action)

let g:fzf_test_commits_fail = 1
let s:view = winsaveview()
unlet! g:fzf_test_commits
try
  BCommits
  call assert_report('Expected commit picker launch failure')
catch /commit picker launch failed/
endtry
call assert_equal([1, 1, line('$'), '', {'placeholder': ''}, 0, s:commit_actions, s:view],
      \ get(g:, 'fzf_test_commits', []))
call assert_equal(s:actions, g:fzf_action)

" DirectoryFiles must chain after fzf's callback even if no DirChanged fires.
lua << EOF
package.loaded["vimrc.plugins.oil"] = {
  use_oil_fzf_action = function(open)
    vim.g.fzf_test_oil_files = true
    open()
  end,
}
EOF
let g:fzf_test_file_calls = []
let s:original_cwd = getcwd()
let s:cwd = tempname()
let s:selected = s:cwd . '/selected folder'
call mkdir(s:selected, 'p')
execute 'lcd ' . fnameescape(s:cwd)
DirectoryFiles
let s:first_picker = get(g:fzf_test_file_calls, 0, [])
call assert_equal(simplify(s:cwd . '/'), get(s:first_picker, 0, ''))
call s:first_picker[1].sinklist([])
call s:first_picker[1].sinklist(['other folder', 'selected folder'])
call assert_equal(1, len(g:fzf_test_file_calls))
call assert_equal(0, wait(1000, { -> len(g:fzf_test_file_calls) == 2 }))
if v:lua.require('vimrc.choose').is_enabled_plugin('oil.nvim')
  call assert_true(get(g:, 'fzf_test_oil_files', v:false))
endif
let s:second_picker = get(g:fzf_test_file_calls, 1, [])
call assert_equal(s:selected, get(s:second_picker, 0, ''))
call assert_equal(s:cwd, getcwd())
if has_key(get(s:second_picker, 1, {}), 'exit')
  call s:second_picker[1].exit(130)
  call assert_equal(s:cwd, getcwd())
  let s:source_win = win_getid()
  call s:second_picker[1].exit(0)
  execute 'lcd ' . fnameescape(s:selected)
  execute 'split ' . fnameescape(s:selected . '/result')
  execute 'lcd ' . fnameescape(s:cwd)
  call assert_equal(0, wait(1000, { -> getcwd() ==# s:selected }))
  call assert_equal(s:cwd, getcwd(win_id2win(s:source_win)))
  close
  let s:global_cwd = getcwd(-1, -1)
  execute 'tcd ' . fnameescape(s:cwd)
  call s:second_picker[1].exit(0)
  execute 'lcd ' . fnameescape(s:selected)
  " A symlink match can open a buffer whose resolved path is outside the picker directory.
  execute 'split ' . fnameescape(s:cwd . '/external result')
  execute 'tcd ' . fnameescape(s:cwd)
  call assert_equal(0, wait(1000, { -> getcwd() ==# s:selected }))
  call assert_equal(s:cwd, getcwd(win_id2win(s:source_win)))
  call assert_equal(1, haslocaldir(-1))
  call assert_equal(s:global_cwd, getcwd(-1, -1))
  close
else
  call assert_report('Missing DirectoryFiles exit callback')
endif
execute 'lcd ' . fnameescape(fnamemodify(s:cwd, ':h'))
call assert_equal(2, len(g:fzf_test_file_calls))
call vimrc#fzf#dir#directory_files_sink(0, s:selected)
call assert_equal(s:selected, get(get(g:fzf_test_file_calls, 2, []), 0, ''))
execute 'lcd ' . fnameescape(s:original_cwd)
call delete(s:selected, 'd')
call delete(s:cwd, 'd')
unlet g:fzf_test_file_calls

call delete(g:neomru#file_mru_path)
call delete(g:neomru#directory_mru_path)

if !empty(v:errors)
  for s:error in v:errors
    echom s:error
  endfor
  cquit
endif
echom 'fzf sync: selection, cancellation, errors, existing exit hook, option preservation passed'
qa!
