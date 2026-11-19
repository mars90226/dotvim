package.loaded["vimrc.choose"] = {
  is_enabled_plugin = function()
    return true
  end,
}
package.loaded["vimrc.utils"] = {
  is_light_vim_mode = function()
    return false
  end,
}

local specs = dofile("lua/plug/plugins/file_navigation.lua")
local smart_open = vim.iter(specs):find(function(spec)
  return type(spec) == "table" and spec[1] == "danielfalk/smart-open.nvim"
end)
local sqlite = vim.iter(smart_open.dependencies):find(function(spec)
  return type(spec) == "table" and spec[1] == "kkharji/sqlite.lua"
end)

vim.uv.os_uname = function()
  return { sysname = "Darwin", machine = "x86_64" }
end
vim.uv.fs_stat = function()
  return nil
end
vim.env.LIBSQLITE = nil

if sqlite.init then
  sqlite.init()
end
vim.env.LIBSQLITE = "sqlite3" -- Startup commands run before the lazy dependency loads.
if sqlite.config then
  sqlite.config()
end
assert(vim.g.sqlite_clib_path == nil, "an automatic path would shadow the explicit LIBSQLITE")

vim.env.LIBSQLITE = nil
sqlite.config()
assert(vim.g.sqlite_clib_path == "/usr/lib/libsqlite3.dylib", "expected the system SQLite fallback")
