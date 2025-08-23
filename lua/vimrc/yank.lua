local yank = {}

yank.yank_register = function(register, text)
  vim.fn.setreg(register, text)
end

yank.yank = function(text)
  yank.yank_register('"', text)
end

return yank
