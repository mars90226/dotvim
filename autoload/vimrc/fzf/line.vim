" Script Encoding: UTF-8
scriptencoding utf-8

" Borrowed from fzf.vim

" Sources
function! vimrc#fzf#line#lines_source(all)
  let cur = []
  let rest = []
  let buf = bufnr('')
  let longest_name = 0
  let display_bufnames = &columns > vimrc#fzf#get_wide()
  if display_bufnames
    let bufnames = {}
    for b in vimrc#fzf#buflisted()
      let bufnames[b] = pathshorten(fnamemodify(bufname(b), ':~:.'))
      let longest_name = max([longest_name, len(bufnames[b])])
    endfor
  endif
  let len_bufnames = min([15, longest_name])
  for b in vimrc#fzf#buflisted()
    let lines = getbufline(b, 1, '$')
    if empty(lines)
      let path = fnamemodify(bufname(b), ':p')
      let lines = filereadable(path) ? readfile(path) : []
    endif
    if display_bufnames
      let bufname = bufnames[b]
      if len(bufname) > len_bufnames + 1
        let bufname = '…' . bufname[-len_bufnames+1:]
      endif
      let bufname = printf(vimrc#fzf#green('%'.len_bufnames.'s', 'Directory'), bufname)
    else
      let bufname = ''
    endif
    let linefmt = vimrc#fzf#blue("%2d\t", 'TabLine').'%s'.vimrc#fzf#yellow("\t%4d ", 'LineNr')."\t%s"
    call extend(b == buf ? cur : rest,
    \ filter(
    \   map(lines,
    \       '(!a:all && empty(v:val)) ? "" : printf(linefmt, b, bufname, v:key + 1, v:val)'),
    \   'a:all || !empty(v:val)'))
  endfor
  return [display_bufnames, extend(cur, rest)]
endfunction

" Sinks
function! vimrc#fzf#line#lines_sink(lines)
  if len(a:lines) < 2
    return
  endif
  normal! m'

  let key = a:lines[0]
  let cmd = vimrc#fzf#action_for(key)
  let [bufnr, _, linenr; _] = split(a:lines[1], '\t')
  let bufnr = str2nr(bufnr)
  let linenr = str2nr(linenr)

  let action_done = v:false
  if !empty(cmd) && stridx('edit', cmd) < 0
    let action_type = vimrc#fzf#action_type(key)
    let need_argument = get(action_type, 'need_argument', v:false)

    if need_argument
      if action_type.type ==# 'file'
        let file = bufname(bufnr)
        execute 'silent '.cmd.' '.file
        let action_done = v:true
      elseif action_type.type ==# 'buffer'
        execute 'silent '.cmd.' '.bufnr
        let action_done = v:true
      endif
    endif
  endif

  if !action_done
    execute 'silent '.cmd
    execute 'buffer '.bufnr
  endif

  execute linenr
  normal! ^zvzz
endfunction

" Commands
function! vimrc#fzf#line#lines(...)
  let [display_bufnames, lines] = vimrc#fzf#line#lines_source(1)
  let nth = display_bufnames ? 3 : 2
  let [query, args] = (a:0 && type(a:1) == type('')) ?
        \ [a:1, a:000[1:]] : ['', a:000]
  return vimrc#fzf#fzf('lines', {
  \ 'source':  lines,
  \ 'sink*':   function('vimrc#fzf#line#lines_sink'),
  \ 'options': ['+m', '--tiebreak=index', '--prompt', 'Lines> ', '--ansi', '--extended', '--nth='.nth.'..', '--tabstop=1', '--query', query]
  \}, args)
endfunction
