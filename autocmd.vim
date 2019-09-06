" Put these in an autocmd group, so that we can delete them easily.
augroup lastPositionSetting
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif
augroup END

augroup vimGeneralCallbacks
  autocmd!
  autocmd BufWritePost _vimrc nested call vimrc#reload#reload() | e | normal! zzzv
  autocmd BufWritePost .vimrc nested call vimrc#reload#reload() | e | normal! zzzv
augroup END

augroup fileTypeSpecific
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " Rack
  autocmd BufNewFile,BufReadPost *.ru                 set filetype=ruby

  " gdb
  autocmd BufNewFile,BufReadPost *.gdbinit            set filetype=gdb

  " gitcommit
  autocmd FileType gitcommit setlocal spell complete+=k

  " Custom filetype
  autocmd BufNewFile,BufReadPost *maillog             set filetype=messages
  autocmd BufNewFile,BufReadPost *maillog.*.xz        set filetype=messages
  autocmd BufNewFile,BufReadPost *conf                set filetype=conf
  autocmd BufNewFile,BufReadPost *conf.local          set filetype=conf
  autocmd BufNewFile,BufReadPost *conf.local.override set filetype=conf
  autocmd BufNewFile,BufReadPost *.cf                 set filetype=conf
  autocmd BufNewFile,BufReadPost .gitignore           set filetype=conf
  autocmd BufNewFile,BufReadPost .ignore              set filetype=conf
  autocmd BufNewFile,BufReadPost */conf/template/*    set filetype=conf
  autocmd BufNewFile,BufReadPost */rspamd/*.inc       set filetype=conf
  autocmd BufNewFile,BufReadPost */upstart/*conf      set filetype=upstart
  autocmd BufNewFile,BufReadPost *.upstart            set filetype=upstart
  autocmd BufNewFile,BufReadPost Makefile.inc         set filetype=make
  autocmd BufNewFile,BufReadPost depends              set filetype=dosini
  autocmd BufNewFile,BufReadPost depends-virtual-*    set filetype=dosini
  autocmd BufNewFile,BufReadPost .tmux.conf           set filetype=tmux
  autocmd BufNewFile,BufReadPost resource             set filetype=json
  autocmd BufNewFile,BufReadPost *.bashrc             set filetype=sh

  " Custom build log syntax
  autocmd BufNewFile,BufReadPost *.build              set filetype=cerr

  " FileType settings
  autocmd FileType vim call s:filetype_vim_settings()
  autocmd FileType python call s:filetype_python_settings()
augroup END

function! s:filetype_vim_settings()
  setlocal shiftwidth=2
  setlocal tabstop=2
  setlocal softtabstop=2
  setlocal expandtab
endfunction

function! s:filetype_python_settings()
  setlocal shiftwidth=4
  setlocal tabstop=4
  setlocal softtabstop=4
  setlocal expandtab

  nnoremap <silent><buffer> K :call vimrc#coc#show_documentation()<CR>
  nnoremap <silent><buffer> gK :execute 'Pydoc ' . expand('<cword>')<CR>
endfunction
