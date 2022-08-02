local plugin_utils = require("vimrc.plugin_utils")

-- TODO: Add this to JavaScript & CSS
if plugin_utils.is_executable('browser-sync') then
  vim.api.nvim_create_user_command("BrowserSync", [[Dispatch browser-sync start --server --files "*.js, *.html, *.css"]], {})
end
