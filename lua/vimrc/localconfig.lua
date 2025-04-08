local plugin_utils = require("vimrc.plugin_utils")

local localconfig = {}

localconfig.config = {
  vim = vim.env.HOME .. "/.vim_local.vim",
  lua = vim.env.HOME .. "/.vim_local.lua",
}

localconfig.setup = function()
  if plugin_utils.file_readable(localconfig.config.vim) then
    plugin_utils.source(localconfig.config.vim)
  end
  if plugin_utils.file_readable(localconfig.config.lua) then
    plugin_utils.source(localconfig.config.lua)
  end
end

return localconfig
