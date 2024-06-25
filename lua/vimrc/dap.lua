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
dap.filetypes = nil

-- NOTE: This is a copy of the mappings from mason-nvim-dap.nvim.
-- If using "require" here, it will cause a circular dependency.
-- So we cannot depend on mason-nvim-dap.nvim here.
local mason_nvim_dap_mappings_filetype = {
  ["bash"] = { "sh" },
  ["chrome"] = { "javascriptreact", "typescriptreact", "typescript", "javascript" },
  ["codelldb"] = { "c", "cpp", "rust", "swift", "zig" },
  ["coreclr"] = { "cs", "fsharp" },
  ["cppdbg"] = { "c", "cpp", "rust", "asm", "swift" },
  ["dart"] = { "dart" },
  ["delve"] = { "go" },
  ["firefox"] = { "javascriptreact", "typescriptreact", "typescript", "javascript" },
  ["kotlin"] = { "kotlin" },
  ["mix_task"] = { "elixir" },
  ["node2"] = { "javascriptreact", "typescriptreact", "typescript", "javascript" },
  ["php"] = { "php" },
  ["python"] = { "python" },
  ["haskell"] = { "haskell" },
}

dap.is_supported_adapter = function(adapter)
  return dap.adapters[adapter] ~= nil
end

dap.get_filetypes = function()
  if not dap.filetypes then
    local filetype_map = {}

    for dap_adapter, filetypes in pairs(mason_nvim_dap_mappings_filetype) do
      if dap.is_supported_adapter(dap_adapter) then
        for _, filetype in ipairs(filetypes) do
          filetype_map[filetype] = true
        end
      end
    end

    dap.filetypes = vim.tbl_keys(filetype_map)
  end

  return dap.filetypes
end

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
