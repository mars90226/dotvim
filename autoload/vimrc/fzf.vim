" Variables
let s:fzf_default_options = { 'options': ['--layout', 'reverse', '--inline-info'] }

function! vimrc#fzf#get_default_options() abort
  return s:fzf_default_options
endfunction

" Config
function! vimrc#fzf#statusline() abort
  highlight fzf1 ctermfg=242 ctermbg=236 guifg=#7c6f64 guibg=#32302f
  highlight fzf2 ctermfg=143 guifg=#b8bb26
  highlight fzf3 ctermfg=15 ctermbg=239 guifg=#ebdbb2 guibg=#504945
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fzf%#fzf3#
endfunction

" Actions
function! vimrc#fzf#build_quickfix_list(lines) abort
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cfirst
  cclose
endfunction

function! vimrc#fzf#copy_results(lines) abort
  let joined_lines = join(a:lines, "\n")
  if len(a:lines) > 1
    let joined_lines .= "\n"
  endif
  let @" = joined_lines
endfunction

function! vimrc#fzf#open_terminal(lines) abort
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
" Borrowed from fzf.vim {{{
" For filling quickfix in custom sink function
function! vimrc#fzf#fill_quickfix(list, ...) abort
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
let s:TYPE = {'dict': type({}), 'funcref': type(function('call')), 'string': type(''), 'list': type([])}
function! vimrc#fzf#action_for_with_table(table, key, ...) abort
  let default = a:0 ? a:1 : ''
  let Cmd = get(a:table, a:key, default)
  return type(Cmd) == s:TYPE.string || type(Cmd) == s:TYPE.funcref ? Cmd : default
endfunction

function! vimrc#fzf#action_for(key, ...) abort
  let default = a:0 ? a:1 : ''
  return vimrc#fzf#action_for_with_table(g:fzf_action, a:key, default)
endfunction

function! vimrc#fzf#action_type(key) abort
  return get(g:fzf_action_type, a:key, {})
endfunction

let s:wide = 120
function! vimrc#fzf#get_wide() abort
  return s:wide
endfunction

" For using colors in fzf
function! vimrc#fzf#get_color(attr, ...) abort
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

function! vimrc#fzf#csi(color, fg) abort
  let prefix = a:fg ? '38;' : '48;'
  if a:color[0] ==# '#'
    return prefix.'2;'.join(map([a:color[1:2], a:color[3:4], a:color[5:6]], 'str2nr(v:val, 16)'), ';')
  endif
  return prefix.'5;'.a:color
endfunction

let s:ansi = {'black': 30, 'red': 31, 'green': 32, 'yellow': 33, 'blue': 34, 'magenta': 35, 'cyan': 36}

