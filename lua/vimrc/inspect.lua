local inspect = {}

-- Ref: :help lua-eval
local chunkheader = "local _A = select(1, ...) return "
inspect.luaeval = function(expstr, arg)
  local chunk = assert(loadstring(chunkheader .. expstr, "luaeval"))
  return chunk(arg) -- return typval
end

inspect.inspect = function(object, filetype)
  local ft = filetype or "lua"
  local content = vim.fn.split(vim.inspect(object), "\n")

  vim.cmd([[new ]]..vim.fn.tempname().."."..ft)
  vim.bo.filetype = ft
  vim.api.nvim_buf_set_lines(0, 0, 0, false, content)
end

inspect.inspect_eval_string = function(string)
  inspect.inspect(inspect.luaeval(string), "lua")
end

return inspect
