" Search keyword with Google using surfraw
if executable('sr')
  command! -nargs=1 GoogleKeyword call vimrc#tui#google_keyword(<q-args>)
  nnoremap <Leader>gk :execute 'GoogleKeyword ' . expand('<cword>')<CR>
endif

if executable('htop')
  command! Htop      call vimrc#tui#run('float', 'htop')
  command! HtopSplit call vimrc#tui#run('new', 'htop')
endif

if executable('btm')
  command! Btm      call vimrc#tui#run('float', 'btm')
  command! BtmSplit call vimrc#tui#run('new', 'btm')
endif

if executable('broot')
  command! Broot      call vimrc#tui#run('float', 'broot -p')
  command! BrootSplit call vimrc#tui#run('vnew', 'broot -p')
endif

if executable('ranger')
  " Use floaterm ranger wrapper
  command! Ranger      call vimrc#tui#run('float', 'ranger')
  command! RangerSplit call vimrc#tui#run('new', 'ranger')
endif

if executable('nnn')
  command! Nnn      call vimrc#tui#run('float', 'nnn')
  command! NnnSplit call vimrc#tui#run('new', 'nnn')
endif

if executable('vifm')
  command! Vifm      call vimrc#tui#run('float', 'vifm')
  command! VifmSplit call vimrc#tui#run('new', 'vifm')
endif

if executable('fff')
  " Use floaterm fff wrapper
  command! Fff      call vimrc#tui#run('float', 'fff')
  command! FffSplit call vimrc#tui#run('new', 'fff')
endif

if executable('lf')
  command! Lf      call vimrc#tui#run('float', 'lf')
  command! LfSplit call vimrc#tui#run('new', 'lf')
endif
