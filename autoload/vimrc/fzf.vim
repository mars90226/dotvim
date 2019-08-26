" Actions
function! vimrc#fzf#build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cclose
endfunction

function! vimrc#fzf#copy_results(lines)
  let joined_lines = join(a:lines, "\n")
  if len(a:lines) > 1
    let joined_lines .= "\n"
  endif
  let @" = joined_lines
endfunction

function! vimrc#fzf#open_terminal(lines)
  let path = a:lines[0]
  let folder = isdirectory(path) ? path : fnamemodify(path, ':p:h')
  tabe
  execute 'lcd ' . folder
  terminal
  " To enter terminal mode, this is a workaround that autocommand exit the
  " terminal mode when previous fzf session end.
  call feedkeys('i')
endfunction

" Utility functions
" borrowed from fzf.vim {{{
" For filling quickfix in custom sink function
function! vimrc#fzf#fill_quickfix(list, ...)
  if len(a:list) > 1
    call setqflist(a:list)
    copen
    wincmd p
    if a:0
      execute a:1
    endif
  endif
endfunction

" For using g:fzf_action in custom sink function
" Don't return function, as function in g:fzf_action will only accept a:lines
" or a:line, which is probably not what the caller want.
let s:TYPE = {'dict': type({}), 'funcref': type(function('call')), 'string': type(''), 'list': type([])}
function! vimrc#fzf#action_for_with_table(table, key, ...)
  let default = a:0 ? a:1 : ''
  let Cmd = get(a:table, a:key, default)
  return type(Cmd) == s:TYPE.string ? Cmd : default
endfunction

function! vimrc#fzf#action_for(key, ...)
  let default = a:0 ? a:1 : ''
  return vimrc#fzf#action_for_with_table(g:fzf_action, a:key, default)
endfunction

" For using colors in fzf
function! vimrc#fzf#get_color(attr, ...)
  let gui = has('termguicolors') && &termguicolors
  let fam = gui ? 'gui' : 'cterm'
  let pat = gui ? '^#[a-f0-9]\+' : '^[0-9]\+$'
  for group in a:000
    let code = synIDattr(synIDtrans(hlID(group)), a:attr, fam)
    if code =~? pat
      return code
    endif
  endfor
  return ''
endfunction

function! vimrc#fzf#csi(color, fg)
  let prefix = a:fg ? '38;' : '48;'
  if a:color[0] == '#'
    return prefix.'2;'.join(map([a:color[1:2], a:color[3:4], a:color[5:6]], 'str2nr(v:val, 16)'), ';')
  endif
  return prefix.'5;'.a:color
endfunction

let s:ansi = {'black': 30, 'red': 31, 'green': 32, 'yellow': 33, 'blue': 34, 'magenta': 35, 'cyan': 36}

