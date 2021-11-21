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

if executable('tmux')
  command! RefreshDisplay call vimrc#utility#refresh_display()
  command! RefreshSshClient call vimrc#utility#refresh_ssh_client()

  if executable('ssh-agent')
    command! RefreshSshAgent call vimrc#utility#refresh_ssh_agent()
  endif
endif

" Quick execute
if vimrc#plugin#check#get_os() =~# 'windows'
  " Win32
  nnoremap <Leader>xo :call vimrc#windows#execute_current_file()<CR>
  nnoremap <Leader>X :call vimrc#windows#open_terminal_in_current_file_folder()<CR>
  nnoremap <Leader>E :call vimrc#windows#reveal_current_file_folder_in_explorer()<CR>
else
  " Linux
  if executable('xdg-open')
    nnoremap <Leader>xo :execute vimrc#utility#get_xdg_open() . ' ' . expand('%:p')<CR>
  endif
endif

" set appropriate grep programs
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
else
  set grepprg=grep\ -nH\ $*
endif
