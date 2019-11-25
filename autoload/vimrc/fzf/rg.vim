" Manually specify ignore file as ripgrep 0.9.0 will not respect to .gitignore outside of git repository
let s:rg_base_command = 'rg --column --line-number --no-heading --smart-case --color=always --follow --with-filename '
let s:rg_command = s:rg_base_command . '--ignore-file ' . $HOME . '/.gitignore' " TODO Use '.ignore'?
let s:rg_all_command = s:rg_base_command . '--no-ignore --hidden'
let s:rg_fzf_command_fmt = s:rg_base_command . '%s || true'

function! vimrc#fzf#rg#get_base_command()
  return s:rg_base_command
endfunction
function! vimrc#fzf#rg#get_command()
  return s:rg_command
endfunction
function! vimrc#fzf#rg#get_all_command()
  return s:rg_all_command
endfunction
function! vimrc#fzf#rg#get_fzf_command_fmt()
  return s:rg_fzf_command_fmt
endfunction

" Utility
function! vimrc#fzf#rg#with_preview(bang, ...)
  let options = a:0 > 0 && type(a:1) == type({}) ? a:1 : {}
  return a:bang ? fzf#vim#with_preview(options, 'up:60%') : fzf#vim#with_preview(options, 'right:50%:hidden', '?')
endfunction

" Rg
function! vimrc#fzf#rg#grep(query, bang)
  call fzf#vim#grep(
        \ a:bang ? vimrc#fzf#rg#get_all_command().' -- '.shellescape(a:query)
        \        : vimrc#fzf#rg#get_command().' -- '.shellescape(a:query), 1,
        \ vimrc#fzf#rg#with_preview(a:bang),
        \ a:bang)
endfunction

" Rg with option, using ':' to separate option and query
function! vimrc#fzf#rg#grep_with_option(command, bang)
  let command_parts = split(a:command, ':', 1)
  let folder = command_parts[0]
  let option = command_parts[1]
  let query = join(command_parts[2:], ':')
  call fzf#vim#grep(
        \ a:bang ? s:rg_all_command.' '.option.' -- '.shellescape(query).' '.folder
        \        : s:rg_command.' '.option.' -- '.shellescape(query).' '.folder, 1,
        \ vimrc#fzf#rg#with_preview(a:bang),
        \ a:bang)
endfunction

" RgFzf - Ripgrep with reload on change
function! vimrc#fzf#rg#grep_on_change(query, bang)
  let initial_command = printf(s:rg_fzf_command_fmt, shellescape(a:query))
  let reload_command = printf(s:rg_fzf_command_fmt, '{q}')
  let options = vimrc#fzf#rg#with_preview(a:bang, { 'options': [ '--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command ] })
  call fzf#vim#grep(initial_command, 1, options, a:bang)
endfunction
