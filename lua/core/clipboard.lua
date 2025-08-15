local plugin_utils = require("vimrc.plugin_utils")

local clipboard = {}

clipboard.setup = function()
  if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = 'win32yank'
  end

  -- TODO: Fix clipboard: error: Error: target STRING not available
  -- Use xsel instead of xclip. It seems that xclip over ssh with yank plugin cause this error.
  -- Ref: https://github.com/svermeulen/vim-yoink/issues/16#issuecomment-632234373
end

return clipboard
