local plugin_utils = require("vimrc.plugin_utils")

local secret = {}

secret.config = {
  vim = vim.env.HOME .. "/.vim_secret.vim",
  lua = vim.env.HOME .. "/.vim_secret.lua",
  dir = vim.env.HOME .. "/.vim_secret",
}

-- NOTE: Only check if the directory exists
secret.is_enabled = function()
  return plugin_utils.is_directory(secret.config.dir)
end

secret.setup = function()
  -- TODO: Put the check to plugin_choose?
  if secret.is_enabled() then
    vim.opt.runtimepath:append(secret.config.dir)
  end

  -- Load the secret config files if they exist
  if plugin_utils.file_readable(secret.config.vim) then
    plugin_utils.source(secret.config.vim)
  end
  if plugin_utils.file_readable(secret.config.lua) then
    plugin_utils.source(secret.config.lua)
  end
end

return secret
