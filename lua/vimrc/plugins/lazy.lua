local lazy = require("lazy")

local my_lazy = {}

my_lazy.setup_autocmd = function()
  local augroup_id = vim.api.nvim_create_augroup("lazy_settings", {})
  vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      require("lazy.manage.reloader").enable()
    end,
  })
  vim.api.nvim_create_autocmd({ "FocusLost", "VimSuspend" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      require("lazy.manage.reloader").disable()
    end,
  })
end

my_lazy.setup = function()
  my_lazy.setup_autocmd()
end

my_lazy.find_plugin = function(plugin_name)
  for _, plugin in ipairs(lazy.plugins()) do
    if plugin[1] == plugin_name then
      return plugin
    end
  end
  return nil
end

return my_lazy
