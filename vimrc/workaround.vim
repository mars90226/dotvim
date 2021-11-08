" disable Background Color Erase (BC) by clearing the `t_ut` on Synology DSM
" see https://sunaku.github.io/vim-256color-bce.html
if vimrc#plugin#check#get_os() =~# 'synology' && !has('nvim')
  set t_ut=
endif

" Backspace in ConEmu will translate to 0x07F when using xterm
" https://conemu.github.io/en/VimXterm.html
" https://github.com/Maximus5/ConEmu/issues/641
if !empty($ConEmuBuild) && !has('nvim')
  let &t_kb = nr2char(127)
  let &t_kD = '^[[3~'

  " Disable Background Color Erase
  set t_ut=
endif

" Since NVIM v0.4.0-464-g5eaa45547, commit 5eaa45547975c652e594d0d6dbe34c1316873dc7
" 'secure' is set when 'modeline' is set, which will cause a lot of commands
" cannot run in autocmd when opening help page.
augroup secure_modeline_conflict_workaround
  autocmd!
  autocmd FileType help setlocal nomodeline
augroup END
