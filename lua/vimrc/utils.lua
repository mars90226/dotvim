local utils = {}

-- Lazy
utils.get_lazy_dir = function()
  return require("lazy.core.config").options.root
end

utils.helptags_all = function()
  -- Lazy
  -- TODO: Implement

  vim.cmd([[helptags ALL]])
end

-- The function is called `t` for `termcodes`.
-- You don't have to call it that, but I find the terseness convenient
-- ref: https://github.com/nanotee/nvim-lua-guide
utils.t = function(str)
  -- Adjust boolean arguments as needed
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

utils.plug_key = function()
  -- HACK: Seems no proper way to express "<Plug>" in Lua string when used in `feedkeys()`/`nvim_feedkeys()`.
  -- ref: https://www.reddit.com/r/neovim/comments/kup1g0/comment/givujwd/?utm_source=reddit&utm_medium=web2x&context=3
  return string.format("%c%c%c", 0x80, 253, 83)
end

-- Return keys for Meta + Fn key
-- For Alt + Function keys, the keycode may be wrong when using "<M-Fn>" in different `$TERM`s.
-- When $TERM is `tmux`/`tmux-256color`, the generated keycode for <M-F1> ~ <M-F12> recognized as <F49> ~ <F60> by neovim.
-- Ref: https://github.com/neovim/neovim/issues/8317
utils.meta_fn_key = function(key)
  return {
    string.format("<M-F%d>", key),
    string.format("<F%d>", key + 48), -- For $TERM = tmux or tmux-256color
  }
end

-- Concat two tables
utils.table_concat = function(table1, table2)
  for i = 1, #table2 do
    table1[#table1 + 1] = table2[i]
  end
  return table1
end

-- Map table
utils.table_map = function(table, fn)
  local new_table = {}
  for key, value in pairs(table) do
    new_table[key] = fn(value)
  end
  return new_table
end

-- str:gmatch() with variable captures support
utils.gmatch_as_table = function(str, ...)
  local matches = {}

  -- Implement gmatch with variable captures using while & iterator
  -- Ref: https://www.lua.org/manual/5.3/manual.html#3.3.5
  do
    local f, s, var = str:gmatch(...)
    while true do
      local items = { f(s, var) } -- NOTE: Use {} to create table
      if items[1] == nil then
        break
      end
      var = items[1]
      table.insert(matches, items)
    end
  end

  return matches
end

-- ref: https://github.com/LunarVim/LunarVim/blob/rolling/lua/lvim/core/cmp.lua
utils.check_backspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

-- list_option should be Option object with list type
utils.toggle_list_option_flag = function(list_option, flag)
  if vim.tbl_contains(list_option:get(), flag) then
    list_option:remove(flag)
  else
    list_option:append(flag)
  end
end

utils.get_vim_home = function()
  return vim.env.HOME .. "/.vim"
end

utils.get_vim_mode = function()
  return vim.fn["vimrc#get_vim_mode"]()
end

utils.is_reader_mode = function()
  return utils.get_vim_mode() == "reader"
end

utils.is_gitcommit_mode = function()
  return utils.get_vim_mode() == "gitcommit"
end

utils.is_light_vim_mode = function()
  return utils.is_reader_mode() or utils.is_gitcommit_mode()
end

utils.ternary = function(condition, true_value, false_value)
  if condition then
    return true_value
  else
    return false_value
  end
end

utils.remap = function(old_key, new_key, mode)
  local maparg
  maparg = vim.fn.maparg(old_key, mode, false, true)

  if maparg then
    vim.keymap.del(mode, old_key)
    vim.keymap.set(mode, new_key, maparg.rhs)
  end
end

utils.get_char = function(opts)
  local options = vim.tbl_extend("force", { prompt = "Press any key: " }, opts or {})

  local _get_char = function()
    print(options.prompt)
    return vim.fn.getchar()
  end

  local char = _get_char()
  while char == utils.t("<CursorHold>") do
    char = _get_char()
  end

  return char
end

utils.get_char_string = function(opts)
  return vim.fn.nr2char(utils.get_char(opts))
end

utils.display_char = function()
  local char = utils.get_char()
  vim.notify(vim.fn.printf('Raw: "%s" | Char: "%s', char, vim.fn.nr2char(char)), vim.log.levels.INFO)
end

utils.get_buffer_variable = function(buf, var)
  local status, result = pcall(vim.api.nvim_buf_get_var, buf, var)
  if status then
    return result
  end
  return nil
end

-- Return 0-based range (start with 0) and the ending range is exclusive.
utils.get_visual_selection_range = function()
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))

  if start_row < end_row or (start_row == end_row and start_col <= end_col) then
    return start_row - 1, start_col - 1, end_row - 1, end_col
  else
    return end_row - 1, end_col - 1, start_row - 1, start_col
  end
end

utils.get_visual_selection = function()
  local start_row, start_col, end_row, end_col = utils.get_visual_selection_range()
  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)

  if vim.tbl_isempty(lines) then
    return ""
  end

  lines[#lines] = string.sub(lines[#lines], 1, end_col - (vim.go.selection == "inclusive" and 0 or 1))
  lines[1] = string.sub(lines[1], start_col + 1)

  return vim.fn.join(lines, "\n")
end

-- NOTE: JavaScript setTimeout like function
utils.set_timeout = function(timeout, callback)
  local timer = vim.loop.new_timer()
  timer:start(timeout, 0, function()
    timer:stop()
    timer:close()
    callback()
  end)
  return timer
end

-- NOTE: JavaScript setInterval like function
utils.set_interval = function(interval, callback)
  local timer = vim.loop.new_timer()
  timer:start(interval, interval, function()
    callback()
  end)
  return timer
end

-- NOTE: JavaScript clearInterval like function
utils.clear_interval = function(timer)
  timer:stop()
  timer:close()
end

---Ref: bigfile.nvim
---@param bufnr number
---@return integer|nil size if buffer is valid, nil otherwise
utils.get_buf_size = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ok, stats = pcall(function()
    return vim.loop.fs_stat(vim.api.nvim_buf_get_name(bufnr))
  end)
  if not (ok and stats) then
    return
  end
  return stats.size
end

return utils
