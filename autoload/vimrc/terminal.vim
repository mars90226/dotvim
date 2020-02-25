" Settings
function! vimrc#terminal#settings()
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

" Nested neovim {{{
let s:nested_neovim_key_mappings = {}

" Use <M-q> as prefix
" TODO Add key mapping for inserting <M-q>
function! vimrc#terminal#nested_neovim_mappings(start_count)
  let count = a:start_count - 1
  let c = vimrc#getchar_string('Nested neovim, press any key: ')
  while c == "\<M-q>" 
    let count += 1
    let c = vimrc#getchar_string('Nested neovim, press any key: ')
  endwhile

  if !has_key(s:nested_neovim_key_mappings, c)
    redraw | echo ''
    " FIXME This may cause terminal to take another character before go back
    " to normal
    return ""
  endif
  let target_key = s:nested_neovim_key_mappings[c]

  let result = ""
  for i in range(1, float2nr(pow(2, count)))
    let result .= "\<C-\>"
  endfor
  let result .= "\<C-N>".target_key

  redraw | echo ''
  return result
endfunction

function! vimrc#terminal#nested_neovim_register(key, target)
  let s:nested_neovim_key_mappings[a:key] = a:target
endfunction
" }}}

function! vimrc#terminal#meta_key_fix()
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
function! vimrc#terminal#open(split, folder, cmd)
  execute a:split . ' term://' . a:folder . '//' . a:cmd
endfunction

function! vimrc#terminal#open_current_folder(split, cmd)
  call vimrc#terminal#open(a:split, '', a:cmd)
endfunction

function! vimrc#terminal#open_shell(split, folder)
  call vimrc#terminal#open(a:split, a:folder, $SHELL)
endfunction

function! vimrc#terminal#open_current_shell(split)
  call vimrc#terminal#open(a:split, '', $SHELL)
endfunction

let s:terminal_pattern = '\vterm://(.{-}//(\d+:)?)?\zs.*' " Use very magic
function! vimrc#terminal#get_terminal_command(terminal)
  let match_result = matchlist(a:terminal, s:terminal_pattern)
  if empty(match_result)
    return ""
  endif
  return match_result[0]
endfunction

function! vimrc#terminal#is_shell_terminal(terminal)
  let shells = ["bash", "zsh", "fish", "powershell"]
  let exception_programs = ["fzf", "coc"]
  let exception_filetypes = ["floaterm"]

  let cmd = vimrc#terminal#get_terminal_command(a:terminal)
  if empty(cmd)
    return v:false
  endif

  for exception_filetype in exception_filetypes
    if &ft == exception_filetype
      return v:false
    endif
  endfor

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

" Only whitelist specific processes
function! vimrc#terminal#is_interactive_process(terminal)
  let interactive_processes = ["htop", "broot", "sr", "ranger", "nnn", "vifm"]

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
