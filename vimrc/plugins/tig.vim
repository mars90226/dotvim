" Add '' to open tig main view
nnoremap \tr :Tig ''<CR>
nnoremap \tt :tabnew <Bar> Tig ''<CR>
nnoremap \ts :new    <Bar> Tig ''<CR>
nnoremap \tv :vnew   <Bar> Tig ''<CR>

function! s:tig_log(opts, bang, is_current_file)
  execute 'Tig log ' . (a:bang ? '-p ' : '') . a:opts . (a:is_current_file ? ' -- ' . expand('%:p') : '')
endfunction
command! -bang -nargs=* TigLog          call s:tig_log(<q-args>, <bang>0, 0)
command! -bang -nargs=* TigLogSplit     split | call s:tig_log(<q-args>, <bang>0, 0)
command! -bang -nargs=* TigLogFile      call s:tig_log(<q-args>, <bang>0, 1)
command! -bang -nargs=* TigLogFileSplit split | call s:tig_log(<q-args>, <bang>0, 1)
" Add non-follow version as --follow will include many merge commits
nnoremap \tl :TigLogFileSplit!<CR>
nnoremap \tL :TigLogFileSplit! --follow<CR>
nnoremap \t<C-L> :execute 'TigLogSplit! $(git log --format=format:%H --follow -- ' . expand('%:p') . ')'<CR>
