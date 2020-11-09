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
  " TODO: Fix *conf, too many false positive
  autocmd BufNewFile,BufReadPost *.ru                 setlocal filetype=ruby
  autocmd BufNewFile,BufReadPost *.gdbinit            setlocal filetype=gdb
  autocmd BufNewFile,BufReadPost *maillog             setlocal filetype=messages
  autocmd BufNewFile,BufReadPost *maillog.*.xz        setlocal filetype=messages
  autocmd BufNewFile,BufReadPost *conf                setlocal filetype=conf
  autocmd BufNewFile,BufReadPost *conf.local          setlocal filetype=conf
  autocmd BufNewFile,BufReadPost *conf.local.override setlocal filetype=conf
  autocmd BufNewFile,BufReadPost *.cf                 setlocal filetype=conf
  autocmd BufNewFile,BufReadPost main.cf              setlocal filetype=pfmain
  autocmd BufNewFile,BufReadPost .gitignore           setlocal filetype=conf
  autocmd BufNewFile,BufReadPost .gitconfig-*         setlocal filetype=gitconfig
  autocmd BufNewFile,BufReadPost .ignore              setlocal filetype=conf
  autocmd BufNewFile,BufReadPost */conf/template/*    setlocal filetype=conf
  autocmd BufNewFile,BufReadPost */rspamd/*.inc       setlocal filetype=conf
  autocmd BufNewFile,BufReadPost */upstart/*conf      setlocal filetype=upstart
  autocmd BufNewFile,BufReadPost *.upstart            setlocal filetype=upstart
  autocmd BufNewFile,BufReadPost Makefile.inc         setlocal filetype=make
  autocmd BufNewFile,BufReadPost depends              setlocal filetype=dosini
  autocmd BufNewFile,BufReadPost depends-virtual-*    setlocal filetype=dosini
  autocmd BufNewFile,BufReadPost settings             setlocal filetype=dosini
  autocmd BufNewFile,BufReadPost settings-virtual-*   setlocal filetype=dosini
  autocmd BufNewFile,BufReadPost strings              setlocal filetype=dosini
  autocmd BufNewFile,BufReadPost strings-virtual-*    setlocal filetype=dosini
  autocmd BufNewFile,BufReadPost PKG_DEPS             setlocal filetype=dosini
  autocmd BufNewFile,BufReadPost .tmux.conf           setlocal filetype=tmux
  autocmd BufNewFile,BufReadPost */conf/resource*     setlocal filetype=json
  autocmd BufNewFile,BufReadPost */conf/privilege*    setlocal filetype=json
  autocmd BufNewFile,BufReadPost config.define        setlocal filetype=json
  autocmd BufNewFile,BufReadPost config.define.cfg    setlocal filetype=json
  autocmd BufNewFile,BufReadPost config.debug         setlocal filetype=json
  autocmd BufNewFile,BufReadPost config.debug.cfg     setlocal filetype=json
  autocmd BufNewFile,BufReadPost *.bashrc             setlocal filetype=sh
  autocmd BufNewFile,BufReadPost *.sieve              setlocal filetype=sieve
  autocmd BufNewFile,BufReadPost */backup/export      setlocal filetype=sh
  autocmd BufNewFile,BufReadPost */backup/import      setlocal filetype=sh
  autocmd BufNewFile,BufReadPost */backup/can_export  setlocal filetype=sh
  autocmd BufNewFile,BufReadPost */backup/can_import  setlocal filetype=sh
  autocmd BufNewFile,BufReadPost */backup/info        setlocal filetype=json
  autocmd BufNewFile,BufReadPost */backup/info.dynamic setlocal filetype=sh
  autocmd BufNewFile,BufReadPost sa-update-rules/*.cf setlocal filetype=spamassassin
  autocmd BufNewFile,BufReadPost syslog-ng.conf       setlocal filetype=syslog-ng
  autocmd BufNewFile,BufReadPost patterndb.d/*.conf   setlocal filetype=syslog-ng

  " Custom build log syntax
  autocmd BufNewFile,BufReadPost *.build              setlocal filetype=cerr
augroup END

" Input Method autocmd
augroup input_method_settings
  autocmd!

  " TODO enable when getimstatus() is available
  " ref: https://github.com/Shougo/deoplete.nvim/issues/1003
  if vimrc#plugin#is_disabled_plugin('deoplete.nvim')
    autocmd InsertEnter * setlocal iminsert=1
    autocmd InsertLeave * setlocal iminsert=0
  endif
augroup END

" Secret project local settings
if exists('*VimSecretProjectLocalSettings')
  call VimSecretProjectLocalSettings()
endif

" Machine-local project local settings
if exists('*VimLocalProjectLocalSettings')
  call VimLocalProjectLocalSettings()
endif
