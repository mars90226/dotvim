" Input Method autocmd
augroup input_method_settings
  autocmd!
  autocmd InsertEnter * setlocal iminsert=1
  autocmd InsertLeave * setlocal iminsert=0
augroup END

" Ignore foldmethod in insert mode to speed up
augroup insert_mode_foldmethod_settings
  autocmd!

  " ref. http://vim.wikia.com/wiki/Keep_folds_closed_while_inserting_text
  " Don't screw up folds when inserting text that might affect them, until
  " leaving insert mode. Foldmethod is local to the window. Protect against
  " screwing up folding when switching between windows.
  autocmd InsertEnter * if !exists("w:last_fdm") | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
  autocmd InsertLeave,WinLeave * if exists("w:last_fdm") | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif
augroup END

" Prompt buffer settings
" FIXME: not work
" augroup prompt_buffer_settings
"   autocmd!
"
"   autocmd BufNewFile,BufReadPost * if &buftype ==# 'prompt' | inoremap <buffer> <C-W> <C-S-W> | endif
"   autocmd BufNewFile,BufReadPost * if &buftype ==# 'prompt' | inoremap <buffer> <A-w> <C-W> | endif
" augroup END

" Command-line window settings
augroup cmdline_window_settings
  autocmd!
  " Removing any key mapping for <CR> in cmdline-window
  autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
augroup END

" Highlight yank
" FIXME: Only highlight text background, not space background
" augroup highlight_yank
"   autocmd!
"   autocmd TextYankPost * silent! lua vim.highlight.on_yank({ timeout = 200 })
" augroup END

" Since NVIM v0.4.0-464-g5eaa45547, commit 5eaa45547975c652e594d0d6dbe34c1316873dc7
" 'secure' is set when 'modeline' is set, which will cause a lot of commands
" cannot run in autocmd when opening help page.
augroup secure_modeline_conflict_workaround
  autocmd!
  autocmd FileType help setlocal nomodeline
augroup END

" Secret project local settings
if exists('*VimSecretProjectLocalSettings')
  call VimSecretProjectLocalSettings()
endif

" Machine-local project local settings
if exists('*VimLocalProjectLocalSettings')
  call VimLocalProjectLocalSettings()
endif
