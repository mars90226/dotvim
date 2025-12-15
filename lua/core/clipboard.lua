local plugin_utils = require("vimrc.plugin_utils")

local clipboard = {}

clipboard.setup = function()
  if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = 'win32yank'
  end

  -- Use tmux for clipboard if available
  -- TODO: Monitor if this cause problem
  -- NOTE: Use tmux to
  -- 1. Copy from within Linux server and set clipboard in SSH client no matter SSH client is X11
  -- server or not.
  -- 2. Cannot see the updated clipboard content within Linux server if copying from SSH client. Need
  -- to use terminal emulator's paste.
  if vim.env.TMUX ~= nil then
    vim.g.clipboard = 'tmux'
  end

  -- NOTE: Use xsel to
  -- 1. Copy from within Linux server and set clipboard in X11 server.
  -- 2. Cannot set clipboard in SSH client.
  -- 3. Can see the updated clipboard content within Linux server if copying from SSH client.

  -- TODO: Fix clipboard: error: Error: target STRING not available
  -- Use `xsel` instead of `xclip`. It seems that `xclip` over ssh with yank plugin cause this error.
  -- Ref: https://github.com/svermeulen/vim-yoink/issues/16#issuecomment-632234373
end

return clipboard
