" Script Encoding: UTF-8
scriptencoding utf-8

" Settings
function! vimrc#terminal#settings() abort
  setlocal bufhidden=hide
  setlocal nolist
  setlocal nowrap
  setlocal nofoldenable
  setlocal foldcolumn=0
  setlocal colorcolumn=
  setlocal nonumber
  setlocal norelativenumber

  " Only clear incsearch-nohlsearch autocmd in normal shell terminal
  " Do not clear in other terminal like fzf, coc
  if vimrc#terminal#is_shell_terminal(expand('<afile>'))
    " Clear incsearch-nohlsearch autocmd on entering terminal mode
    nnoremap <silent><buffer> i :ClearIncsearchAutoNohlsearch<CR>i
  endif
endfunction

" Mappings
function! vimrc#terminal#mappings() abort
  " Navigate prompts
  nnoremap <silent><buffer> [[ ?❯<CR>
  nnoremap <silent><buffer> ]] /❯<CR>

  " Search pattern
  call vimrc#search#define_search_mappings()
endfunction

function! vimrc#terminal#meta_key_fix() abort
  set <M-a>=a
  set <M-c>=c
  set <M-h>=h
  set <M-g>=g
  set <M-j>=j
  set <M-k>=k
  set <M-l>=l
  set <M-n>=n
  set <M-o>=o
  set <M-p>=p
  set <M-s>=s
  set <M-t>=t
  set <M-/>=/
  set <M-?>=?
  set <M-]>=]
  set <M-`>=`
  set <M-1>=1
  set <M-S-o>=O
endfunction

" Utilities
function! vimrc#terminal#open(split, folder, cmd) abort
  let split = empty(a:split) ? 'edit' : a:split

  if split ==# 'float'
    " Floaterm always use current working directory
    " So we need to open shell and prepend cd command
    let cd_cmd = empty(a:folder) ? '' : 'cd '.fnameescape(a:folder)
    if vimrc#tui#is_shell(a:cmd)
      let bufnr = floaterm#terminal#open(-1, a:cmd, {}, {})
      call floaterm#terminal#send(bufnr, [cd_cmd])
    else
      let bufnr = floaterm#terminal#open(-1, &shell, {}, {})
      call floaterm#terminal#send(bufnr, [cd_cmd, a:cmd])
    endif
  else
    execute split . ' term://' . a:folder . '//' . a:cmd
  endif
endfunction

function! vimrc#terminal#open_current_folder(split, cmd) abort
  call vimrc#terminal#open(a:split, '', a:cmd)
endfunction

function! vimrc#terminal#open_shell(split, folder) abort
  call vimrc#terminal#open(a:split, a:folder, &shell)
endfunction

function! vimrc#terminal#open_current_shell(split) abort
  call vimrc#terminal#open(a:split, '', &shell)
endfunction

let s:terminal_pattern = '\vterm://(.{-}//(\d+:)?)?\zs.*' " Use very magic
function! vimrc#terminal#get_terminal_command(terminal) abort
  let match_result = matchlist(a:terminal, s:terminal_pattern)
  if empty(match_result)
    return ''
  endif
  return match_result[0]
endfunction

function! vimrc#terminal#is_floaterm() abort
  return &ft ==# 'floaterm'
endfunction

function! vimrc#terminal#is_shell_terminal(terminal) abort
  let shells = vimrc#tui#get_shells()
  let exception_programs = ['fzf', 'coc']

  let cmd = vimrc#terminal#get_terminal_command(a:terminal)
  if empty(cmd)
    return v:false
  endif

  for exception_program in exception_programs
    if cmd =~ vimrc#get_boundary_pattern(exception_program)
      return v:false
    endif
  endfor

  for shell in shells
    if cmd =~ vimrc#get_boundary_pattern(shell)
      return v:true
    endif
  endfor
endfunction

" Check if terminal command is tui process
function! vimrc#terminal#is_interactive_process(terminal) abort
  let interactive_processes = vimrc#tui#get_processes()

  let cmd = vimrc#terminal#get_terminal_command(a:terminal)
  if empty(cmd)
    return v:false
  endif

  for interactive_process in interactive_processes
    if cmd =~ vimrc#get_boundary_pattern(interactive_process)
      return v:true
    endif
  endfor
endfunction

function! vimrc#terminal#close_result_buffer(terminal) abort
  if vimrc#terminal#is_shell_terminal(a:terminal) || vimrc#terminal#is_interactive_process(a:terminal)
    call nvim_input('<CR>')
  endif
endfunction

function! vimrc#terminal#get_open_command(cmd, ...) abort
  let use_vimrc_float = a:0 > 0 && type(a:1) == type(v:true) ? a:1 : v:false

  if has('nvim')
    if vimrc#plugin#check#has_floating_window()
      if use_vimrc_float
        return 'VimrcFloatNew r!'.a:cmd
      else
        return 'FloatermNew '.a:cmd
      endif
    else
      return 'new term://'.a:cmd
    endif
  else
    return '!'.a:cmd
  endif
endfunction
