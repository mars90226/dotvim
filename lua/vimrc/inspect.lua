local inspect = {}

inspect.inspect = function(object, filetype)
  local ft = filetype or "lua"
  local content = vim.fn.split(vim.inspect(object), "\n")

  vim.cmd([[new ]]..vim.fn.tempname().."."..ft)
  vim.bo.filetype = ft
  vim.api.nvim_buf_set_lines(0, 0, 0, false, content)
end

return inspect
