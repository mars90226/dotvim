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

return winbar
-- %{%v:lua.require'lualine'.statusline()%}
