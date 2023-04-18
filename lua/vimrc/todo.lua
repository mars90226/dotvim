local todo = {}

todo.make_todo = function(line1, line2)
  vim.cmd(line1 .. ',' .. line2 .. [[yank]])
  vim.cmd([[new]])
  vim.cmd([[norm p]])
  vim.cmd([[1,2delete ]])
  vim.cmd([[set ft=todo]])
  vim.cmd([[TodoFormat]])
end

return todo