function! vimrc#fzf#ansi(str, group, default, ...) abort
  let fg = vimrc#fzf#get_color('fg', a:group)
  let bg = vimrc#fzf#get_color('bg', a:group)
  let color = (empty(fg) ? s:ansi[a:default] : vimrc#fzf#csi(fg, 1)) .
        \ (empty(bg) ? '' : ';'.vimrc#fzf#csi(bg, 0))
  return printf("\x1b[%s%sm%s\x1b[m", color, a:0 ? ';1' : '', a:str)
endfunction

for s:color_name in keys(s:ansi)
  execute 'function! vimrc#fzf#'.s:color_name."(str, ...)\n"
        \ "  return vimrc#fzf#ansi(a:str, get(a:, 1, ''), '".s:color_name."')\n"
        \ 'endfunction'
endfor

function! vimrc#fzf#buflisted() abort
  return filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&filetype") !=# "qf"')
endfunction

function! vimrc#fzf#fzf(name, opts, extra) abort
  let [merged, bang] = s:extract_and_merge_options(a:opts, a:000)
  return fzf#run(vimrc#fzf#wrap(a:name, merged, bang))
endfunction

function! vimrc#fzf#wrap(name, opts, bang) abort
  " fzf#wrap does not append --expect if sink or sink* is found
  let opts = copy(a:opts)
  let options = ''
  if has_key(opts, 'options')
    let options = type(opts.options) == s:TYPE.list ? join(opts.options) : opts.options
  endif
  if options !~# '--expect' && has_key(opts, 'sink*')
    let Sink = remove(opts, 'sink*')
    let wrapped = fzf#wrap(a:name, opts, a:bang)
    let wrapped['sink*'] = Sink
  else
    let wrapped = fzf#wrap(a:name, opts, a:bang)
  endif
  return wrapped
endfunction

function! vimrc#fzf#extend_opts(dict, eopts, prepend) abort
  if empty(a:eopts)
    return
  endif
  if has_key(a:dict, 'options')
    if type(a:dict.options) == s:TYPE.list && type(a:eopts) == s:TYPE.list
      if a:prepend
        let a:dict.options = extend(copy(a:eopts), a:dict.options)
      else
        call extend(a:dict.options, a:eopts)
      endif
    else
      let all_opts = a:prepend ? [a:eopts, a:dict.options] : [a:dict.options, a:eopts]
      let a:dict.options = join(map(all_opts, 'type(v:val) == s:TYPE.list ? join(map(copy(v:val), "fzf#shellescape(v:val)")) : v:val'))
    endif
  else
    let a:dict.options = a:eopts
  endif
endfunction

function! vimrc#fzf#merge_opts(dict, eopts) abort
  return vimrc#fzf#extend_opts(a:dict, a:eopts, 0)
endfunction

function! vimrc#fzf#get_generate_preview_command_with_bat_script() abort
  return vimrc#get_vimhome() . '/bin/generate_fzf_preview_with_bat.sh'
endfunction

function! vimrc#fzf#generate_preview_command_with_bat(start, ...) abort
  let file       = a:0 > 0 && type(a:1) == type('') ? a:1 : ''
  let pattern    = a:0 > 1 && type(a:2) == type('') ? a:2 : ''
  let tmp_folder = a:0 > 2 && type(a:3) == type('') ? a:3 : ''
  return systemlist(vimrc#fzf#get_generate_preview_command_with_bat_script(). ' ' . a:start . ' ' . file . ' ' . pattern . ' ' . tmp_folder)[0]
endfunction

function! vimrc#fzf#expect_keys() abort
  return join(keys(g:fzf_action), ',')
endfunction

function! vimrc#fzf#with_default_options(...) abort
  let opts = a:0 >= 1 && type(a:1) == type({}) ? copy(a:1) : {}
  let fzf_default_options = copy(vimrc#fzf#get_default_options().options)
  let options = []
  if has_key(opts, 'options')
    if type(opts.options) == type([])
      let options = opts.options
    elseif type(opts.options) == type('')
      let options = [opts.options]
    endif
  endif
  let opts.options = extend(fzf_default_options, options)
  return opts
endfunction

function! vimrc#fzf#get_git_root() abort
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endfunction

function! vimrc#fzf#strip(str) abort
  return substitute(a:str, '^\s*\|\s*$', '', 'g')
endfunction

function! vimrc#fzf#align_lists(lists) abort
  let maxes = {}
  for list in a:lists
    let i = 0
    while i < len(list)
      let maxes[i] = max([get(maxes, i, 0), len(list[i])])
      let i += 1
    endwhile
  endfor
  for list in a:lists
    call map(list, "printf('%-'.maxes[v:key].'s', v:val)")
  endfor
  return a:lists
endfunction

function! s:escape(path) abort
  let path = fnameescape(a:path)
  return vimrc#plugin#check#get_os() =~# 'windows' ? escape(path, '$') : path
endfunction

function! s:extract_and_merge_options(opts, extra) abort
  let [extra, bang] = [{}, 0]
  if len(a:extra) <= 1
    let first = get(a:extra, 0, 0)
    if type(first) == s:TYPE.dict
      let extra = first
    else
      let bang = first
    endif
  elseif len(a:extra) == 2
    let [extra, bang] = a:extra
  else
    throw 'invalid number of arguments'
  endif

  let eopts  = has_key(extra, 'options') ? remove(extra, 'options') : ''
  let merged = extend(copy(a:opts), extra)
  call vimrc#fzf#merge_opts(merged, eopts)

  return [merged, bang]
endfunction
" }}}

" Wrap action to trigger autocmd in sink
function! vimrc#fzf#wrap_action_for_trigger(Action) abort
  if type(a:Action) == type('')
    return 'doautocmd User VimrcFzfSink | '.a:Action
  else
    return { line -> a:Action(line) }
  endif
endfunction

function! vimrc#fzf#wrap_actions_for_trigger(fzf_action) abort
  let wrapped_fzf_action = {}

  for [key, Action] in items(a:fzf_action)
    let wrapped_fzf_action[key] = vimrc#fzf#wrap_action_for_trigger(Action)
  endfor

  return wrapped_fzf_action
endfunction

" Sources
function! vimrc#fzf#jumps_source() abort
  return reverse(filter(split(execute('jumps', 'silent!'), "\n")[1:], 'v:val !=# ">"'))
endfunction

function! vimrc#fzf#registers_source() abort
  return split(execute('registers', 'silent!'), "\n")[1:]
endfunction

" TODO Add sign text and highlight
function! vimrc#fzf#current_placed_signs_source() abort
  let linefmt = vimrc#fzf#yellow(' %4d ', 'LineNr')."\t%s"
  let fmtexpr = 'printf(linefmt, v:val[0], v:val[1])'
  let current_placed_signs = split(execute('sign place buffer=' . bufnr('%'), 'silent!'), "\n")[2:]
  let line_numbers = map(current_placed_signs, "str2nr(matchstr(v:val, '\\d\\+', 9))")
  let uniq_line_numbers = uniq(line_numbers)
  let lines = map(uniq_line_numbers, '[v:val, getline(v:val)]')
  let formatted_lines = map(lines, fmtexpr)
  return formatted_lines
endfunction

function! vimrc#fzf#functions_source() abort
  return split(execute('function', 'silent!'), "\n")
endfunction

function! vimrc#fzf#compilers_source() abort
  return getcompletion('', 'compiler')
endfunction

function! vimrc#fzf#outputs_source(cmd) abort
  return split(execute(a:cmd), "\n")
endfunction

" Sinks
" Currently not used
function! vimrc#fzf#files_sink(lines) abort
  if len(a:lines) < 2
    return
  endif
  let Cmd = vimrc#fzf#action_for(a:lines[0], 'edit')
  let list = a:lines[1:]
  if type(Cmd) == type(function('call'))
    call Cmd(list)
  else
    for filename in list
      execute Cmd . ' ' . filename
    endfor
  endif
endfunction

function! vimrc#fzf#files_in_commandline_sink(results, line) abort
  call add(a:results, a:line)
endfunction

" TODO Add Jumps command preview
" TODO Use <C-O> & <C-I> to actually jump back and forth
function! vimrc#fzf#jumps_sink(lines) abort
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

function! vimrc#fzf#registers_sink(line) abort
  execute 'norm ' . a:line[0:1] . 'p'
endfunction

function! vimrc#fzf#current_placed_signs_sink(lines) abort
  if len(a:lines) < 2
    return
  endif

  let cmd = vimrc#fzf#action_for(a:lines[0], '')
  for result in a:lines[1:]
    let line_number = split(result, '\t')[0]

    if !empty(cmd)
      execute cmd
    endif
    execute line_number
  endfor

  normal! zzzv
endfunction

function! vimrc#fzf#functions_sink(line) abort
  let function_name = matchstr(a:line, '\s\zs\S[^(]*\ze(')
  let @" = function_name
endfunction

function! vimrc#fzf#compilers_sink(bang, line) abort
  execute 'compiler'.(a:bang ? '!' : '').' '.a:line
endfunction

function! vimrc#fzf#outputs_sink(line) abort
  let @" = a:line
endfunction

" Borrowed from fzf.vim
function! vimrc#fzf#helptag_sink(lines) abort
  let use_float = a:lines[0] ==# 'alt-z' ? v:true : v:false
  let [tag, file, path] = split(a:lines[1], "\t")[0:2]
  let rtp = fnamemodify(path, ':p:h:h')
  if stridx(&runtimepath, rtp) < 0
    let &runtimepath += s:escape(rtp)
  endif

  if use_float
    execute 'VimrcFloatNew! help' tag
  else
    execute 'help' tag
  endif
endfunction

" Commands
" borrowed from fzf.vim {{{
function! vimrc#fzf#history(arg, bang) abort
  let bang = a:bang || a:arg[len(a:arg)-1] ==# '!'
  if a:arg[0] ==# ':'
    call fzf#vim#command_history(bang)
  elseif a:arg[0] ==# '/'
    call fzf#vim#search_history(bang)
  else
    call fzf#vim#history(fzf#vim#with_preview(), bang)
  endif
endfunction
" }}}

function! vimrc#fzf#files(path, ...) abort
  let [merged, bang] = s:extract_and_merge_options(fzf#vim#with_preview(), a:000)
  call fzf#vim#files(a:path, merged, bang)
endfunction

function! vimrc#fzf#gitfiles(args, ...) abort
  let [merged, bang] = s:extract_and_merge_options(a:args !=# '?' ? fzf#vim#with_preview() : {}, a:000)
  return call('fzf#vim#gitfiles', [a:args, merged, bang])
endfunction

function! vimrc#fzf#files_with_query(query) abort
  let options = {
    \ 'options': ['--query', a:query]
    \ }
  call vimrc#fzf#files('', options, 0)
endfunction

function! vimrc#fzf#locate(query, bang) abort
  call fzf#vim#locate(a:query, fzf#vim#with_preview(), a:bang)
endfunction

" Intend to be mapped in command mode
function! vimrc#fzf#files_in_commandline() abort
  let results = []
  call fzf#vim#files(
        \ '',
        \ fzf#vim#with_preview(extend({
        \   'sink': function('vimrc#fzf#files_in_commandline_sink', [results]),
        \ }, g:fzf_tmux_layout)),
        \ 0)
  return get(results, 0, '')
endfunction

function! vimrc#fzf#shell_outputs_in_commandline() abort
  let results = []

  " NOTE: nvim-cmp error when switching commandline to input
  lua require("vimrc.plugins.nvim_cmp").disable()
  let command = input('Command: ', '', 'shellcmd')
  lua require("vimrc.plugins.nvim_cmp").enable()

  call vimrc#fzf#fzf(
        \ 'Outputs',
        \ fzf#vim#with_preview(extend({
        \   'source': command,
        \   'sink': function('vimrc#fzf#files_in_commandline_sink', [results]),
        \ }, g:fzf_tmux_layout)),
        \ 0)
  return get(results, 0, '')
