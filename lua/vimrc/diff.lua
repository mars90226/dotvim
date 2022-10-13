local diff = {}

-- Requires delta
-- https://github.com/dandavison/delta
diff.diff_in_delta = function()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local bufnames = vim.tbl_map(function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    return vim.api.nvim_buf_get_name(buf)
  end, wins)

  vim.cmd([[FloatermNew delta ]]..table.concat(bufnames, ' '))
end

return diff
