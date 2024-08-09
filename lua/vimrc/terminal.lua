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
  nnoremap("[[", [[?]] .. pattern .. [[<CR>]], "<silent>", "<buffer>")
  nnoremap("]]", [[/]] .. pattern .. [[<CR>]], "<silent>", "<buffer>")
end

return terminal
