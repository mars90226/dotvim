local plugin_utils = require("vimrc.plugin_utils")

local dap = {}

-- Adapters' configurations are in mason-nvim-dap.nvim.
-- So the mapping name is from mason-nvim-dap.nvim.
-- Ref: https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
dap.adapters = {
  codelldb = {
    condition = plugin_utils.has_linux_build_env(),
  },
  python = {},
}

dap.get_dap_adapters = function()
  local checked_adapters = {}

  for adapter, config in pairs(dap.adapters) do
    -- NOTE: If the adapter is not enabled, we should skip it.
    if config.condition == false then
      -- Skip this adapter
    else
      table.insert(checked_adapters, adapter)
    end
  end

  return checked_adapters
end

return dap
