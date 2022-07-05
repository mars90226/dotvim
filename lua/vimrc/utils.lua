local utils = {}

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

return utils
