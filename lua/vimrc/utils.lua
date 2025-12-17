local utils = {}

-- Lazy
utils.get_lazy_dir = function()
  return require("lazy.core.config").options.root
end

utils.helptags_all = function()
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

utils.table_filter_keys = function(table, keys)
  local filtered_table = {}
  for _, opt in ipairs(keys) do
    if table[opt] ~= nil then
      filtered_table[opt] = table[opt]
    end
  end
  return filtered_table
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
  return vim.env.VIM_MODE
end

utils.is_reader_mode = function()
  if not vim.g.loaded_reader_mode then
    vim.g.is_reader_mode = utils.get_vim_mode() == "reader"
    vim.g.loaded_reader_mode = true
  end

  return vim.g.is_reader_mode
end

utils.is_gitcommit_mode = function()
  if not vim.g.loaded_gitcommit_mode then
    vim.g.is_gitcommit_mode = utils.get_vim_mode() == "gitcommit"
    vim.g.loaded_gitcommit_mode = true
  end

  return vim.g.is_gitcommit_mode
end

utils.is_light_vim_mode = function()
  return utils.is_reader_mode() or utils.is_gitcommit_mode()
end

utils.is_main_vim_mode = function()
  if not vim.g.loaded_main_mode then
    vim.g.is_main_mode = utils.get_vim_mode() == "main"
    vim.g.loaded_main_mode = true
  end

  return vim.g.is_main_mode
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

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
---@param override? "never"|"global"|"always"
utils.set_keymap = function(mode, lhs, rhs, opts, override)
  override = override or "always"

  if override ~= "always" then
    local maparg = vim.fn.maparg(lhs, mode, false, true)
    local has_mapping = not vim.tbl_isempty(maparg)

    if override == "never" and has_mapping then
      return
    end
    if override == "global" and has_mapping and maparg.buffer == 1 then
      return
    end
  end

  vim.keymap.set(mode, lhs, rhs, opts)
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

-- Ref: fzf-lua utils
utils.get_visual_selection = function()
  -- this will exit visual mode
  -- use 'gv' to re-select the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- NOTE: not required since commit: e8b2093
    -- exit visual mode
    -- vim.api.nvim_feedkeys(
    --   vim.api.nvim_replace_termcodes("<Esc>",
    --     true, false, true), "n", true)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end
  -- swap vars if needed
  if cerow < csrow then csrow, cerow = cerow, csrow end
  if cecol < cscol then cscol, cecol = cecol, cscol end
  local lines = vim.fn.getline(csrow, cerow)
  -- local n = cerow-csrow+1
  local n = #lines
  if n <= 0 then return "" end
  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)
  return table.concat(lines, "\n"), {
    start   = { line = csrow, char = cscol },
    ["end"] = { line = cerow, char = cecol },
  }
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

utils.set_scratch = function()
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
end

-- wrapper around |input()| to allow cancellation with `<C-c>`
-- without "E5108: Error executing lua Keyboard interrupt"
-- Borrowed from fzf-lua
utils.input = function(prompt)
  local ok, res
  -- NOTE: do not use `vim.ui` yet, a conflict with snacks.nvim picker select
  -- causes the return value to appear as cancellation
  -- if vim.ui then
  if false then
    ok, _ = pcall(vim.ui.input, { prompt = prompt },
      function(input)
        res = input
      end)
  else
    ok, res = pcall(vim.fn.input, { prompt = prompt, cancelreturn = 3 })
    if res == 3 then
      ok, res = false, nil
    end
  end
  return ok and res or nil
end

return utils
