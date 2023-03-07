vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true

-- Utility
local function todo_cleanup_star()
  local save = vim.fn.winsaveview()
  vim.cmd([=[silent! %s/\* //]=])
  vim.fn.winrestview(save)
end

local function todo_set_ongoing()
  local save = vim.fn.winsaveview()
  vim.cmd([=[silent! %s/\[.\] `\[ongoing\]`/[\~]/]=])
  vim.fn.winrestview(save)
end

local function todo_set_done()
  local save = vim.fn.winsaveview()
  vim.cmd([=[silent! %s/\[X\]/[x]/]=])
  vim.fn.winrestview(save)
end

local function todo_set_section()
  local save = vim.fn.winsaveview()
  vim.cmd([=[silent! %s/^\v\[.\] ([^:]+):/[\1]/]=])
  vim.fn.winrestview(save)
end

local function todo_remove_category_header()
  vim.cmd([=[silent! %global/^\v`\[(finished|ongoing|todo|postpone)\]`:$/delete]=])
end

-- Functions
local function todo_format()
  vim.cmd([[%retab]])
  todo_cleanup_star()
  todo_set_ongoing()
  todo_set_done()
  todo_set_section()
  todo_remove_category_header()
end

local function todo_clean()
  vim.cmd([=[silent! %global/\[x\] /delete]=])
end

vim.api.nvim_buf_create_user_command(0, "TodoFormat", todo_format, {})
vim.api.nvim_buf_create_user_command(0, "TodoClean", todo_clean, {})
