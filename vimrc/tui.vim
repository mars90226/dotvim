" Search keyword with Google using surfraw
if executable('sr')
  command! -nargs=1 GoogleKeyword call vimrc#tui#google_keyword(<q-args>)
  nnoremap <Leader>gk :execute 'GoogleKeyword ' . expand('<cword>')<CR>
endif

if executable('htop')
  command! -nargs=* Htop        call vimrc#tui#run('float', 'htop '.<q-args>)
  command! -nargs=* HtopSplit   call vimrc#tui#run('new', 'htop '.<q-args>)
  call vimrc#fuzzymenu#try_add('Htop', { 'exec': 'Htop' })
  call vimrc#fuzzymenu#try_add('HtopSplit', { 'exec': 'HtopSplit' })

  nnoremap <Leader>ht :Htop<CR>
endif

if executable('atop')
  command! -nargs=* Atop        call vimrc#tui#run('float', 'atop '.<q-args>)
  command! -nargs=* AtopSplit   call vimrc#tui#run('new', 'atop '.<q-args>)
  call vimrc#fuzzymenu#try_add('Atop', { 'exec': 'Atop' })
  call vimrc#fuzzymenu#try_add('AtopSplit', { 'exec': 'AtopSplit' })
endif

if executable('btm')
  command! -nargs=* Btm         call vimrc#tui#run('float', 'btm '.<q-args>)
  command! -nargs=* BtmSplit    call vimrc#tui#run('new', 'btm '.<q-args>)
  call vimrc#fuzzymenu#try_add('Btm', { 'exec': 'Btm' })
  call vimrc#fuzzymenu#try_add('BtmSplit', { 'exec': 'BtmSplit' })

  nnoremap <Leader>bt :Btm<CR>
endif

if executable('broot')
  command! -nargs=* Broot       call vimrc#tui#run('float', 'broot -p '.<q-args>)
  command! -nargs=* BrootSplit  call vimrc#tui#run('vnew', 'broot -p '.<q-args>)
  call vimrc#fuzzymenu#try_add('Broot', { 'exec': 'Broot' })
  call vimrc#fuzzymenu#try_add('BrootSplit', { 'exec': 'BrootSplit' })

  nnoremap <Leader>br :Broot<CR>
  nnoremap <Leader>bR :Broot %:h<CR>
endif

if executable('ranger')
  command! -nargs=* Ranger      call vimrc#tui#run('float', 'ranger '.<q-args>)
  command! -nargs=* RangerSplit call vimrc#tui#run('new', 'ranger '.<q-args>)
  call vimrc#fuzzymenu#try_add('Ranger', { 'exec': 'Ranger' })
  call vimrc#fuzzymenu#try_add('RangerSplit', { 'exec': 'RangerSplit' })
endif

if executable('nnn')
  command! -nargs=* Nnn         call vimrc#tui#run('float', 'nnn '.<q-args>)
  command! -nargs=* NnnSplit    call vimrc#tui#run('new', 'nnn '.<q-args>)
  call vimrc#fuzzymenu#try_add('Nnn', { 'exec': 'Nnn' })
  call vimrc#fuzzymenu#try_add('NnnSplit', { 'exec': 'NnnSplit' })
endif

if executable('vifm')
  command! -nargs=* Vifm        call vimrc#tui#run('float', 'vifm '.<q-args>)
  command! -nargs=* VifmSplit   call vimrc#tui#run('new', 'vifm '.<q-args>)
  call vimrc#fuzzymenu#try_add('Vifm', { 'exec': 'Vifm' })
  call vimrc#fuzzymenu#try_add('VifmSplit', { 'exec': 'VifmSplit' })
endif

if executable('fff')
  command! -nargs=* Fff         call vimrc#tui#run('float', 'fff '.<q-args>)
  command! -nargs=* FffSplit    call vimrc#tui#run('new', 'fff '.<q-args>)
  call vimrc#fuzzymenu#try_add('Fff', { 'exec': 'Fff' })
  call vimrc#fuzzymenu#try_add('FffSplit', { 'exec': 'FffSplit' })
endif

if executable('lf')
  command! -nargs=* Lf          call vimrc#tui#run('float', 'lf '.<q-args>)
  command! -nargs=* LfSplit     call vimrc#tui#run('new', 'lf '.<q-args>)
  call vimrc#fuzzymenu#try_add('Lf', { 'exec': 'Lf' })
  call vimrc#fuzzymenu#try_add('LfSplit', { 'exec': 'LfSplit' })
endif

if executable('xplr')
  command! -nargs=* Xplr          call vimrc#tui#run('float', 'xplr '.<q-args>)
  command! -nargs=* XplrSplit     call vimrc#tui#run('new', 'xplr '.<q-args>)
  call vimrc#fuzzymenu#try_add('Xplr', { 'exec': 'Xplr' })
  call vimrc#fuzzymenu#try_add('XplrSplit', { 'exec': 'XplrSplit' })

  nnoremap <Leader>xp :Xplr<CR>
  nnoremap <Leader>xP :Xplr %:h<CR>
endif

if executable('lazygit')
  command! -nargs=* LazyGit      call vimrc#tui#run('float', 'lazygit '.<q-args>)
  command! -nargs=* LazyGitSplit call vimrc#tui#run('new', 'lazygit '.<q-args>)
  call vimrc#fuzzymenu#try_add('LazyGit', { 'exec': 'LazyGit' })
  call vimrc#fuzzymenu#try_add('LazyGitSplit', { 'exec': 'LazyGitSplit' })

  nnoremap <Leader>gz :LazyGit<CR>
endif

if executable('gitui')
  command! -nargs=* Gitui       call vimrc#tui#run('float', 'gitui '.<q-args>)
  command! -nargs=* GituiSplit  call vimrc#tui#run('new', 'gitui '.<q-args>)
  call vimrc#fuzzymenu#try_add('Gitui', { 'exec': 'Gitui' })
  call vimrc#fuzzymenu#try_add('GituiSplit', { 'exec': 'GituiSplit' })

  nnoremap <Leader>gi :Gitui<CR>
endif

if executable('bandwhich')
  command! -nargs=* Bandwhich      call vimrc#tui#run('float', 'bandwhich '.<q-args>)
  command! -nargs=* BandwhichSplit call vimrc#tui#run('new', 'bandwhich '.<q-args>)
  call vimrc#fuzzymenu#try_add('Bandwhich', { 'exec': 'Bandwhich' })
  call vimrc#fuzzymenu#try_add('BandwhichSplit', { 'exec': 'BandwhichSplit' })
endif

" TODO: Add tig

" Shells
if executable('fish')
  command! -nargs=* Fish        call vimrc#tui#run('float', 'fish '.<q-args>)
  command! -nargs=* FishSplit   call vimrc#tui#run('new', 'fish '.<q-args>)
  call vimrc#fuzzymenu#try_add('Fish', { 'exec': 'Fish' })
  call vimrc#fuzzymenu#try_add('FishSplit', { 'exec': 'FishSplit' })
endif

if executable('zsh')
  command! -nargs=* Zsh         call vimrc#tui#run('float', 'zsh '.<q-args>)
  command! -nargs=* ZshSplit    call vimrc#tui#run('new', 'zsh '.<q-args>)
  call vimrc#fuzzymenu#try_add('Zsh', { 'exec': 'Zsh' })
  call vimrc#fuzzymenu#try_add('ZshSplit', { 'exec': 'ZshSplit' })
endif
