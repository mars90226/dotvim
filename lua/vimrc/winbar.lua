local choose = require("vimrc.choose")

local winbar = {}

winbar.plugin_check = {
  ["nvim-navic"] = choose.is_enabled_plugin("nvim-navic"),
}

winbar.winbar = function()
  local winbar_content = "%f"

  if winbar.plugin_check["nvim-navic"] then
    local has_navic, navic = pcall(require, "nvim-navic")

    if has_navic and navic.is_available() then
      local location = navic.get_location()

      if location ~= "" then
        winbar_content = winbar_content .. " > " .. location
      end
    end
  end

  return winbar_content
end

winbar.attach = function(bufnr)
  vim.wo.winbar = [[%{%v:lua.require('vimrc.winbar').winbar()%}]]
end

-- TODO: Fix winbar in BufWinEnter
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
