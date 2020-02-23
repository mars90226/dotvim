" Denite only has 1 active buffer per tab
" buffer-name should be tab-based
function! vimrc#denite#get_buffer_name(prefix) abort
  return a:prefix . '%' . tabpagenr()
endfunction

function! vimrc#denite#grep(query, buffer_name_prefix, option, is_word) abort
  let escaped_query = vimrc#escape_symbol(a:query)
  let escaped_option = vimrc#escape_symbol(a:option)
  let final_query = a:is_word ? '\\b' . escaped_query . '\\b' : escaped_query
  let buffer_name = vimrc#denite#get_buffer_name(a:buffer_name_prefix)

  execute 'Denite -buffer-name=' . buffer_name . ' -auto-resume grep:.:' . escaped_option . ':' . final_query
endfunction

function! vimrc#denite#project_tags(query)
  let t:origin_tags = &tags
  set tags-=./tags;
  augroup denite_project_tags_callback
    autocmd!
    autocmd BufWinLeave \[denite\]
          \ if exists('t:origin_tags') |
          \   let &tags = t:origin_tags |
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

" Assume preview floating window is previous window of denite buffer
function! vimrc#denite#goto_and_back_between_preview()
  if bufname('%') =~# '\[denite\]'
    wincmd W
    nnoremap <silent><buffer> <M-l> :call vimrc#denite#goto_and_back_between_preview()<CR>
  else
    wincmd w
  endif
endfunction

" Denite buffer normal mode
function! vimrc#denite#mappings()
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
endfunction

" Denite buffer insert mode
function! vimrc#denite#filter_mappings()
  " Denite filter buffer
  inoremap <silent><buffer><expr> <Esc> denite#do_map('quit')
  inoremap <silent><buffer><expr> <C-C> denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc> denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-C> denite#do_map('quit')
  nnoremap <silent><buffer><expr> q     denite#do_map('quit')

  " Cursor movements
  " Reserve <C-o> for moving cursor
  imap     <silent><buffer>         <C-F> <Plug>(denite_filter_quit)
  " Reserve a key mapping for entering normal mode
  inoremap <silent><buffer>         <M-q> <Esc>
  inoremap <silent><buffer>         <C-B> <C-O>^
  inoremap <silent><buffer><nowait> <C-E> <C-O>$

  " Actions
  inoremap <silent><buffer><expr> <Tab> denite#do_map('choose_action')
  inoremap <silent><buffer><expr> <C-L> denite#do_map('redraw')

  inoremap <silent><buffer> <C-J>
        \ <Esc>:call vimrc#denite#move_cursor_candidate_window('j', 1)<CR>
  inoremap <silent><buffer> <C-K>
        \ <Esc>:call vimrc#denite#move_cursor_candidate_window('k', 1)<CR>
  inoremap <silent><buffer> <M-j>
        \ <Esc>:call vimrc#denite#move_cursor_candidate_window('j', g:denite_height)<CR>
  inoremap <silent><buffer> <M-k>
        \ <Esc>:call vimrc#denite#move_cursor_candidate_window('k', g:denite_height)<CR>
  inoremap <silent><buffer><expr> <CR>  denite#do_map('do_action')
  nnoremap <silent><buffer><expr> <CR>  denite#do_map('do_action')
  inoremap <silent><buffer><expr> <M-o> denite#do_map('do_action', 'open')
  inoremap <silent><buffer><expr> <C-S> denite#do_map('do_action', 'split')
  inoremap <silent><buffer><expr> <C-T> denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-V> denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <M-p> denite#do_map('do_action', 'preview')
  inoremap <silent><buffer><expr> <M-d> denite#do_map('do_action', 'cd')
  inoremap <silent><buffer><expr> <M-s> denite#do_map('do_action', 'splitswitch')
  inoremap <silent><buffer><expr> <M-t> denite#do_map('do_action', 'tabswitch')
  inoremap <silent><buffer><expr> <M-v> denite#do_map('do_action', 'vsplitswitch')
  inoremap <silent><buffer><expr> <M-w> denite#do_map('do_action', 'switch')

  " Switch between denite buffer & preview
  imap     <silent><buffer> <M-l> <Plug>(denite_filter_quit):call vimrc#denite#goto_and_back_between_preview()<CR>

  " Toggle matchers & sorters
  inoremap <silent><buffer><expr> <M-f>
        \ denite#do_map('toggle_matchers', 'matcher/fruzzy')
  inoremap <silent><buffer><expr> <M-g>
        \ denite#do_map('toggle_matchers', 'matcher/substring')
  inoremap <silent><buffer><expr> <M-`>
        \ denite#do_map('toggle_matchers', 'matcher/regexp')
  inoremap <silent><buffer><expr> <M-r>
        \ denite#do_map('change_sorters', 'sorter/reverse')
endfunction
