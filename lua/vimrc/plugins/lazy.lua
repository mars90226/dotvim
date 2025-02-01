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

my_lazy.setup_config = function()
  require("lazy").setup("plug.plugins", {
    change_detection = {
      notify = false, -- avoid loads of notification when changing config
    },
    ui = {
      border = "single",
    },
  })
end

my_lazy.setup = function()
  my_lazy.setup_config()
  my_lazy.setup_autocmd()
end

my_lazy.find_plugin = function(plugin_name)
  return require("lazy.core.config").plugins[plugin_name]
end

my_lazy.is_loaded = function(plugin_name)
  local plugin_spec = my_lazy.find_plugin(plugin_name)
  return plugin_spec ~= nil and plugin_spec._.loaded ~= nil
end

return my_lazy
