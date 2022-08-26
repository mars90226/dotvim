local uv = vim.loop

local mapping = {}

-- Ref: https://www.reddit.com/r/neovim/comments/w0jzzv/comment/igfjx5y/?utm_source=share&utm_medium=web2x&context=3
mapping.smart_dd = function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end

mapping.toggle_open_url_force_local = function()
  local open_url_force_local = uv.os_getenv("OPEN_URL_FORCE_LOCAL")

  if open_url_force_local == "1" then
    uv.os_setenv("OPEN_URL_FORCE_LOCAL", "0")
  else
    uv.os_setenv("OPEN_URL_FORCE_LOCAL", "1")
  end
end

return mapping
