" Functions
function! vimrc#mapping#include_cursor_mappings(command, cword_key, cWORD_key)
  execute 'nnoremap '.a:cword_key." :execute '".a:command." '.expand('<cword>')<CR>"
  execute 'nnoremap '.a:cWORD_key." :execute '".a:command." '.expand('<cWORD>')<CR>"
endfunction

function! vimrc#mapping#include_visual_selection_mappings(command, key)
  execute 'xnoremap '.a:key." :<C-U>execute '".a:command." '.vimrc#utility#get_visual_selection()<CR>"
endfunction
