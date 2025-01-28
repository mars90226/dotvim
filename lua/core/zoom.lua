local utils = require("vimrc.utils")

local zoom = {}

zoom.zoom = function()
  if vim.fn.winnr("$") > 1 then
    -- If there are multiple windows, create a new tab with current window
    vim.cmd("tab split")
    utils.set_scratch()
  else
    -- Check if current buffer exists in other tabs
    local current_buf = vim.api.nvim_get_current_buf()
    local windows_with_buf = vim.fn.win_findbuf(current_buf)

    if #windows_with_buf > 1 then
      -- If buffer exists in multiple windows, close this tab and go to previous
      vim.cmd("tabclose")
      vim.cmd("tabprevious")
    end
  end
end

zoom.selected = function(selected)
  local filetype = vim.bo.filetype
  vim.cmd("tabnew")
  local lines = vim.split(selected, "\n")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  utils.set_scratch()
  vim.bo.filetype = filetype
end

zoom.float = function()
  if vim.fn["vimrc#float#is_float"](vim.api.nvim_get_current_win()) == 1 then
    vim.cmd("VimrcFloatToggle")
  else
    vim.cmd("VimrcFloatNew edit " .. vim.fn.expand("%"))
  end
end

zoom.float_selected = function(selected)
  local filetype = vim.bo.filetype

  vim.cmd("VimrcFloatNew")
  local lines = vim.split(selected, "\n")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  vim.bo.filetype = filetype
end

zoom.into_float = function()
  if vim.fn["vimrc#float#is_float"](vim.api.nvim_get_current_win()) == 1 then
    vim.cmd("VimrcFloatToggle")
  else
    local bufnr = vim.api.nvim_get_current_buf()
    vim.cmd("close")
    vim.cmd(("VimrcFloatNew buffer " .. bufnr))
  end
end

return zoom
