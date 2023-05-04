local muren_api = require("muren.api")

local muren = {}

muren.open_unique_ui = function(pattern)
  vim.fn.setreg('/', pattern)
  muren_api.open_unique_ui({})
end

return muren
