" xterm-256 in Windows {{{
if !has("nvim") && !has("gui_running") && vimrc#plugin#check#get_os() =~ "windows"
  set term=xterm
  set mouse=a
  set t_Co=256
  let &t_AB = "\e[48;5;%dm"
  let &t_AF = "\e[38;5;%dm"
  colorscheme gruvbox
  highlight Pmenu ctermfg=187 ctermbg=239
  highlight PmenuSel ctermbg=95
endif
" }}}

" Pair up with 'set winaltkeys=no' in _gvimrc
" Fix meta key in vim
" terminal meta key fix {{{
if !has("nvim") && !has("gui_running") && vimrc#plugin#check#get_os() !~ "windows"
  " TODO Check if the "windows" condition is wrong
  if vimrc#plugin#check#get_os() =~ "windows"
    " Windows Terminal keycode will change after startup
    " Maybe it's related to ConEmu
    " This fix will not work after reload .vimrc/_vimrc
    augroup WindowsTerminalKeyFix
      autocmd!
      autocmd VimEnter * call vimrc#terminal#meta_key_fix()
    augroup END
  else
    call vimrc#terminal#meta_key_fix()
  endif
endif
" }}}

" neovim terminal key mapping and settings
if has("nvim")
  " Set terminal buffer size to unlimited
  set scrollback=100000

  " For quick terminal access
  nnoremap <silent> <Leader>tr :terminal<CR>i
  nnoremap <silent> <Leader>tt :tabnew <Bar> :terminal<CR>i
  nnoremap <silent> <Leader>ts :new    <Bar> :terminal<CR>i
  nnoremap <silent> <Leader>tv :vnew   <Bar> :terminal<CR>i
  nnoremap <silent> <Leader>td :call vimrc#terminal#tabnew(input('Folder: ', '', 'dir'))<CR>

  " Quick terminal function
  tnoremap <M-F1> <C-\><C-N>
  tnoremap <M-F2> <C-\><C-N>:tabnew<CR>:terminal<CR>i
  tnoremap <M-F3> <C-\><C-N>:Windows<CR>

  " Quickly switch window in terminal
  tnoremap <M-S-h> <C-\><C-N><C-W>h
  tnoremap <M-S-j> <C-\><C-N><C-W>j
  tnoremap <M-S-k> <C-\><C-N><C-W>k
  tnoremap <M-S-l> <C-\><C-N><C-W>l

  " Quickly switch tab in terminal
  tnoremap <M-C-J> <C-\><C-N>gT
  tnoremap <M-C-K> <C-\><C-N>gt

  " Quickly switch to last tab in terminal
  tnoremap <M-1> <C-\><C-N>:LastTab<CR>

  " Quickly paste from register
  tnoremap <expr> <M-r> '<C-\><C-N>"' . nr2char(getchar()) . 'pi'

  " Quickly suspend neovim
  tnoremap <M-C-Z> <C-\><C-N>:suspend<CR>

  " For nested neovim {{{
    " Use <M-q> as prefix

    " Quick terminal function
    tnoremap <M-q>1 <C-\><C-\><C-N>
    tnoremap <M-q>2 <C-\><C-\><C-N>:tabnew<CR>:terminal<CR>i
    tnoremap <M-q>3 <C-\><C-\><C-N>:Windows<CR>

    " Quickly switch window in terminal
    tnoremap <M-q><M-h> <C-\><C-\><C-N><C-W>h
    tnoremap <M-q><M-j> <C-\><C-\><C-N><C-W>j
    tnoremap <M-q><M-k> <C-\><C-\><C-N><C-W>k
    tnoremap <M-q><M-l> <C-\><C-\><C-N><C-W>l

    " Quickly switch tab in terminal
    tnoremap <M-q><C-J> <C-\><C-\><C-N>gT
    tnoremap <M-q><C-K> <C-\><C-\><C-N>gt

    " Quickly switch to last tab in terminal
    tnoremap <M-q><M-1> <C-\><C-\><C-N>:LastTab<CR>

    " Quickly paste from register
    tnoremap <expr> <M-q><M-r> '<C-\><C-\><C-N>"' . nr2char(getchar()) . 'pi'

    " Quickly suspend neovim
    tnoremap <M-q><C-Z> <C-\><C-\><C-N>:suspend<CR>
  " }}}

  augroup terminal_settings
    autocmd!
    autocmd TermOpen * call vimrc#terminal#settings()

    " TODO Start insert mode when cancelling :Windows in terminal mode or
    " selecting another terminal buffer
    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd BufLeave term://* stopinsert

    " Ignore various filetypes as those will close terminal automatically
    " Ignore fzf, coc
    autocmd TermClose term://*
          \ if vimrc#terminal#is_shell_terminal(expand('<afile>')) ||
          \    vimrc#terminal#is_interactive_process(expand('<afile>')) |
          \   call nvim_input('<CR>')  |
          \ endif
  augroup END

  " Search keyword with Google using surfraw {{{
  if executable('sr')
    command! -nargs=1 GoogleKeyword call vimrc#google_keyword(<q-args>)
    nnoremap <Leader>gk :execute 'GoogleKeyword ' . expand('<cword>')<CR>
  endif
  " }}}

  command! Htop new term://htop
  command! Broot vnew term://broot
endif
" }}}
