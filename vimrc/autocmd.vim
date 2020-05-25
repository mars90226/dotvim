" Put these in an autocmd group, so that we can delete them easily.
" TODO May consider removing this augroup and only use :ReloadVimrc to reload
augroup vim_auto_reload_settings
  autocmd!
  autocmd BufWritePost .vimrc   nested call vimrc#reload#reload() | e | normal! zzzv
  autocmd BufWritePost _vimrc   nested call vimrc#reload#reload() | e | normal! zzzv
  autocmd BufWritePost init.vim nested call vimrc#reload#reload() | e | normal! zzzv
augroup END

augroup filetype_detection_settings
  autocmd!

  " Custom filetype
  autocmd BufNewFile,BufReadPost *.ru                 setlocal filetype=ruby
  autocmd BufNewFile,BufReadPost *.gdbinit            setlocal filetype=gdb
  autocmd BufNewFile,BufReadPost *maillog             setlocal filetype=messages
  autocmd BufNewFile,BufReadPost *maillog.*.xz        setlocal filetype=messages
  autocmd BufNewFile,BufReadPost *conf                setlocal filetype=conf
  autocmd BufNewFile,BufReadPost *conf.local          setlocal filetype=conf
  autocmd BufNewFile,BufReadPost *conf.local.override setlocal filetype=conf
  autocmd BufNewFile,BufReadPost *.cf                 setlocal filetype=conf
  autocmd BufNewFile,BufReadPost .gitignore           setlocal filetype=conf
  autocmd BufNewFile,BufReadPost .ignore              setlocal filetype=conf
  autocmd BufNewFile,BufReadPost */conf/template/*    setlocal filetype=conf
  autocmd BufNewFile,BufReadPost */rspamd/*.inc       setlocal filetype=conf
  autocmd BufNewFile,BufReadPost */upstart/*conf      setlocal filetype=upstart
  autocmd BufNewFile,BufReadPost *.upstart            setlocal filetype=upstart
  autocmd BufNewFile,BufReadPost Makefile.inc         setlocal filetype=make
  autocmd BufNewFile,BufReadPost depends              setlocal filetype=dosini
  autocmd BufNewFile,BufReadPost depends-virtual-*    setlocal filetype=dosini
  autocmd BufNewFile,BufReadPost .tmux.conf           setlocal filetype=tmux
  autocmd BufNewFile,BufReadPost resource*            setlocal filetype=json
  autocmd BufNewFile,BufReadPost privilege*           setlocal filetype=json
  autocmd BufNewFile,BufReadPost *.bashrc             setlocal filetype=sh
  autocmd BufNewFile,BufReadPost *.sieve              setlocal filetype=sieve

  " Custom build log syntax
  autocmd BufNewFile,BufReadPost *.build              setlocal filetype=cerr
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

" Machine-local project local settings
if exists('*VimLocalProjectLocalSettings')
  call VimLocalProjectLocalSettings()
endif
