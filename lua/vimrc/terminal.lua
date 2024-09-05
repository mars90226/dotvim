local terminal = {}

terminal.startinsert_ignore_conditions = {}

terminal.is_startinsert_ignored = function()
  for _, condition in ipairs(terminal.startinsert_ignore_conditions) do
    if condition() then
      return true
    end
  end
  return false
end

terminal.add_startinsert_ignore_condition = function(condition)
  table.insert(terminal.startinsert_ignore_conditions, condition)
end

terminal.setup_mapping = function()
  -- Navigate prompts
  local pattern = table.concat({ "❯", "CHROOT@" }, [[\|]])
  vim.keymap.set("n", "[[", [[?]] .. pattern .. [[<CR>]], { silent = true, buffer = true })
  vim.keymap.set("n", "]]", [[/]] .. pattern .. [[<CR>]], { silent = true, buffer = true })
end

return terminal
