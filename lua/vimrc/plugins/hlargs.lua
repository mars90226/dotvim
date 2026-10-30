local hlargs = {}

-- Buffers disabled by entering diff mode, to be restored after leaving diff mode
local diff_disabled_bufs = {}

-- NOTE: hlargs causes performance regression in diff mode, so skip buffers shown in diff
-- windows. Also skip 'nowrite' buffers (diffview/fugitive revisions): they are never edited, so
-- hlargs's lazy detach never releases their buffer attachments.
hlargs.is_skipped_buf = function(bufnr)
  if vim.bo[bufnr].buftype == "nowrite" then
    return true
  end
  for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
    if vim.wo[winid].diff then
      return true
    end
  end
  return false
end

hlargs.setup = function()
  local origin_hlargs = require("hlargs")

  origin_hlargs.setup({
    disable = function(lang, bufnr)
      return vim.tbl_contains(require("hlargs.config").opts.excluded_filetypes, lang) or hlargs.is_skipped_buf(bufnr)
    end,
  })

  -- Toggle only the affected buffer; global hlargs.enable() re-attaches every loaded buffer.
  local hlargs_augroup_id = vim.api.nvim_create_augroup("hlargs_settings", {})
  vim.api.nvim_create_autocmd({ "OptionSet" }, {
    group = hlargs_augroup_id,
    pattern = "diff",
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      if vim.bo[bufnr].buftype == "nowrite" then
        return
      end
      if hlargs.is_skipped_buf(bufnr) then
        origin_hlargs.disable_buf(bufnr)
        diff_disabled_bufs[bufnr] = true
      elseif diff_disabled_bufs[bufnr] then
        origin_hlargs.enable_buf(bufnr)
        diff_disabled_bufs[bufnr] = nil
      end
    end,
  })
  -- Closing a diff tab (e.g. :DiffviewClose) does not reset 'diff', so restore on re-entry.
  -- Defer the check because the closing tab's diff windows still exist during BufEnter.
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = hlargs_augroup_id,
    callback = function(ev)
      if not diff_disabled_bufs[ev.buf] then
        return
      end
      vim.schedule(function()
        if diff_disabled_bufs[ev.buf] and vim.api.nvim_buf_is_valid(ev.buf) and not hlargs.is_skipped_buf(ev.buf) then
          origin_hlargs.enable_buf(ev.buf)
          diff_disabled_bufs[ev.buf] = nil
        end
      end)
    end,
  })
  vim.api.nvim_create_autocmd({ "BufWipeout" }, {
    group = hlargs_augroup_id,
    callback = function(ev)
      diff_disabled_bufs[ev.buf] = nil
    end,
  })
end

return hlargs
