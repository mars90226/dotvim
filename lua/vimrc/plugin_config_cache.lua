local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local plugin_config_cache = {}

plugin_config_cache.path = utils.get_vim_home() .. "/.plugin_config_cache"
plugin_config_cache.cache = {}

plugin_config_cache.read = function()
  if plugin_utils.file_readable(plugin_config_cache.path) then
    vim.cmd([[source ]] .. plugin_config_cache.path)
  end
end

plugin_config_cache.append = function(content)
  table.insert(plugin_config_cache.cache, content)
end

plugin_config_cache.write = function()
  vim.fn.writefile(plugin_config_cache.cache, plugin_config_cache.path)
end

plugin_config_cache.update = function()
  -- Update plugin config
  plugin_config_cache.append("let g:os = '" .. vim.fn["vimrc#plugin#check#get_os"](true) .. "'")
  plugin_config_cache.append("let g:distro = '" .. vim.fn["vimrc#plugin#check#get_distro"](true) .. "'")
  plugin_config_cache.append("let g:python_version = '" .. vim.fn["vimrc#plugin#check#python_version"](true) .. "'")

  plugin_config_cache.write()
end

plugin_config_cache.init = function()
  if not plugin_utils.file_readable(plugin_config_cache.path) then
    plugin_config_cache.update()
  end
end

return plugin_config_cache
