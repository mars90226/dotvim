" Variables
let s:gv_cmd = 'GV'
let s:gv_bang_cmd = 'GV!'

" Mappings
function! vimrc#gv#mappings() abort
  nnoremap <silent><buffer> + :call vimrc#gv#expand()<CR>
  nnoremap <silent><buffer> gq :call vimrc#gv#close_detail_or_window()<CR>

  call vimrc#git#include_git_mappings('gv', v:true, v:true)
endfunction

" Functions
function! vimrc#gv#expand() abort
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction

function! vimrc#gv#_open(cmd, options, raw_args) abort
  let cmd = copy(a:cmd).' '

  for key in keys(a:options)
    if type(a:options[key]) != type('') && !a:options[key]
      continue
    endif

    if len(key) == 1
      let cmd .= '-'.key

      if type(a:options[key]) == type('')
        let cmd .= ' '.a:options[key]
      endif
    else
      let cmd .= '--'.key

      if type(a:options[key]) == type('')
        let cmd .= '='.a:options[key]
      endif
    endif

    let cmd .= ' '
  endfor

  if !empty(a:raw_args)
    let cmd .= ' -- '.a:raw_args
  endif

  execute cmd
endfunction

function! vimrc#gv#open(options) abort
  call vimrc#gv#_open(s:gv_cmd, a:options, '')
endfunction

function! vimrc#gv#show_file(file, options) abort
  if a:file ==# '%'
    call vimrc#gv#_open(s:gv_bang_cmd, a:options, '')
  else
    " This may cause weirdness as --graph with --follow and limiting to one
    " file create git log with a lot of break.
    let a:options['follow'] = v:true
    call vimrc#gv#_open(s:gv_cmd, a:options, a:file)
  endif
endfunction

" Mimic behavior of GV's 'q' keymap: close commit detail panel or close GV
" This try to avoid floating window, like scrollbar
function! vimrc#gv#close_detail_or_window() abort
  let winids = nvim_tabpage_list_wins(0)
  let winids = filter(winids, { _, winid -> nvim_win_get_config(winid).relative ==# "" })
  let winnr = win_id2win(winids[-1])

  execute winnr.'wincmd w | close'
endfunction
