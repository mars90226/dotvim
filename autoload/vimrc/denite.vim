" Denite only has 1 active buffer per tab
" buffer-name should be tab-based
function! vimrc#denite#get_buffer_name(prefix) abort
  return a:prefix . '%' . tabpagenr()
endfunction

function! vimrc#denite#grep(folder, query, buffer_name_prefix, option, is_word) abort
  let escaped_query = vimrc#utility#denite_escape_symbol(a:query)
  let escaped_option = vimrc#utility#denite_escape_symbol(a:option)
  let final_query = a:is_word ? '\\b' . escaped_query . '\\b' : escaped_query
  let buffer_name = vimrc#denite#get_buffer_name(a:buffer_name_prefix)

  execute 'Denite -buffer-name=' . buffer_name . ' grep:' . a:folder . ':' . escaped_option . ':' . final_query
endfunction

function! vimrc#denite#project_tags(query) abort
  let t:origin_tags = vimrc#tags#use_project_tags()

  augroup denite_project_tags_callback
    autocmd!
    autocmd BufWinLeave \[denite\]
          \ if exists('t:origin_tags') |
          \   call vimrc#tags#restore_tags(t:origin_tags) |
          \   autocmd! denite_project_tags_callback |
          \ endif
  augroup END
  execute 'Denite tag -input=' . a:query
endfunction

