" Search keyword with Google using surfraw
if executable('sr')
  command! -nargs=1 GoogleKeyword call vimrc#tui#google_keyword(<q-args>)
  nnoremap <Leader>gk :execute 'GoogleKeyword ' . expand('<cword>')<CR>
endif

if executable('htop')
  command! Htop        call vimrc#tui#run('float', 'htop')
  command! HtopSplit   call vimrc#tui#run('new', 'htop')
  call fuzzymenu#Add('Htop', { 'exec': 'Htop' })
  call fuzzymenu#Add('HtopSplit', { 'exec': 'HtopSplit' })

  nnoremap <Leader>ht :Htop<CR>
endif

if executable('btm')
  command! Btm         call vimrc#tui#run('float', 'btm')
  command! BtmSplit    call vimrc#tui#run('new', 'btm')
  call fuzzymenu#Add('Btm', { 'exec': 'Btm' })
  call fuzzymenu#Add('BtmSplit', { 'exec': 'BtmSplit' })
endif

if executable('broot')
  command! Broot       call vimrc#tui#run('float', 'broot -p')
  command! BrootSplit  call vimrc#tui#run('vnew', 'broot -p')
  call fuzzymenu#Add('Broot', { 'exec': 'Broot' })
  call fuzzymenu#Add('BrootSplit', { 'exec': 'BrootSplit' })
endif

if executable('ranger')
  " Use floaterm ranger wrapper
  command! Ranger      call vimrc#tui#run('float', 'ranger')
  command! RangerSplit call vimrc#tui#run('new', 'ranger')
  call fuzzymenu#Add('Ranger', { 'exec': 'Ranger' })
  call fuzzymenu#Add('RangerSplit', { 'exec': 'RangerSplit' })
endif

if executable('nnn')
  command! Nnn         call vimrc#tui#run('float', 'nnn')
  command! NnnSplit    call vimrc#tui#run('new', 'nnn')
  call fuzzymenu#Add('Nnn', { 'exec': 'Nnn' })
  call fuzzymenu#Add('NnnSplit', { 'exec': 'NnnSplit' })
endif

if executable('vifm')
  command! Vifm        call vimrc#tui#run('float', 'vifm')
  command! VifmSplit   call vimrc#tui#run('new', 'vifm')
  call fuzzymenu#Add('Vifm', { 'exec': 'Vifm' })
  call fuzzymenu#Add('VifmSplit', { 'exec': 'VifmSplit' })
endif

if executable('fff')
  " Use floaterm fff wrapper
  command! Fff         call vimrc#tui#run('float', 'fff')
  command! FffSplit    call vimrc#tui#run('new', 'fff')
  call fuzzymenu#Add('Fff', { 'exec': 'Fff' })
  call fuzzymenu#Add('FffSplit', { 'exec': 'FffSplit' })
endif

if executable('lf')
  command! Lf          call vimrc#tui#run('float', 'lf')
  command! LfSplit     call vimrc#tui#run('new', 'lf')
  call fuzzymenu#Add('Lf', { 'exec': 'Lf' })
  call fuzzymenu#Add('LfSplit', { 'exec': 'LfSplit' })
endif

if executable('lazygit')
  command! LazyGit      call vimrc#tui#run('float', 'lazygit')
  command! LazyGitSplit call vimrc#tui#run('new', 'lazygit')
  call fuzzymenu#Add('LazyGit', { 'exec': 'LazyGit' })
  call fuzzymenu#Add('LazyGitSplit', { 'exec': 'LazyGitSplit' })

  nnoremap <Leader>gz :LazyGit<CR>
endif

if executable('gitui')
  command! Gitui       call vimrc#tui#run('float', 'gitui')
  command! GituiSplit  call vimrc#tui#run('new', 'gitui')
  call fuzzymenu#Add('Gitui', { 'exec': 'Gitui' })
  call fuzzymenu#Add('GituiSplit', { 'exec': 'GituiSplit' })
endif

if executable('bandwhich')
  command! Bandwhich      call vimrc#tui#run('float', 'bandwhich')
  command! BandwhichSplit call vimrc#tui#run('new', 'bandwhich')
  call fuzzymenu#Add('Bandwhich', { 'exec': 'Bandwhich' })
  call fuzzymenu#Add('BandwhichSplit', { 'exec': 'BandwhichSplit' })
endif

" TODO: Add tig

" Shells
if executable('fish')
  command! Fish        call vimrc#tui#run('float', 'fish')
  command! FishSplit   call vimrc#tui#run('new', 'fish')
  call fuzzymenu#Add('Fish', { 'exec': 'Fish' })
  call fuzzymenu#Add('FishSplit', { 'exec': 'FishSplit' })
endif

if executable('zsh')
  command! Zsh         call vimrc#tui#run('float', 'zsh')
  command! ZshSplit    call vimrc#tui#run('new', 'zsh')
  call fuzzymenu#Add('Zsh', { 'exec': 'Zsh' })
  call fuzzymenu#Add('ZshSplit', { 'exec': 'ZshSplit' })
endif
