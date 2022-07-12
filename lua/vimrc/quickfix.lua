local qfs = require("bqf.qfwin.session")

local quickfix = {}

quickfix.move_cursor = function(idx)
  local qf = qfs:get(vim.api.nvim_get_current_win())
  local qlist = qf:list()
  qlist:changeIdx(idx)
end

quickfix.move_next = function()
  local qwinid = vim.api.nvim_get_current_win()
  local idx = vim.api.nvim_win_get_cursor(qwinid)[1]
  -- TODO: Check boundary
  quickfix.move_cursor(idx + 1)
end

quickfix.move_previous = function()
  local qwinid = vim.api.nvim_get_current_win()
  local idx = vim.api.nvim_win_get_cursor(qwinid)[1]
  -- TODO: Check boundary
  quickfix.move_cursor(idx - 1)
end

return quickfix
