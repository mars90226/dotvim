local frecency = require("frecency")

local my_frecency = {}

my_frecency.config = {
  -- Ref: https://github.com/nvim-telescope/telescope-frecency.nvim#remove-dependency-for-sqlitelua
  use_sqlite = false,
}

my_frecency.remove_files = function(paths)
  frecency.frecency().database:remove_files(paths)

  vim.notify("Removed " .. #paths .. " files from frecency database")
end

my_frecency.remove_pattern = function(lua_pattern)
  local entries = frecency.frecency().database:get_entries()
  local to_be_removed = {}
  for _, entry in ipairs(entries) do
    if string.match(entry.path, lua_pattern) then
      table.insert(to_be_removed, entry.path)
    end
  end

  frecency.frecency().database:remove_files(to_be_removed)

  vim.notify("Removed " .. #to_be_removed .. " files from frecency database")
end

return my_frecency
