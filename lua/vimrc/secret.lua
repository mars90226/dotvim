local plugin_utils = require("vimrc.plugin_utils")

local secret = {}

secret.config = {
  vim = vim.env.HOME .. "/.vim_secret.vim",
  lua = vim.env.HOME .. "/.vim_secret.lua",
  dir = vim.env.HOME .. "/.vim_secret",
}

secret.setup = function()
  vim.opt.runtimepath:append(secret.config.dir)

  if plugin_utils.file_readable(secret.config.vim) then
    plugin_utils.source(secret.config.vim)
  end
  if plugin_utils.file_readable(secret.config.lua) then
    plugin_utils.source(secret.config.lua)
  end
end

return secret