function! vimrc#fzf#ansi(str, group, default, ...)
  let fg = vimrc#fzf#get_color('fg', a:group)
  let bg = vimrc#fzf#get_color('bg', a:group)
  let color = (empty(fg) ? s:ansi[a:default] : vimrc#fzf#csi(fg, 1)) .
        \ (empty(bg) ? '' : ';'.vimrc#fzf#csi(bg, 0))
  return printf("\x1b[%s%sm%s\x1b[m", color, a:0 ? ';1' : '', a:str)
endfunction

for s:color_name in keys(s:ansi)
  execute "function! vimrc#fzf#".s:color_name."(str, ...)\n"
        \ "  return vimrc#fzf#ansi(a:str, get(a:, 1, ''), '".s:color_name."')\n"
        \ "endfunction"
endfor

function! vimrc#fzf#wrap(name, opts, bang)
  " fzf#wrap does not append --expect if sink or sink* is found
  let opts = copy(a:opts)
  let options = ''
  if has_key(opts, 'options')
    let options = type(opts.options) == s:TYPE.list ? join(opts.options) : opts.options
  endif
  if options !~ '--expect' && has_key(opts, 'sink*')
    let Sink = remove(opts, 'sink*')
    let wrapped = fzf#wrap(a:name, opts, a:bang)
    let wrapped['sink*'] = Sink
  else
    let wrapped = fzf#wrap(a:name, opts, a:bang)
  endif
  return wrapped
endfunction
" }}}

" Sources
function! vimrc#fzf#jump_source()
  return reverse(filter(split(execute("jumps", "silent!"), "\n")[1:], 'v:val != ">"'))
endfunction

function! vimrc#fzf#registers_source()
  return split(execute("registers", "silent!"), "\n")[1:]
endfunction

" TODO Add sign text and highlight
function! vimrc#fzf#current_placed_signs_source()
  let linefmt = vimrc#fzf#yellow(" %4d ", "LineNr")."\t%s"
  let fmtexpr = 'printf(linefmt, v:val[0], v:val[1])'
  let current_placed_signs = split(execute("sign place buffer=" . bufnr('%'), "silent!"), "\n")[2:]
  let line_numbers = map(current_placed_signs, "str2nr(matchstr(v:val, '\\d\\+', 9))")
  let uniq_line_numbers = uniq(line_numbers) " Remove duplicate line numbers as both GitGutter and GitP will place sign on same lines
  let lines = map(uniq_line_numbers, "[v:val, getline(v:val)]")
  let formatted_lines = map(lines, fmtexpr)
  return formatted_lines
endfunction

function! vimrc#fzf#functions_source()
  return split(execute("function", "silent!"), "\n")
endfunction

" Sinks
" Currently not used
function! vimrc#fzf#files_sink(lines)
  if len(a:lines) < 2
    return
  endif
  let cmd = vimrc#fzf#action_for(a:lines[0], 'edit')
  for target in a:lines[1:]
    if type(cmd) == type(function('call'))
      cmd(target)
    else
      execute cmd . ' ' . target
    endif
  endfor
endfunction

function! vimrc#fzf#files_in_commandline_sink(line)
  let s:files_in_commandline_result = a:line
endfunction

" TODO Add Jumps command preview
" TODO Use <C-O> & <C-I> to actually jump back and forth
function! vimrc#fzf#jump_sink(lines)
  if len(a:lines) < 2
    return
  endif
  let cmd = vimrc#fzf#action_for(a:lines[0], 'e')
  for result in a:lines[1:]
    let list = matchlist(result, '^\s\+\S\+\s\+\(\S\+\)\s\+\(\S\+\)\s\+\(.*\)') " jump line col file/text
    if len(list) < 4
      return
    end

    " Tell if list[3] is a file
    let lines = getbufline(list[3], list[1])
    if empty(lines)
      execute cmd
    else
      execute cmd . ' ' . list[3]
    endif
    call cursor(list[1], list[2])
  endfor
endfunction

function! vimrc#fzf#registers_sink(line)
  execute 'norm ' . a:line[0:1] . 'p'
endfunction

function! vimrc#fzf#current_placed_signs_sink(lines)
  execute split(a:lines[0], '\t')[0]
  normal! zzzv
endfunction

function! vimrc#fzf#functions_sink(line)
  let function_name = matchstr(a:line, '\s\zs\S[^(]*\ze(')
  let @" = function_name
endfunction

" Commands
" borrowed from fzf.vim {{{
function! vimrc#fzf#history(arg, bang)
  let bang = a:bang || a:arg[len(a:arg)-1] == '!'
  if a:arg[0] == ':'
    call fzf#vim#command_history(bang)
  elseif a:arg[0] == '/'
    call fzf#vim#search_history(bang)
  else
    call fzf#vim#history(fzf#vim#with_preview(), bang)
  endif
endfunction
" }}}

function! vimrc#fzf#files(path, bang)
  call fzf#vim#files(a:path, fzf#vim#with_preview(), a:bang)
endfunction

function! vimrc#fzf#gitfiles(args, bang) abort
  if a:args != '?'
    return call('fzf#vim#gitfiles', [a:args, fzf#vim#with_preview(), a:bang])
  else
    return call('fzf#vim#gitfiles', [a:args, a:bang])
  endif
endfunction

function! vimrc#fzf#files_with_query(query)
  Files
  call feedkeys(a:query)
endfunction

function! vimrc#fzf#locate(query, bang)
  call fzf#vim#locate(a:query, fzf#vim#with_preview(), a:bang)
endfunction

" Intend to be mapped in command
function! vimrc#fzf#files_in_commandline()
  let s:files_in_commandline_result = ''
  " Use tmux to avoid opening terminal in neovim
  let g:fzf_prefer_tmux = 1
  call fzf#vim#files(
        \ '',
        \ fzf#vim#with_preview({
        \   'sink': function('vimrc#fzf#files_in_commandline_sink'),
        \ }),
        \ 0)
  let g:fzf_prefer_tmux = 0
  return s:files_in_commandline_result
endfunction

function! vimrc#fzf#jump()
  call fzf#run(fzf#wrap({
      \ 'source':  vimrc#fzf#jump_source(),
      \ 'sink*':   function('vimrc#fzf#jump_sink'),
      \ 'options': '-m +s --expect=' . join(keys(g:fzf_action), ','),
      \ 'down':    '40%'}))
endfunction

function! vimrc#fzf#registers()
  call fzf#run(fzf#wrap({
      \ 'source': vimrc#fzf#registers_source(),
      \ 'sink': function('vimrc#fzf#registers_sink'),
      \ 'options': '+s',
      \ 'down': '40%'}))
endfunction

function! vimrc#fzf#current_placed_signs()
  call fzf#run(fzf#wrap({
        \ 'source':  vimrc#fzf#current_placed_signs_source(),
        \ 'sink*':   function('vimrc#fzf#current_placed_signs_sink'),
        \ 'options': ['--tiebreak=index', '--prompt', 'Signs> ', '--ansi', '--extended', '--nth=2..', '--layout=reverse-list', '--tabstop=1'],
        \ }))
endfunction

function! vimrc#fzf#functions()
  call fzf#run(fzf#wrap({
      \ 'source':  vimrc#fzf#functions_source(),
      \ 'sink':    function('vimrc#fzf#functions_sink'),
      \ 'down':    '40%'}))
endfunction
