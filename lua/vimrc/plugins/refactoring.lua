local refactoring_plugin = require("refactoring")

local refactoring = {}

refactoring.config = {
  printf_statements = {},
  print_var_statements = {},
}

refactoring.add_printf_config = function(filetype, printf_statement)
  refactoring.config.printf_statements[filetype] = vim.F.if_nil(refactoring.config.printf_statements[filetype], {})
  table.insert(refactoring.config.printf_statements[filetype], printf_statement)
end

refactoring.add_print_var_config = function(filetype, print_var_statement)
  refactoring.config.print_var_statements[filetype] = vim.F.if_nil(refactoring.config.print_var_statements[filetype], {})
  table.insert(refactoring.config.print_var_statements[filetype], print_var_statement)
end

-- NOTE: Default printf_statement will gone
refactoring.add_printf = function()
  local filetype = vim.bo.filetype
  local printf_statement = vim.fn.input("Printf Statement: ", "")
  refactoring.add_printf_config(filetype, printf_statement)
  refactoring.setup({})
end

-- NOTE: Default print_var_statement will gone
refactoring.add_print_var = function()
  local filetype = vim.bo.filetype
  local print_var_statement = vim.fn.input("Print Var Statement: ", "")
  refactoring.add_print_var_config(filetype, print_var_statement)
  refactoring.setup({})
end

refactoring.setup = function(config)
  refactoring.config = vim.tbl_deep_extend("force", refactoring.config, config or {})
  refactoring_plugin.setup(refactoring.config)
end

return refactoring
