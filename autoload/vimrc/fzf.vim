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

" Functions & Commands
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

function! vimrc#fzf#locate(query, bang)
  call fzf#vim#locate(a:query, fzf#vim#with_preview(), a:bang)
endfunction

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

" Previews
function! vimrc#fzf#windows_preview() abort
  let options = fzf#vim#with_preview()
  let preview_script = remove(options.options, -1)[0:-4]
  let get_filename_script = expand(vimrc#get_vimhome() . '/bin/fzf_windows_preview.sh')
  let final_script = preview_script . ' "$(' . get_filename_script . ' {})"'

  call remove(options.options, -1) " remove --preview
  call extend(options.options, ['--preview', final_script])
  return options
endfunction

function! vimrc#fzf#buffer_lines_preview() abort
  let file = expand('%')
  let preview_top = 1
  let preview_command = systemlist(vimrc#get_vimhome() . '/bin/generate_fzf_preview_with_bat.sh ' . file . ' ' . preview_top)[0]

  return { 'options': ['--preview-window', 'right:50%:hidden', '--preview', preview_command] }
endfunction
