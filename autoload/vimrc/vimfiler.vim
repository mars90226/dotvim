" Mappings
function! vimrc#vimfiler#mappings() abort
  " Runs "tabopen" action by <C-T>.
  nmap <silent><buffer><expr> <C-T>     vimfiler#do_action('tabopen')

  " Runs "choose" action by <C-C>.
  nmap <silent><buffer><expr> <C-C>     vimfiler#do_action('choose')

  " Toggle no_quit with <C-N>
  nmap <silent><buffer>       <C-N>     :let b:vimfiler.context.quit = !b:vimfiler.context.quit<CR>

  " Unmap <Space>, use ` instead
  silent! nunmap <buffer> <Space>
  nmap <silent><buffer>       `         <Plug>(vimfiler_toggle_mark_current_line)
endfunction
