" Input Method autocmd
augroup input_method_settings
  autocmd!
  autocmd InsertEnter * setlocal iminsert=1
  autocmd InsertLeave * setlocal iminsert=0
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
augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({ timeout = 200 })
augroup END

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
