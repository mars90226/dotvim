local navic = require("nvim-navic")

local plugin_utils = require("vimrc.plugin_utils")

local winbar = {}

winbar.plugin_check = {
  ['nvim-navic'] = plugin_utils.is_enabled_plugin('nvim-navic')
}

winbar.winbar = function()
  local winbar_content = ""

  if winbar.plugin_check['nvim-navic'] and navic.is_available() then
    winbar_content = winbar_content .. navic.get_location()
  end

  return winbar_content
end

winbar.attach = function(bufnr)
  vim.wo.winbar = [[%{v:lua.require('vimrc.winbar').winbar()}]]
end

winbar.setup = function()
  local winbar_settings_augroup_id = vim.api.nvim_create_augroup("winbar_settings", {})
  vim.api.nvim_create_autocmd({ "WinNew" }, {
    group = winbar_settings_augroup_id,
    pattern = "*",
    callback = function()
      -- NOTE: Clear winbar to avoid inheriting winbar setting from other window
      vim.wo.winbar = ""
    end,
  })
end

return winbar
-- %{%v:lua.require'lualine'.statusline()%}
