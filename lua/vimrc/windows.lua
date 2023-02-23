local windows = {}

windows.execute_current_file = function()
  vim.cmd([[!start cmd /c "%:p"]])
end

windows.open_terminal_in_current_file_folder = function()
  vim.cmd([[!start cmd /K cd /D %:p:h]])
end

windows.reveal_current_file_folder_in_explorer = function()
  vim.cmd('!start explorer "' .. vim.fn.expand([[%:p:h:gs?\??:gs?/?\?]]) .. '"')
end

return windows
