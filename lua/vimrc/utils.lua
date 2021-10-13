local utils = {}

utils.get_packer_dir = function()
  return require('packer').config.package_root
end

utils.get_packer_start_dir = function()
  return utils.get_packer_dir() .. '/packer/start'
end

utils.get_packer_opt_dir = function()
  return utils.get_packer_dir() .. '/packer/opt'
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

return utils