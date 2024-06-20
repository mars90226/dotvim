local tig = {}

tig.setup = function()
  vim.cmd([[command! -bang -nargs=* TigLog          call vimrc#tig#log(<q-args>, <bang>0, 0)]])
  vim.cmd([[command! -bang -nargs=* TigLogSplit     split | call vimrc#tig#log(<q-args>, <bang>0, 0)]])
  vim.cmd([[command! -bang -nargs=* TigLogFile      call vimrc#tig#log(<q-args>, <bang>0, 1)]])
  vim.cmd([[command! -bang -nargs=* TigLogFileSplit split | call vimrc#tig#log(<q-args>, <bang>0, 1)]])
end

return tig
