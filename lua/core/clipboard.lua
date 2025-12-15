local plugin_utils = require("vimrc.plugin_utils")

local clipboard = {}

clipboard.setup = function()
  if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = 'win32yank'
  end

  -- Use tmux for clipboard if available
  -- TODO: Monitor if this cause problem
  -- FIXME: Linux server -> X11 server works, but X11 server -> Linux server broken.
  if vim.env.TMUX ~= nil then
    vim.g.clipboard = 'tmux'
  end

  -- TODO: Fix clipboard: error: Error: target STRING not available
  -- Use `xsel` instead of `xclip`. It seems that `xclip` over ssh with yank plugin cause this error.
  -- Ref: https://github.com/svermeulen/vim-yoink/issues/16#issuecomment-632234373
end

return clipboard
