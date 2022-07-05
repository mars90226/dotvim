local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local config_cache = {}

config_cache.path = utils.get_vim_home() .. "/.config_cache"
config_cache.cache = {}

config_cache.read = function()
  if plugin_utils.file_readable(config_cache.path) then
    vim.cmd([[source ]] .. config_cache.path)
  end
end

config_cache.append = function(content)
  table.insert(config_cache.cache, content)
end

config_cache.write = function()
  vim.fn.writefile(config_cache.cache, config_cache.path)
end

config_cache.update = function()
  -- Update plugin config
  config_cache.append("let g:os = '" .. vim.fn["vimrc#plugin#check#get_os"](true) .. "'")
  config_cache.append("let g:distro = '" .. vim.fn["vimrc#plugin#check#get_distro"](true) .. "'")
  config_cache.append("let g:python_version = '" .. vim.fn["vimrc#plugin#check#python_version"](true) .. "'")

  config_cache.write()
end

config_cache.init = function()
  if not plugin_utils.file_readable(config_cache.path) then
    config_cache.update()
  end
end

return config_cache
