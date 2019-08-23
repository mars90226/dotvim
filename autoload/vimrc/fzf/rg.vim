" Manually specify ignore file as ripgrep 0.9.0 will not respect to .gitignore outside of git repository
let s:rg_base_command = 'rg --column --line-number --no-heading --smart-case --color=always --follow --with-filename '
let s:rg_command = s:rg_base_command . '--ignore-file ' . $HOME . '/.gitignore' " TODO Use '.ignore'?
let s:rg_all_command = s:rg_base_command . '--no-ignore --hidden'

function! vimrc#fzf#rg#get_base_command()
  return s:rg_base_command
endfunction
function! vimrc#fzf#rg#get_command()
  return s:rg_command
endfunction
function! vimrc#fzf#rg#get_all_command()
  return s:rg_all_command
endfunction

" Rg
function! vimrc#fzf#rg#grep(command, bang)
  call fzf#vim#grep(
        \ a:bang ? vimrc#fzf#rg#get_all_command().' -- '.shellescape(a:command)
        \        : vimrc#fzf#rg#get_command().' -- '.shellescape(a:command), 1,
        \ a:bang ? fzf#vim#with_preview('up:60%')
        \        : fzf#vim#with_preview('right:50%:hidden', '?'),
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
        \ a:bang ? fzf#vim#with_preview('up:60%')
        \        : fzf#vim#with_preview('right:50%:hidden', '?'),
        \ a:bang)
endfunction
