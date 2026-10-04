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
