" Search keyword with Google using surfraw
if executable('sr')
  command! -nargs=1 GoogleKeyword call vimrc#tui#google_keyword(<q-args>)
  nnoremap <Leader>gk :execute 'GoogleKeyword ' . expand('<cword>')<CR>
endif

if executable('htop')
  command! Htop        call vimrc#tui#run('float', 'htop')
  command! HtopSplit   call vimrc#tui#run('new', 'htop')
  call vimrc#fuzzymenu#try_add('Htop', { 'exec': 'Htop' })
  call vimrc#fuzzymenu#try_add('HtopSplit', { 'exec': 'HtopSplit' })

  nnoremap <Leader>ht :Htop<CR>
endif

if executable('atop')
  command! Atop        call vimrc#tui#run('float', 'atop')
  command! AtopSplit   call vimrc#tui#run('new', 'atop')
  call vimrc#fuzzymenu#try_add('Atop', { 'exec': 'Atop' })
  call vimrc#fuzzymenu#try_add('AtopSplit', { 'exec': 'AtopSplit' })
endif

if executable('btm')
  command! Btm         call vimrc#tui#run('float', 'btm')
  command! BtmSplit    call vimrc#tui#run('new', 'btm')
  call vimrc#fuzzymenu#try_add('Btm', { 'exec': 'Btm' })
  call vimrc#fuzzymenu#try_add('BtmSplit', { 'exec': 'BtmSplit' })
endif

if executable('broot')
  command! Broot       call vimrc#tui#run('float', 'broot -p')
  command! BrootSplit  call vimrc#tui#run('vnew', 'broot -p')
  call vimrc#fuzzymenu#try_add('Broot', { 'exec': 'Broot' })
  call vimrc#fuzzymenu#try_add('BrootSplit', { 'exec': 'BrootSplit' })
endif

if executable('ranger')
  command! Ranger      call vimrc#tui#run('float', 'ranger')
  command! RangerSplit call vimrc#tui#run('new', 'ranger')
  call vimrc#fuzzymenu#try_add('Ranger', { 'exec': 'Ranger' })
  call vimrc#fuzzymenu#try_add('RangerSplit', { 'exec': 'RangerSplit' })
endif

if executable('nnn')
  command! Nnn         call vimrc#tui#run('float', 'nnn')
  command! NnnSplit    call vimrc#tui#run('new', 'nnn')
  call vimrc#fuzzymenu#try_add('Nnn', { 'exec': 'Nnn' })
  call vimrc#fuzzymenu#try_add('NnnSplit', { 'exec': 'NnnSplit' })
endif

if executable('vifm')
  command! Vifm        call vimrc#tui#run('float', 'vifm')
  command! VifmSplit   call vimrc#tui#run('new', 'vifm')
  call vimrc#fuzzymenu#try_add('Vifm', { 'exec': 'Vifm' })
  call vimrc#fuzzymenu#try_add('VifmSplit', { 'exec': 'VifmSplit' })
endif

if executable('fff')
  command! Fff         call vimrc#tui#run('float', 'fff')
  command! FffSplit    call vimrc#tui#run('new', 'fff')
  call vimrc#fuzzymenu#try_add('Fff', { 'exec': 'Fff' })
  call vimrc#fuzzymenu#try_add('FffSplit', { 'exec': 'FffSplit' })
endif

if executable('lf')
  command! Lf          call vimrc#tui#run('float', 'lf')
  command! LfSplit     call vimrc#tui#run('new', 'lf')
  call vimrc#fuzzymenu#try_add('Lf', { 'exec': 'Lf' })
  call vimrc#fuzzymenu#try_add('LfSplit', { 'exec': 'LfSplit' })
endif

if executable('xplr')
  command! Xplr          call vimrc#tui#run('float', 'xplr')
  command! XplrSplit     call vimrc#tui#run('new', 'xplr')
  call vimrc#fuzzymenu#try_add('Xplr', { 'exec': 'Xplr' })
  call vimrc#fuzzymenu#try_add('XplrSplit', { 'exec': 'XplrSplit' })
endif

if executable('lazygit')
  command! LazyGit      call vimrc#tui#run('float', 'lazygit')
  command! LazyGitSplit call vimrc#tui#run('new', 'lazygit')
  call vimrc#fuzzymenu#try_add('LazyGit', { 'exec': 'LazyGit' })
  call vimrc#fuzzymenu#try_add('LazyGitSplit', { 'exec': 'LazyGitSplit' })

  nnoremap <Leader>gz :LazyGit<CR>
endif

if executable('gitui')
  command! Gitui       call vimrc#tui#run('float', 'gitui')
  command! GituiSplit  call vimrc#tui#run('new', 'gitui')
  call vimrc#fuzzymenu#try_add('Gitui', { 'exec': 'Gitui' })
  call vimrc#fuzzymenu#try_add('GituiSplit', { 'exec': 'GituiSplit' })

  nnoremap <Leader>gi :Gitui<CR>
endif

if executable('bandwhich')
  command! Bandwhich      call vimrc#tui#run('float', 'bandwhich')
  command! BandwhichSplit call vimrc#tui#run('new', 'bandwhich')
  call vimrc#fuzzymenu#try_add('Bandwhich', { 'exec': 'Bandwhich' })
  call vimrc#fuzzymenu#try_add('BandwhichSplit', { 'exec': 'BandwhichSplit' })
endif

" TODO: Add tig

" Shells
if executable('fish')
  command! Fish        call vimrc#tui#run('float', 'fish')
  command! FishSplit   call vimrc#tui#run('new', 'fish')
  call vimrc#fuzzymenu#try_add('Fish', { 'exec': 'Fish' })
  call vimrc#fuzzymenu#try_add('FishSplit', { 'exec': 'FishSplit' })
endif

if executable('zsh')
  command! Zsh         call vimrc#tui#run('float', 'zsh')
  command! ZshSplit    call vimrc#tui#run('new', 'zsh')
  call vimrc#fuzzymenu#try_add('Zsh', { 'exec': 'Zsh' })
  call vimrc#fuzzymenu#try_add('ZshSplit', { 'exec': 'ZshSplit' })
endif
