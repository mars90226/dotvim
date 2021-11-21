" sdcv
if executable('sdcv')
  nnoremap <Leader>sd :execute vimrc#utility#get_sdcv_command() . ' ' . expand('<cword>')<CR>
  xnoremap <Leader>sd :<C-U>execute vimrc#utility#get_sdcv_command() . " '" . vimrc#utility#get_visual_selection() . "'"<CR>
  nnoremap <Space>sd  :call vimrc#utility#execute_command(vimrc#utility#get_sdcv_command(), 'sdcv: ')<CR>
endif

" translate-shell
if executable('trans')
  nnoremap <Leader><C-K><C-K> :execute vimrc#utility#get_translate_shell_command() . ' ' . expand('<cword>')<CR>
  xnoremap <Leader><C-K><C-K> :<C-U>execute vimrc#utility#get_translate_shell_command() . ' ' . expand('<cword>')<CR>
  nnoremap <Space><C-K><C-K> :call vimrc#utility#execute_command(vimrc#utility#get_translate_shell_command(), 'trans: ')<CR>
endif
