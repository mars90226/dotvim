local utils = {}

-- Packer
utils.get_packer_dir = function()
  return require("packer").config.package_root
end

utils.get_packer_start_dir = function()
  return utils.get_packer_dir() .. "/packer/start"
end

utils.get_packer_opt_dir = function()
  return utils.get_packer_dir() .. "/packer/opt"
end

utils.helptags_all = function()
  for _, path in ipairs(vim.fn.glob(utils.get_packer_opt_dir() .. "/*", 1, 1)) do
    vim.cmd("packadd " .. vim.fn.fnamemodify(path, ":t"))
  end
  vim.cmd([[helptags ALL]])
end

-- The function is called `t` for `termcodes`.
-- You don't have to call it that, but I find the terseness convenient
-- ref: https://github.com/nanotee/nvim-lua-guide
utils.t = function(str)
  -- Adjust boolean arguments as needed
  return vim.api.nvim_replace_termcodes(str, true, true, true)
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

-- FIXME: Use neovim API to get config home to avoid "~/.vim" not exist problem
-- Also need to fix vimrc#get_vimhome()
utils.get_vim_home = function()
  return vim.env.HOME .. "/.vim"
end

utils.get_vim_mode = function()
  return vim.fn["vimrc#get_vim_mode"]()
end

utils.is_light_vim_mode = function()
  local vim_mode = utils.get_vim_mode()
  return vim_mode == "reader" or vim_mode == "gitcommit"
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

return utils
