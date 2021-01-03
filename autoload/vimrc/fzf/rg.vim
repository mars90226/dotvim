let s:rg_binary = 'rg '
let s:rga_binary = 'rga '

" Manually specify ignore file as ripgrep 0.9.0 will not respect to .gitignore outside of git repository
" Require ripgrep v11.0.0 for --auto-hybrid-regex
let s:rg_base_options = '--auto-hybrid-regex --column --line-number --no-heading --smart-case --color=always --follow --with-filename'
let s:rg_options = s:rg_base_options . ' --ignore-file ' . $HOME . '/.gitignore' " TODO Use '.ignore'?
let s:rg_all_options = s:rg_base_options . ' --no-ignore --hidden'

let s:rg_base_command = s:rg_binary . s:rg_base_options
let s:rg_command = s:rg_binary . s:rg_options
let s:rg_all_command = s:rg_binary . s:rg_all_options

let s:rg_fzf_command_fmt = s:rg_command . ' -- %s || true'
let s:rg_fzf_all_command_fmt = s:rg_all_command . ' -- %s || true'

let s:rga_command = s:rga_binary . s:rg_options
let s:rga_all_command = s:rga_binary . s:rg_all_options

function! vimrc#fzf#rg#get_base_command() abort
  return s:rg_base_command
endfunction
function! vimrc#fzf#rg#get_command() abort
  return s:rg_command
endfunction
function! vimrc#fzf#rg#get_all_command() abort
  return s:rg_all_command
endfunction
function! vimrc#fzf#rg#get_fzf_command_fmt() abort
  return s:rg_fzf_command_fmt
endfunction
function! vimrc#fzf#rg#get_fzf_all_command_fmt() abort
  return s:rg_fzf_all_command_fmt
endfunction

" Rg
function! vimrc#fzf#rg#grep(query, bang) abort
  call fzf#vim#grep(
        \ a:bang ? vimrc#fzf#rg#get_all_command().' -- '.shellescape(a:query)
        \        : vimrc#fzf#rg#get_command().' -- '.shellescape(a:query), 1,
        \ vimrc#fzf#preview#with_preview(a:bang),
        \ a:bang)
endfunction

" Rg with option, using ':' to separate folder, option and query
function! vimrc#fzf#rg#grep_with_option(command, bang) abort
  let command_parts = split(a:command, ':', 1)
  let folder = command_parts[0]
  let option = command_parts[1]
  let query = join(command_parts[2:], ':')
  call fzf#vim#grep(
        \ a:bang ? s:rg_all_command.' '.option.' -- '.shellescape(query).' '.folder
        \        : s:rg_command.' '.option.' -- '.shellescape(query).' '.folder, 1,
        \ vimrc#fzf#preview#with_preview(a:bang),
        \ a:bang)
endfunction

" RgFzf - Ripgrep with reload on change
function! vimrc#fzf#rg#grep_on_change(query, bang) abort
  let rg_fzf_command_fmt = a:bang ? s:rg_fzf_all_command_fmt : s:rg_fzf_command_fmt
  let initial_command = printf(rg_fzf_command_fmt, shellescape(a:query))
  let reload_command = printf(rg_fzf_command_fmt, '{q}')
  let options = vimrc#fzf#preview#with_preview(
        \ { 'options': [ '--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command ] },
        \ a:bang)
  call fzf#vim#grep(initial_command, 1, options, a:bang)
endfunction

" Rga - Ripgrep-all with custom command, using ':' to separate folder, option
" and query
function! vimrc#fzf#rg#rga(command, bang) abort
  let command_parts = split(a:command, ':', 1)
  let folder = command_parts[0]
  let option = command_parts[1]
  let query = join(command_parts[2:], ':')
  call fzf#vim#grep(
        \ a:bang ? s:rga_all_command.' '.option.' -- '.shellescape(query).' '.folder
        \        : s:rga_command.' '.option.' -- '.shellescape(query).' '.folder, 1,
        \ vimrc#fzf#preview#with_preview(a:bang),
        \ a:bang)
endfunction
