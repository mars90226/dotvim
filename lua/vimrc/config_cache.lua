local utils = require("vimrc.utils")

local config_cache = {}

config_cache.path = utils.get_vim_home() .. "/.config_cache"
config_cache.cache = {}

config_cache.read = function()
  if vim.fn.filereadable(config_cache.path) == 1 then
    vim.cmd("source " .. vim.fn.fnameescape(config_cache.path))
  end
end

config_cache.get = function(name)
  return vim.g[name]
end

config_cache.append = function(content)
  table.insert(config_cache.cache, content)
end

config_cache.write = function()
  vim.fn.writefile(config_cache.cache, config_cache.path)
end

-- Update selected values without replacing the rest of an existing snapshot.
config_cache.set = function(values)
  local lines = vim.fn.filereadable(config_cache.path) == 1 and vim.fn.readfile(config_cache.path) or {}
  lines = vim.tbl_filter(function(line)
    local name = line:match("^let g:([%w_]+)%s*=")
    return not name or values[name] == nil
  end, lines)
  for _, name in ipairs(vim.fn.sort(vim.tbl_keys(values))) do
    assert(name:match("^[%a_][%w_]*$"), "Invalid cache variable name")
    vim.g[name] = values[name]
    lines[#lines + 1] = "let g:" .. name .. " = " .. vim.fn.string(values[name])
  end
  local ok, result = pcall(vim.fn.writefile, lines, config_cache.path)
  return ok and result == 0
end

-- The application supplies the values; storage does not discover them.
config_cache.update = function(collect, initializing)
  collect = collect or config_cache.collect
  assert(type(collect) == "function", "No config snapshot collector registered")
  config_cache.cache = {}
  local values = collect(initializing == true)
  for _, name in ipairs(vim.fn.sort(vim.tbl_keys(values))) do
    assert(name:match("^[%a_][%w_]*$"), "Invalid cache variable name")
    vim.g[name] = values[name]
    config_cache.append("let g:" .. name .. " = " .. vim.fn.string(values[name]))
  end
  config_cache.write()
end

config_cache.init = function(collect)
  config_cache.collect = collect or config_cache.collect
  if vim.fn.filereadable(config_cache.path) ~= 1 then
    config_cache.update(nil, true)
  end
end

return config_cache
