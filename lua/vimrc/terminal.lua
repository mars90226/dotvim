local terminal = {}

terminal.setup_mapping = function()
  -- Navigate prompts
  local pattern = table.concat({ "❯", "CHROOT@" }, "\\|")
  nnoremap("[[", [[?]] .. pattern .. [[<CR>]], "<silent>", "<buffer>")
  nnoremap("]]", [[/]] .. pattern .. [[<CR>]], "<silent>", "<buffer>")
end

return terminal
