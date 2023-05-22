local buffer = {}

buffer._parse_args = function(args)
  local default_args = {
    wipeout = false,
    include_modified = false,
    bang = false,
  }
  local parsed_args = {}
  for _, arg in ipairs(args) do
    parsed_args[arg] = true
  end
  return vim.tbl_extend("force", default_args, parsed_args)
end

-- NOTE: Delete buffers that are not shown in any window
-- Usage example: `buffer.delete_inactive_buffers("wipeout")`, `buffer.delete_inactive_buffers("wipeout", "include_modified")`
buffer.delete_inactive_buffers = function(...)
  local args = buffer._parse_args({ ... })
  local visible_buffers = {}
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    visible_buffers[vim.api.nvim_win_get_buf(winid)] = true
  end

  local wipeout_count = 0
  local cmd = (args.wipeout and "bwipeout" or "bdelete") .. (args.bang and "!" or "")
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(bufnr) == 1 and not visible_buffers[bufnr] then
      if args.include_modified or (not args.include_modified and not vim.api.nvim_get_option_value("mod", { buf = bufnr })) then
        vim.cmd(cmd .. " " .. bufnr)
        wipeout_count = wipeout_count + 1
      end
    end
  end

  vim.notify(wipeout_count .. " buffers(s) " .. (args.wipeout and "wiped out" or "deleted"),vim.log.levels.INFO, {})
end

return buffer
