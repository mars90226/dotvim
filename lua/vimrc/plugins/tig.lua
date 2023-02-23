local tig = {}

tig.setup = function()
  -- Add '' to open tig main view
  nnoremap([[\tr]], [[:Tig ''<CR>]])
  nnoremap([[\tt]], [[:tabnew <Bar> Tig ''<CR>]])
  nnoremap([[\ts]], [[:new    <Bar> Tig ''<CR>]])
  nnoremap([[\tv]], [[:vnew   <Bar> Tig ''<CR>]])

  vim.cmd([[command! -bang -nargs=* TigLog          call vimrc#tig#log(<q-args>, <bang>0, 0)]])
  vim.cmd([[command! -bang -nargs=* TigLogSplit     split | call vimrc#tig#log(<q-args>, <bang>0, 0)]])
  vim.cmd([[command! -bang -nargs=* TigLogFile      call vimrc#tig#log(<q-args>, <bang>0, 1)]])
  vim.cmd([[command! -bang -nargs=* TigLogFileSplit split | call vimrc#tig#log(<q-args>, <bang>0, 1)]])

  -- Add non-follow version as --follow will include many merge commits
  nnoremap([[\tl]], [[:TigLogFileSplit!<CR>]])
  nnoremap([[\tL]], [[:TigLogFileSplit! --follow<CR>]])
  nnoremap([[\t<C-L>]], [[:execute 'TigLogSplit! $(git log --format=format:%H --follow -- ' . expand('%:p') . ')'<CR>]])
end

return tig
