local cscope = {}

cscope.generate_files = function()
  vim.cmd([[Dispatch -compiler=cscope]])
end

cscope.reload = function()
  vim.cmd([[cscope kill -1]])
  vim.cmd([[cscope add cscope.out]])
end

return cscope
