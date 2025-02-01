local open = {}

open.switch = function(file, callback)
  local path = type(file) == "table" and file[1] or file
  local bufnr = vim.fn.bufnr(path)
  local winids = vim.fn.win_findbuf(bufnr)
  if #winids == 0 then
    if type(callback) == "function" then
      callback(path)
    else
      local fallback_command = callback or "edit"
      vim.cmd("silent " .. fallback_command .. " " .. path)
    end
  else
    vim.fn.win_gotoid(winids[1])
  end
end

open.tab = function(file)
  require("vimrc.plugins.oil").open(file, "tab")
end

return open
