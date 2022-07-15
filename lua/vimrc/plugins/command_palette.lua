local utils = require("vimrc.utils")

local command_palette = {}

command_palette.same = function(text)
  return function()
    return text
  end
end

command_palette.menus = {}
command_palette.terminal_commands = {
  tldr = command_palette.same("tldr "),
  navi = command_palette.same("navi "),
}
command_palette.cmdline_commands = {
  file = function()
    return vim.fn["vimrc#fzf#files_in_commandline"]()
  end,
}

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

command_palette.insert_terminal_commands = function(terminal_commands)
  command_palette.terminal_commands = vim.tbl_extend(
    "force",
    command_palette.terminal_commands,
    terminal_commands or {}
  )
end

command_palette.execute_terminal_command = function(command)
  local fn = command_palette.terminal_commands[command]
  local result = fn and fn() or ""
  vim.api.nvim_paste(result, true, -1)
end

command_palette.create_terminal_command = function(command)
  -- TODO: Escape
  return string.format([[lua require("vimrc.plugins.command_palette").execute_terminal_command("%s")]], command)
end

command_palette.setup_terminal = function()
  for command, _ in pairs(command_palette.terminal_commands) do
    command_palette.insert_commands("Terminal", {
      { command, command_palette.create_terminal_command(command), 1 },
    })
  end
end

command_palette.insert_cmdline_commands = function(cmdline_commands)
  command_palette.cmdline_commands = vim.tbl_extend("force", command_palette.cmdline_commands, cmdline_commands or {})
end

-- FIXME: If cmdline is currently empty, then this will insert to previous commmand
command_palette.execute_cmdline_command = function(command)
  local fn = command_palette.cmdline_commands[command]
  local result = fn and fn() or ""
  vim.api.nvim_feedkeys(utils.t(":<Up>")..result, 'm', true)
end

command_palette.create_cmdline_command = function(command)
  -- TODO: Escape
  return string.format([[lua require("vimrc.plugins.command_palette").execute_cmdline_command("%s")]], command)
end

command_palette.setup_cmdline = function()
  for command, _ in pairs(command_palette.cmdline_commands) do
    command_palette.insert_commands("Cmdline", {
      { command, command_palette.create_cmdline_command(command) },
    })
  end
end

command_palette.setup = function()
  local augroup_id = vim.api.nvim_create_augroup("command_palette_setup", {})

  command_palette.setup_terminal()
  command_palette.setup_cmdline()

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
