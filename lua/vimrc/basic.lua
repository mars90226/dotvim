local plugin_utils = require("vimrc.plugin_utils")

local basic = {}

basic.setup = function ()
  vim.g.mapleader = ','
  vim.g.maplocalleader = [[\]]

  -- TODO: No need in neovim?
  if not plugin_utils.os_is("windows") then
    vim.o.encoding = 'utf8'
  end

  vim.g.left_sidebar_width = 35
  vim.g.right_sidebar_width = 40
end

return basic