endfunction

function! vimrc#fzf#choices_in_commandline(choices, ...) abort
  let name = (a:0 && type(a:1) == type('')) ? a:1 : 'Choices'
  let results = []
  call vimrc#fzf#fzf(
        \ name,
        \ fzf#vim#with_preview(extend({
        \   'source': a:choices,
        \   'sink': function('vimrc#fzf#files_in_commandline_sink', [results]),
        \ }, g:fzf_tmux_layout)),
        \ 0)
  return get(results, 0, '')
endfunction

" Commands
function! vimrc#fzf#jumps() abort
  call fzf#run(vimrc#fzf#wrap('Jumps', {
      \ 'source':  vimrc#fzf#jumps_source(),
      \ 'sink*':   function('vimrc#fzf#jumps_sink'),
      \ 'options': ['-m', '+s', '--prompt', 'Jumps> ']
      \ }, 0))
endfunction

function! vimrc#fzf#registers() abort
  call fzf#run(fzf#wrap('Registers', {
      \ 'source': vimrc#fzf#registers_source(),
      \ 'sink': function('vimrc#fzf#registers_sink'),
      \ 'options': ['+s', '--prompt', 'Registers> ']}))
endfunction

function! vimrc#fzf#current_placed_signs() abort
  call fzf#run(vimrc#fzf#wrap('Signs', {
        \ 'source':  vimrc#fzf#current_placed_signs_source(),
        \ 'sink*':   function('vimrc#fzf#current_placed_signs_sink'),
        \ 'options': ['-m', '+s', '--tiebreak=index', '--prompt', 'Signs> ', '--ansi', '--extended', '--nth=2..', '--tabstop=1'],
        \ }, 0))
