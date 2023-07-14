local luasnip = require("luasnip")

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

command_palette.luasnip_expand_handler = function(filetype)
  return function(result)
    -- 1. Create a new [filetype] buffer with result.
    -- 2. Expand with LuaSnip.
    -- 3. Copy/Paste the expand result to orignal buffer.
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("filetype", filetype, { buf = buf })
    vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, { result })
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "cursor",
      width = math.floor(vim.api.nvim_win_get_width(0) * vim.g.float_width_ratio),
      height = math.floor(vim.api.nvim_win_get_height(0) * vim.g.float_height_ratio),
      bufpos = { 0, 0 },
      style = "minimal",
      border = "rounded",
    })
    vim.cmd([[startinsert!]])
    luasnip.expand()

    local expand_result = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_paste(vim.fn.join(expand_result, "\n"), true, -1)

    vim.schedule(function()
      vim.cmd([[startinsert!]])
    end)
  end
end

command_palette.menus = {}
command_palette.custom_commands = {
  -- Insert command result in terminal
  -- FIXME: Cancel will leave in normal mode
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
    DevDocs = command_palette.same("https://devdocs.io"),
    DuckDuckGo = command_palette.same("https://duckduckgo.com/"),
    MDN = command_palette.same("https://developer.mozilla.org/en-US/"),

    -- AI
    -- TODO: Use a list?
    ChatGPT = command_palette.same("https://chat.openai.com/"),
    Bing = command_palette.same("https://bing.com/chat"),
    Bard = command_palette.same("https://bard.google.com/"),
    YOU = command_palette.same("https://you.com/chat"),
    Fronfront = command_palette.same("https://chat.forefront.ai"),
    Phind = command_palette.same("https://phind.com"),
    Perplexity = command_palette.same("https://perplexity.ai"),
    DevGPT = command_palette.same("https://www.getdevkit.com/devgpt"),
  },
  -- Search command result in browser
  search = {
    DevDocs = command_palette.same("https://devdocs.io/?q=%s"),
    DuckDuckGo = command_palette.same("https://duckduckgo.com/?q=%s"),
    MDN = command_palette.same("https://developer.mozilla.org/en-US/search?q=%s"),
  },
  -- TODO: List all LuaSnip/Ask filetype from input()
  -- TODO: Merge all filetype
  -- LuaSnip shell command result in expanding LuaSnip shell snippets
  ["LuaSnip shell"] = {
    files = command_palette.same("gf"),
    ["MRU files"] = command_palette.same("gm"),
    ["MRU directories"] = command_palette.same("gd"),
    ["commit SHA"] = command_palette.same("gy"),
    ["git current branch"] = command_palette.same("gc"),
    ["git commits"] = command_palette.same("gi"),
    ["git branches"] = command_palette.same("gb"),
    ["git tags"] = command_palette.same("gt"),
    ["git email"] = command_palette.same("ge"),
    ["company domain"] = command_palette.same("cd"),
    ["company email"] = command_palette.same("ce"),
    ["shell outputs"] = command_palette.same("xx"),
  },
  -- LuaSnip gitcommit command result in expanding LuaSnip gitcommit snippets
  ["LuaSnip gitcommit"] = {},
  -- LuaSnip markdown command result in expanding LuaSnip markdown snippets
  ["LuaSnip markdown"] = {
    ["Chinese punctuation"] = command_palette.same("cpf"),
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
    vim.cmd([[Browse ]] .. result)
  end,
  search = function(result)
    local keyword = vim.fn.input("Search keyword: ", "")
    local url = string.format(result, keyword)
    vim.cmd([[Browse ]] .. url)
  end,
  ["LuaSnip shell"] = command_palette.luasnip_expand_handler("sh"),
  ["LuaSnip gitcommit"] = command_palette.luasnip_expand_handler("gitcommit"),
  ["LuaSnip markdown"] = command_palette.luasnip_expand_handler("markdown"),
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
  command_palette.custom_commands[category] =
    vim.tbl_extend("force", command_palette.custom_commands[category], custome_commands or {})
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

-- Open with fzf-tmux, able to invoke in anywhere including cmdline.
-- fzf-tmux may be slow if using slow terminal emulator
command_palette.open_with_fzf = function()
  local cp = require("command_palette")

  -- TODO: Data structure of CpMenu is so bad...
  local categories = {}
  local category_index_map = {}
  for index, cp_category in ipairs(cp.CpMenu) do
    table.insert(categories, cp_category[1])
    category_index_map[cp_category[1]] = index
  end

  local category = vim.fn["vimrc#fzf#choices_in_commandline"](categories, "Command Palette Category")
  if category == "" then
    return
  end

  local commands = {}
  local command_index_map = {}
  for index, category_command in ipairs({ unpack(cp.CpMenu[category_index_map[category]], 2) }) do
    table.insert(commands, category_command[1])
    command_index_map[category_command[1]] = index + 2 - 1 -- Add command index offset
  end

  local command = vim.fn["vimrc#fzf#choices_in_commandline"](commands, "Command Palette")
  if command == "" then
    return
  end

  local command_value = cp.CpMenu[category_index_map[category]][command_index_map[command]][2]
  local should_start_insert = cp.CpMenu[category_index_map[category]][command_index_map[command]][3] == 1

  if should_start_insert then
    vim.schedule(function()
      vim.cmd([[startinsert!]])
    end)
  end

  vim.api.nvim_exec(command_value, true)
end

command_palette.setup = function()
  command_palette.setup_custom_command()
  command_palette.setup_menu()
end

return command_palette
