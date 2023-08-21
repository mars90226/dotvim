local lazy = {}

lazy.setup_autocmd = function()
  local augroup_id = vim.api.nvim_create_augroup("lazy_settings", {})
  vim.api.nvim_create_autocmd({ "FocusGained" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      require("lazy.manage.reloader").enable()
    end,
  })
  vim.api.nvim_create_autocmd({ "FocusLost" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      require("lazy.manage.reloader").disable()
    end,
  })
end

lazy.setup = function()
  lazy.setup_autocmd()
end

return lazy
