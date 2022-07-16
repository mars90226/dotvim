local utils = require("vimrc.utils")

local command_palette = {}

command_palette.same = function(text)
  return function()
    return text
  end
end

command_palette.terminal_join = function(terminal_commands)
  local commands = vim.deepcopy(terminal_commands)
  table.insert(commands, "\n")
  local command = table.concat(commands, "; ")
  return command_palette.same(command)
end

command_palette.menus = {}
command_palette.custom_commands = {
  -- Insert command result in terminal
  terminal = {
    tldr = command_palette.same("tldr "),
    navi = command_palette.same("navi "),
  },
  -- Insert command result in cmdline
  cmdline = {
    file = function()
      return vim.fn["vimrc#fzf#files_in_commandline"]()
    end,
  },
  -- Browse command result in browser
  browse = {
    devdocs = command_palette.same("https://devdocs.io"),
    duckduckgo = command_palette.same("https://duckduckgo.com/"),
  },
  -- Search command result in browser
  search = {
    devdocs = command_palette.same("https://devdocs.io/?q=%s"),
    duckduckgo = command_palette.same("https://duckduckgo.com/?q=%s"),
  },
}
command_palette.custom_command_handlers = {
  terminal = function(result)
    vim.api.nvim_paste(result, true, -1)

    vim.schedule(function()
      vim.cmd([[startinsert!]])
    end)
  end,
  cmdline = function(result)
    -- FIXME: If cmdline is currently empty, then this will insert to previous commmand
    vim.api.nvim_feedkeys(utils.t(":<Up>") .. result, "m", true)
  end,
  browse = function(result)
    vim.cmd([[Browse ]]..result)
  end,
  search = function(result)
    local keyword = vim.fn.input('Search keyword: ', '')
    local url = string.format(result, keyword)
    vim.cmd([[Browse ]]..url)
  end
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

command_palette.insert_custom_commands = function(category, custome_commands)
  command_palette.custom_commands[category] = vim.F.if_nil(command_palette.custom_commands[category], {})
  command_palette.custom_commands[category] = vim.tbl_extend(
    "force",
    command_palette.custom_commands[category],
    custome_commands or {}
  )
end

command_palette.execute_custom_command = function(category, command)
  local custom_commands = vim.F.if_nil(command_palette.custom_commands[category], {})
  local fn = custom_commands[command]
  local result = fn and fn() or ""

  local custom_command_handler = command_palette.custom_command_handlers[category]
  if custom_command_handler ~= nil then
    custom_command_handler(result)
  end
end

command_palette.create_custom_command = function(category, command)
  -- TODO: Escape
  return string.format(
    [[lua require("vimrc.plugins.command_palette").execute_custom_command("%s", "%s")]],
    category,
    command
  )
end

command_palette.setup_custom_command = function()
  for category, custom_commands in pairs(command_palette.custom_commands) do
    for command, _ in pairs(custom_commands) do
      command_palette.insert_commands(category, {
        { command, command_palette.create_custom_command(category, command) },
      })
    end
  end
end

command_palette.setup = function()
  local augroup_id = vim.api.nvim_create_augroup("command_palette_setup", {})

  command_palette.setup_custom_command()

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