endfunction

function! vimrc#fzf#functions() abort
  call fzf#run(fzf#wrap('Functions', {
      \ 'source':  vimrc#fzf#functions_source(),
      \ 'sink':    function('vimrc#fzf#functions_sink'),
      \ 'options': ['--prompt', 'Functions> ']}))
endfunction

function! vimrc#fzf#helptags(...) abort
  if !executable('grep') || !executable('perl')
    return vimrc#utility#warn('Helptags command requires grep and perl')
  endif
  let sorted = sort(split(globpath(&runtimepath, 'doc/tags', 1), '\n'))
  let tags = exists('*uniq') ? uniq(sorted) : fzf#vim#_uniq(sorted)

  if exists('s:helptags_script')
    silent! call delete(s:helptags_script)
  endif
  let s:helptags_script = tempname()
  call writefile(['/('.(vimrc#plugin#check#get_os() =~# 'windows' ? '^[A-Z]:\/.*?[^:]' : '.*?').'):(.*?)\t(.*?)\t/; printf(qq('.vimrc#fzf#green('%-40s', 'Label').'\t%s\t%s\n), $2, $3, $1)'], s:helptags_script)
  return vimrc#fzf#fzf('helptags', {
  \ 'source':  'grep -H ".*" '.join(map(tags, 'fzf#shellescape(v:val)')).
    \ ' | perl -n '.fzf#shellescape(s:helptags_script).' | sort',
    \ 'sink*': function('vimrc#fzf#helptag_sink'),
  \ 'options': ['--ansi', '+m', '--tiebreak=begin', '--with-nth', '..-2', '--prompt', 'Helptags> ', '--expect=alt-z']}, a:000)
endfunction

function! vimrc#fzf#compilers(bang) abort
  call fzf#run(vimrc#fzf#wrap('Compilers', {
      \ 'source':  vimrc#fzf#compilers_source(),
      \ 'sink':   function('vimrc#fzf#compilers_sink', [a:bang]),
      \ 'options': ['+s', '--prompt', 'Compilers> ']
      \ }, 0))
endfunction

function! vimrc#fzf#outputs(cmd) abort
  call fzf#run(vimrc#fzf#wrap('Outputs', {
        \ 'source': vimrc#fzf#outputs_source(a:cmd),
        \ 'sink': function('vimrc#fzf#outputs_sink'),
        \ 'options': ['+s', '--prompt', 'Outputs> ']
        \ }, 0))
endfunction