function! vimrc#denite#move_cursor_candidate_window(dir, lines) abort
  call win_gotoid(win_findbuf(g:denite#_filter_parent)[0])
  execute 'normal! ' . a:lines . a:dir
  call win_gotoid(g:denite#_filter_winid)
  startinsert!
endfunction

" Assume denite window order in floating window
" 1. denite preview buffer
" 2. denite filter buffer
" 3. denite buffer
function! vimrc#denite#goto_and_back_between_preview() abort
  if vimrc#denite#is_denite_buffer(bufname('%'))
    wincmd W
    wincmd W
    " FIXME: Need to define original mapping here
    nnoremap <Plug>(default-meta-l) <C-W>l
    nnoremap <Plug>(default-meta-i) <Nop>
    nmap <silent><buffer><expr> <M-l> vimrc#denite#is_active() ? ":call vimrc#denite#goto_and_back_between_preview()\<CR>" : "\<Plug>(default-meta-l)"
    nmap <silent><buffer><expr> <M-i> vimrc#denite#is_active() ? "\<C-W>w\<C-W>w".denite#do_map('open_filter_buffer') : "\<Plug>(default-meta-i)"
  else
    wincmd w
    wincmd w
  endif
endfunction

" Utilities
let s:denite_actions = {
  \ 'move_cursor': 'vimrc#denite#move_cursor_candidate_window'
  \ }

function! vimrc#denite#use_clap() abort
  return executable(vimrc#clap#get_clap_fuzzymatch_rs_so()) || (vimrc#plugin#is_enabled_plugin('vim-clap') && vimrc#plugin#check#has_cargo())
endfunction

" Borrowed from denite.nvim
function! vimrc#denite#do_map(name, ...) abort
  let args = copy(a:000)
  let esc = (mode() ==# 'i' ? "\<C-O>" : '')
  let denite_action = get(s:denite_actions, a:name)
  return printf(esc . ":\<C-U>call vimrc#denite#call_map(%s, %s)\<CR>",
        \ string(denite_action), string(args))
endfunction

function! vimrc#denite#call_map(function, args) abort
  call call(a:function, a:args)
endfunction

function! vimrc#denite#toggle_matchers(...) abort
  call denite#call_map('toggle_matchers', a:000)
endfunction

function! vimrc#denite#change_sorters(sorter) abort
  call denite#call_map('change_sorters', [a:sorter])
endfunction

function! vimrc#denite#is_denite_buffer(bufname) abort
  return a:bufname =~# '\[denite\]'
endfunction

function! vimrc#denite#is_active() abort
  for buffer in tabpagebuflist(tabpagenr())
    if vimrc#denite#is_denite_buffer(bufname(buffer))
      return v:true
    endif
  endfor
  return v:false
endfunction

" Completions
function! vimrc#denite#complete_matchers(ArgLead, CmdLine, CursorPos) abort
  return [
    \ 'matcher/clap',
    \ 'matcher/cpsm',
    \ 'matcher/fuzzy',
    \ 'matcher/hide_hidden_files',
    \ 'matcher/project_files',
    \ 'matcher/ignore_current_buffer',
    \ 'matcher/ignore_globs',
    \ 'matcher/regexp',
    \ 'matcher/substring',
    \ ]
endfunction

function! vimrc#denite#complete_sorters(ArgLead, CmdLine, CursorPos) abort
  return [
    \ 'sorter/rank',
    \ 'sorter/reverse',
    \ 'sorter/sublime',
    \ 'sorter/word',
    \ ]
endfunction

" Settings
function! vimrc#denite#settings() abort
  call vimrc#denite#common_commands()
  call vimrc#denite#mappings()
endfunction

function! vimrc#denite#filter_settings() abort
  call vimrc#denite#common_commands()
  call vimrc#denite#filter_mappings()
endfunction

" Commands
function! vimrc#denite#common_commands() abort
  command! -buffer -nargs=+ -complete=customlist,vimrc#denite#complete_matchers DeniteToggleMatchers call vimrc#denite#toggle_matchers(<f-args>)
  command! -buffer -nargs=1 -complete=customlist,vimrc#denite#complete_sorters DeniteChangeSorters call vimrc#denite#change_sorters(<f-args>)
endfunction

" Mappings
" Denite buffer normal mode
function! vimrc#denite#mappings() abort
  " Denite buffer
  nnoremap <silent><buffer><expr> <Esc> denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-c> denite#do_map('quit')
  nnoremap <silent><buffer><expr> q     denite#do_map('quit')
  nnoremap <silent><buffer><expr> i     denite#do_map('open_filter_buffer')

  " Actions
  nnoremap <silent><buffer><expr> *
        \ denite#do_map('toggle_select_all')
  nnoremap <silent><buffer><expr> .
        \ denite#do_map('do_previous_action')
  nnoremap <silent><buffer><nowait><expr> `
        \ denite#do_map('toggle_select').'j'
  nnoremap <silent><buffer><nowait><expr> <M-`>
        \ denite#do_map('toggle_select')
  nnoremap <silent><buffer><expr> <C-L>
        \ denite#do_map('redraw')
  nnoremap <silent><buffer><expr> <C-R>
        \ denite#do_map('restart')
  nnoremap <silent><buffer><expr> <Tab>
        \ denite#do_map('choose_action')
  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
        \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> e
        \ denite#do_map('do_action', 'edit')
  nnoremap <silent><buffer><expr> n
        \ denite#do_map('do_action', 'new')
  nnoremap <silent><buffer><expr> o
        \ denite#do_map('do_action', 'open')
  nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> P
        \ denite#do_map('do_action', 'preview_bat')
  nnoremap <silent><buffer><expr> r
        \ denite#do_map('do_action', 'quickfix')
  nnoremap <silent><buffer><expr> s
        \ denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> t
        \ denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> v
        \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> u
        \ denite#do_map('restore_sources')
  nnoremap <silent><buffer><expr> x
        \ denite#do_map('quick_move')
  nnoremap <silent><buffer><expr> Y
        \ denite#do_map('do_action', 'yank')
  nnoremap <silent><buffer><expr> <M-s>
        \ denite#do_map('do_action', 'splitswitch')
  nnoremap <silent><buffer><expr> <M-t>
        \ denite#do_map('do_action', 'tabswitch')
  nnoremap <silent><buffer><expr> <M-v>
        \ denite#do_map('do_action', 'vsplitswitch')
  nnoremap <silent><buffer><expr> <M-w>
        \ denite#do_map('do_action', 'switch')

  " Switch between denite buffer & preview
  nnoremap <silent><buffer> <M-l> :call vimrc#denite#goto_and_back_between_preview()<CR>

  " Switch to filter buffer
  nnoremap <silent><buffer><expr> <M-i> denite#do_map('open_filter_buffer')

  " Use <M-j>/<M-k> to scroll down/up
  nnoremap <silent><buffer> <M-j> <C-F>
  nnoremap <silent><buffer> <M-k> <C-B>
endfunction

" Denite buffer insert mode
function! vimrc#denite#filter_mappings() abort
  " Denite filter buffer
  inoremap <silent><buffer><expr> <Esc> pumvisible() ? "\<C-E>" : denite#do_map('quit')
  inoremap <silent><buffer><expr> <C-C> denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc> denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-C> denite#do_map('quit')
  nnoremap <silent><buffer><expr> q     denite#do_map('quit')

  " Cursor movements
  " Reserve <C-o> for moving cursor
  imap     <silent><buffer>         <C-F> <Plug>(denite_filter_update)
  " Reserve a key mapping for entering normal mode
  inoremap <silent><buffer>         <M-q> <Esc>
  inoremap <silent><buffer>         <C-B> <C-O>^
  inoremap <silent><buffer><nowait> <C-E> <C-O>$

  " History
  inoremap <silent><buffer> <C-P> <Up>
  inoremap <silent><buffer> <C-N> <Down>

  " Completion
  inoremap <silent><buffer> <M-p> <C-P>
  inoremap <silent><buffer> <M-n> <C-N>

  " Actions
  inoremap <silent><buffer><expr> <Tab> denite#do_map('choose_action')
  inoremap <silent><buffer><expr> <C-L> denite#do_map('redraw')

  inoremap <silent><buffer><expr> <C-J> vimrc#denite#do_map('move_cursor', 'j', 1)
  inoremap <silent><buffer><expr> <C-K> vimrc#denite#do_map('move_cursor', 'k', 1)
  inoremap <silent><buffer><expr> <M-j> vimrc#denite#do_map('move_cursor', 'j', g:denite_height)
  inoremap <silent><buffer><expr> <M-k> vimrc#denite#do_map('move_cursor', 'k', g:denite_height)
  inoremap <silent><buffer><expr> <CR>  denite#do_map('do_action')
  nnoremap <silent><buffer><expr> <CR>  denite#do_map('do_action')
  inoremap <silent><buffer><expr> <M-o> denite#do_map('do_action', 'open')
  inoremap <silent><buffer><expr> <C-S> denite#do_map('do_action', 'split')
  inoremap <silent><buffer><expr> <C-T> denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-V> denite#do_map('do_action', 'vsplit')
  " <C-_> and <C-/> are the same key
  " Avoid using <C-_> as it's conflict with tcomment
  inoremap <silent><buffer><expr> <M-/> denite#do_map('do_action', 'preview')
  inoremap <silent><buffer><expr> <M-d> denite#do_map('do_action', 'cd')
  inoremap <silent><buffer><expr> <M-s> denite#do_map('do_action', 'splitswitch')
  inoremap <silent><buffer><expr> <M-t> denite#do_map('do_action', 'tabswitch')
  inoremap <silent><buffer><expr> <M-v> denite#do_map('do_action', 'vsplitswitch')
  inoremap <silent><buffer><expr> <M-w> denite#do_map('do_action', 'switch')

  " Toggle select
  inoremap <silent><buffer><expr> <M-`> denite#do_map('toggle_select').
        \ vimrc#denite#do_map('move_cursor', 'j', 1)
  inoremap <silent><buffer><expr> <M-*>
        \ denite#do_map('toggle_select_all')

  " Horizontal scroll
  inoremap <silent><buffer><expr> <M-H> vimrc#denite#do_map('move_cursor', 'zH', 1)
  inoremap <silent><buffer><expr> <M-L> vimrc#denite#do_map('move_cursor', 'zL', 1)

  " Switch between denite buffer & preview
  imap <silent><buffer> <M-l>      <Plug>(denite_filter_update):call vimrc#denite#goto_and_back_between_preview()<CR>

  " Integration with other plugins
  imap <buffer>         <M-x><M-c> <Plug>(denite_filter_update):ColorToggle<CR>i

  " Toggle matchers & sorters
  if vimrc#denite#use_clap()
    inoremap <silent><buffer><expr> <M-f>
          \ denite#do_map('toggle_matchers', 'matcher/clap')
  else
    inoremap <silent><buffer><expr> <M-f>
          \ denite#do_map('toggle_matchers', 'matcher/fruzzy')
  endif
  inoremap <silent><buffer><expr> <M-g>
        \ denite#do_map('toggle_matchers', 'matcher/substring')
  inoremap <silent><buffer><expr> <M-r>
        \ denite#do_map('toggle_matchers', 'matcher/regexp')
  inoremap <silent><buffer><expr> <M-;>
        \ denite#do_map('change_sorters', 'sorter/reverse')
endfunction
