function! vimrc#unite#grep(folder, query, buffer_name_prefix, option, is_word) abort
  let escaped_query = vimrc#utility#denite_escape_symbol(a:query)
  let escaped_option = vimrc#utility#denite_escape_symbol(a:option)
  let final_query = a:is_word ? '\\b' . escaped_query . '\\b' : escaped_query
  let buffer_name = a:buffer_name_prefix . '%' . bufnr('%')

  execute 'Unite -buffer-name=' . buffer_name . ' -wrap grep:' . a:folder . ':' . escaped_option . ':' . final_query
endfunction

function! vimrc#unite#mappings() "{{{ abort
  " Overwrite settings.

  imap <buffer> jj      <Plug>(unite_insert_leave)
  "imap <buffer> <C-W>     <Plug>(unite_delete_backward_path)

  imap <buffer><expr> j unite#smart_map('j', '')
  imap <buffer> <C-W>     <Plug>(unite_delete_backward_path)
  imap <buffer> <C-\>'     <Plug>(unite_quick_match_default_action)
  nmap <buffer> '     <Plug>(unite_quick_match_default_action)
  imap <buffer><expr> x
        \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
  nmap <buffer> x     <Plug>(unite_quick_match_choose_action)
  nmap <buffer> <C-Z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-Z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-Y>     <Plug>(unite_input_directory)
  nmap <buffer> <C-Y>     <Plug>(unite_input_directory)
  nmap <buffer> <M-a>     <Plug>(unite_toggle_auto_preview)
  nmap <buffer> <M-p>     <Plug>(unite_print_candidate)
  nmap <buffer> <C-R>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-R><C-R>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-X><C-X>     <Plug>(unite_complete)
  " nnoremap <silent><buffer><expr> l
  "       \ unite#smart_map('l', unite#do_action('default'))

  " Restore tab switch mapping
  nnoremap <buffer> <C-J>     gT
  nnoremap <buffer> <C-K>     gt

  " Move cursor in insert mode
  imap <buffer> <C-J>     <Plug>(unite_select_next_line)
  imap <buffer> <C-K>     <Plug>(unite_select_previous_line)

  let unite = unite#get_current_unite()
  if unite.profile_name ==# 'search'
    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  endif

  nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
  nnoremap <buffer><expr> S      unite#mappings#set_current_filters(
        \ empty(unite#mappings#get_current_filters()) ?
        \ ['sorter_reverse'] : [])

  " Runs "switch" action by <M-s>.
  imap <silent><buffer><expr> <M-s>     unite#do_action('switch')
  nmap <silent><buffer><expr> <M-s>     unite#do_action('switch')

  " Runs "tabswitch" action by <M-t>.
  imap <silent><buffer><expr> <M-t>     unite#do_action('tabswitch')
  nmap <silent><buffer><expr> <M-t>     unite#do_action('tabswitch')

  " Runs "split" action by <C-S>.
  imap <silent><buffer><expr> <C-S>     unite#do_action('split')
  nmap <silent><buffer><expr> <C-S>     unite#do_action('split')

  " Runs "vsplit" action by <C-V>.
  imap <silent><buffer><expr> <C-V>     unite#do_action('vsplit')
  nmap <silent><buffer><expr> <C-V>     unite#do_action('vsplit')

  " Runs "tabopen" action by <C-T>.
  nmap <silent><buffer><expr> <C-T>     unite#do_action('tabopen')

  " Runs "persist_open" action by <C-]>.
  imap <silent><buffer><expr> <C-]>     unite#do_action('persist_open')
  nmap <silent><buffer><expr> <C-]>     unite#do_action('persist_open')

  " Simulate "persist_tabopen" action by <M-]>.
  imap <silent><buffer><expr> <M-]>     unite#do_action('persist_open') . "\<C-W>j:tab split<CR>gT<C-O>zzzv<C-W>k"
  nmap <silent><buffer><expr> <M-]>     unite#do_action('persist_open') . "\<C-W>j:tab split<CR>gT<C-O>zzzv<C-W>k"

  " Simulate "persist_tabopen_switch" action by <M-[>.
  imap <silent><buffer><expr> <M-[>     unite#do_action('persist_open') . "\<C-W>j:tab split<CR>gT<C-O>zzzvgt"
  nmap <silent><buffer><expr> <M-[>     unite#do_action('persist_open') . "\<C-W>j:tab split<CR>gT<C-O>zzzvgt"

  " Runs "grep" action by <M-g>.
  imap <silent><buffer><expr> <M-g>     unite#do_action('grep')
  nmap <silent><buffer><expr> <M-g>     unite#do_action('grep')

  " Unmap <Space>, use ` instead
  silent! nunmap <buffer> <Space>
  nmap <silent><buffer><nowait> ` <Plug>(unite_toggle_mark_current_candidate)
  silent! xunmap <buffer> <Space>
  xmap <silent><buffer><nowait> ` <Plug>(unite_toggle_mark_selected_candidates)
endfunction "}}}

" Should be loaded after lazy load, cause unimpaired is lazy loaded
function! vimrc#unite#post_loaded_mappings() abort
  " Avoid remapped by unimpaired
  silent! unmap [u
  silent! unmap [uu
  silent! unmap ]u
  silent! unmap ]uu

  nnoremap <silent><nowait> ]u :<C-U>execute v:count1 . 'UniteNext'<CR>
  nnoremap <silent><nowait> [u :<C-U>execute v:count1 . 'UnitePrevious'<CR>
  nnoremap <silent> [U :UniteFirst<CR>
  nnoremap <silent> ]U :UniteLast<CR>
endfunction
