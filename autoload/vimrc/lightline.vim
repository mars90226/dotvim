" Script Enconding: UTF-8
scriptencoding utf-8

let s:lightline_width_threshold = 69

function! vimrc#lightline#filename() abort
  let fname = expand('%:t')
  let fpath = expand('%')

  if fname =~# '__Tagbar__'
    return get(g:lightline, 'fname', fname)
  elseif fname ==# '__vista__'
    return get(g:lightline, 'fname', fname)
  elseif fname ==# '__Mundo__'
    return 'Mundo'
  elseif fname ==# '__Mundo_Preview__'
    return 'Mundo Preview'
  elseif &filetype ==# 'qf'
    return get(w:, 'quickfix_title', '')
  elseif &filetype ==# 'unite'
    return unite#get_status_string()
  elseif &filetype ==# 'vimfiler'
    return vimfiler#get_status_string()
  elseif &filetype ==# 'LuaTree'
    return vimrc#nvim_tree_lua#get_path()
  elseif &filetype ==# 'help'
    let t:current_filename = fname
    return fname
  else
    let readonly = '' !=# vimrc#lightline#readonly() ? vimrc#lightline#readonly() . ' ' : ''
    if fpath =~? '^fugitive'
      let filename = fnamemodify(fugitive#Real(fpath), ':.') . ' [git]'
    else
      let filename = '' !=# fname ? fpath : '[No Name]'
    end
    let modified = '' !=# vimrc#lightline#modified() ? ' ' . vimrc#lightline#modified() : ''

    let t:current_filename = fname
    return readonly . filename . modified
  endif
endfunction

function! vimrc#lightline#readonly() abort
  return &filetype !~? 'help' && &readonly ? '' : ''
endfunction

function! vimrc#lightline#modified() abort
  return &modifiable && &modified ? '+' : ''
endfunction

function! vimrc#lightline#git_status() abort
  if winwidth(0) <= s:lightline_width_threshold
    return ''
  endif

  let status = get(g:, 'coc_git_status', '')
  let buffer_status = get(b:, 'coc_git_status', '')
  return status . buffer_status[1:-2]
endfunction

function! vimrc#lightline#fileformat() abort
  return winwidth(0) > s:lightline_width_threshold ? &fileformat : ''
endfunction

function! vimrc#lightline#filetype() abort
  return winwidth(0) > s:lightline_width_threshold ?
        \ &buftype ==# 'terminal' ? &buftype :
        \ (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! vimrc#lightline#fileencoding() abort
  return winwidth(0) > s:lightline_width_threshold ? (&fileencoding !=# '' ? &fileencoding : &encoding) : ''
endfunction

function! vimrc#lightline#lineinfo() abort
  if winwidth(0) > s:lightline_width_threshold
    return line('.').':'.col('.')
  else
    return ''
  endif
endfunction

function! vimrc#lightline#percent() abort
  if winwidth(0) > s:lightline_width_threshold
    return line('.') * 100 / line('$') . '%'
  else
    return ''
  endif
endfunction

function! vimrc#lightline#coc_status() abort
  if winwidth(0) > s:lightline_width_threshold && vimrc#plugin#is_enabled_plugin('coc.nvim') && exists('*coc#status')
    return coc#status()
  else
    return ''
  endif
endfunction

function! vimrc#lightline#mode() abort
  let fname = expand('%:t')
  return fname =~# '__Tagbar__' ? 'Tagbar' :
        \ fname ==# '__vista__' ? 'Vista' :
        \ fname ==# '__Mundo__' ? 'Mundo' :
        \ fname ==# '__Mundo_Preview__' ? 'Mundo Preview' :
        \ &filetype ==# 'qf' ? vimrc#lightline#quickfix_mode() :
        \ &filetype ==# 'unite' ? 'Unite' :
        \ &filetype ==# 'vimfiler' ? 'VimFiler' :
        \ &filetype ==# 'LuaTree' ? 'LuaTree' :
        \ &filetype ==# 'fugitive' ? 'Fugitive' :
        \ lightline#mode()
endfunction

" Borrowed from vim-airline {{{
function! vimrc#lightline#quickfix_mode() abort
  let dict = getwininfo(win_getid())
  if len(dict) > 0 && get(dict[0], 'quickfix', 0) && !get(dict[0], 'loclist', 0)
    return 'Quickfix'
  elseif len(dict) > 0 && get(dict[0], 'quickfix', 0) && get(dict[0], 'loclist', 0)
    return 'Location'
  endif
endfunction
" }}}

function! vimrc#lightline#tab_filename(n) abort
  let bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
  let fname = expand('#' . bufnr . ':t')
  let ftype = getbufvar(bufnr, '&filetype')
  let FilenameFilter = { fname -> '' !=# fname ? fname : '[No Name]' }
  return fname =~# '__Tagbar__' ? 'Tagbar' :
        \ fname ==# '__vista__' ? 'Vista' :
        \ ftype ==# 'fzf' ? FilenameFilter(gettabvar(a:n, 'current_filename', fname)) :
        \ FilenameFilter(fname)
endfunction

function! vimrc#lightline#tab_modified(n) abort
  let winnr = tabpagewinnr(a:n)
  let bufnr = tabpagebuflist(a:n)[winnr - 1]
  let ftype = getbufvar(bufnr, '&filetype')
  let buftype = getbufvar(bufnr, '&buftype')
  return ftype ==# 'fzf' ? '' :
        \ buftype ==# 'terminal' ? '' :
        \ gettabwinvar(a:n, winnr, '&modified') ? '+' : gettabwinvar(a:n, winnr, '&modifiable') ? '' : '-'
endfunction

function! vimrc#lightline#tagbar_status_func(current, sort, fname, ...) abort
  let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

function! vimrc#lightline#refresh() abort
  if exists('b:lightline_head')
    unlet b:lightline_head
  endif
endfunction

function! vimrc#lightline#nearest_method_or_function() abort
  let vista_method = get(b:, 'vista_nearest_method_or_function', '')
  return vista_method ==# '' ? tagbar#currenttag('%s', '', '') : vista_method
endfunction
