local plugin_utils = require("vimrc.plugin_utils")

local clipboard = {}

clipboard.startup = function(use)
  local use_config = function(plugin_spec)
    plugin_utils.use_config(use, plugin_spec)
  end

  if vim.fn.has("wsl") == 1 then
    use_config({
      "mars90226/clipboard",
      event = { "FocusLost", "CursorHold", "CursorHoldI" },
      config = function()
        vim.g.clipboard = {
          name = "wsl_clipboard",
          copy = {
            ["+"] = "xsel -i",
            ["*"] = "xsel -i",
          },
          paste = {
            ["+"] = "xsel -o",
            ["*"] = "xsel -o",
          },
          cache_enabled = 1,
        }

        --  Force loading clipboard
        --  TODO: Create issue in neovim, this should be fixed in neovim
        vim.fn["provider#clipboard#Executable"]()
      end,
    })
  end

  -- TODO: Fix clipboard: error: Error: target STRING not available
  -- Use xsel instead of xclip. It seems that xclip over ssh with yank plugin cause this error.
  -- Ref: https://github.com/svermeulen/vim-yoink/issues/16#issuecomment-632234373
end

return clipboard
