local open = {}

open.switch = function(file, callback)
  local path = type(file) == "table" and file[1] or file
  vim.print("open.switch", path, callback)
  local bufnr = vim.fn.bufnr(path)
  local winids = vim.fn.win_findbuf(bufnr)
  vim.print("open.switch", bufnr, winids)
  if #winids == 0 then
    callback(path)
  else
    vim.fn.win_gotoid(winids[1])
  end
end

open.tab = function(file)
  require("vimrc.plugins.oil").open(file, "tab")
end

return open
