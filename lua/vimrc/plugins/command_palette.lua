local utils = require("vimrc.utils")

local command_palette = {}

command_palette.menus = {}

local function add_to_cp_menu(category, commands)
  local cp = require("command_palette")

  for _, cp_category in ipairs(cp.CpMenu) do
    if cp_category[1] == category then
      utils.table_concat(cp_category, commands)
      return
    end
  end

  local new_cp_category = { category }
  utils.table_concat(new_cp_category, commands)
  table.insert(cp.CpMenu, new_cp_category)
end

command_palette.setup_menu = function()
  for category, commands in pairs(command_palette.menus) do
    add_to_cp_menu(category, commands)
  end
end

command_palette.insert_commands = function(category, commands)
  if not command_palette.menus[category] then
    command_palette.menus[category] = {}
  end
  utils.table_concat(command_palette.menus[category], commands)
end

command_palette.setup = function()
  local augroup_id = vim.api.nvim_create_augroup("command_palette_setup", {})

  -- Lazy load
  vim.api.nvim_create_autocmd({ "FocusLost", "CursorHold", "CursorHoldI" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      command_palette.setup_menu()
      -- NOTE: Due to multiple event, cannot use `once = true`.
      vim.api.nvim_del_augroup_by_id(augroup_id)
    end,
  })
end

return command_palette
