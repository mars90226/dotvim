" Put these in an autocmd group, so that we can delete them easily.
" TODO May consider removing this augroup and only use :ReloadVimrc to reload
augroup vimGeneralCallbacks
  autocmd!
  autocmd BufWritePost .vimrc   nested call vimrc#reload#reload() | e | normal! zzzv
  autocmd BufWritePost _vimrc   nested call vimrc#reload#reload() | e | normal! zzzv
  autocmd BufWritePost init.vim nested call vimrc#reload#reload() | e | normal! zzzv
augroup END

augroup fileTypeSpecific
  autocmd!

  " Custom filetype
  autocmd BufNewFile,BufReadPost *.ru                 set filetype=ruby
  autocmd BufNewFile,BufReadPost *.gdbinit            set filetype=gdb
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
  autocmd BufNewFile,BufReadPost *.sieve              set filetype=sieve

  " Custom build log syntax
  autocmd BufNewFile,BufReadPost *.build              set filetype=cerr
augroup END

" Input Method autocmd
augroup input_method_settings
  autocmd!

  autocmd InsertEnter * setlocal iminsert=1
  autocmd InsertLeave * setlocal iminsert=0
augroup END

" Secret project local settings
if exists('*VimSecretProjectLocalSettings')
  call VimSecretProjectLocalSettings()
endif
