local plugin_utils = require("vimrc.plugin_utils")

local clipboard = {}

clipboard.setup = function()
  -- TODO: Use neovim builtin OSC52 clipboard provider
  -- Ref: https://github.com/neovim/neovim/pull/25872
  if vim.fn.has("wsl") == 1 then
    local has_lemonade = plugin_utils.is_executable("lemonade")
    local copy_cmd = has_lemonade and "lemonade copy" or "xsel -i"
    local paste_cmd = has_lemonade and "lemonade paste" or "xsel -o"

    vim.g.clipboard = {
      name = "wsl_clipboard",
      copy = {
        ["+"] = copy_cmd,
        ["*"] = copy_cmd,
      },
      paste = {
        ["+"] = paste_cmd,
        ["*"] = paste_cmd,
      },
      cache_enabled = 1,
    }

    if not has_lemonade then
      --  Force loading clipboard
      --  TODO: Create issue in neovim, this should be fixed in neovim
      vim.fn["provider#clipboard#Executable"]()
    end
  end

  -- TODO: Fix clipboard: error: Error: target STRING not available
  -- Use xsel instead of xclip. It seems that xclip over ssh with yank plugin cause this error.
  -- Ref: https://github.com/svermeulen/vim-yoink/issues/16#issuecomment-632234373
end

return clipboard
