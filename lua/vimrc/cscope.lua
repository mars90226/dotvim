local cscope = {}

cscope.generate_files = function()
  vim.cmd([[Lazy! load vim-dispatch]])
  vim.cmd([[Dispatch -compiler=cscope]])
end

return cscope
