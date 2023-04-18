local todo = {}

todo.make_todo = function()
  vim.cmd([['<,'>yank]])
  vim.cmd([[new]])
  vim.cmd([[norm p]])
  vim.cmd([[1,2delete ]])
  vim.cmd([[set ft=todo]])
  vim.cmd([[TodoFormat]])
end

return todo
