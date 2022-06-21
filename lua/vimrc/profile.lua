local plenary_profile = require("plenary.profile")

local profile = {}

profile.config = {
  vim_profile_load = false,
  plenary_profile_load = false,
}

profile.start_vim_profile = function()
  vim.cmd([[profile start /tmp/profile.log]])
  vim.cmd([[profile file *]])
  vim.cmd([[profile func *]])
end

profile.stop_vim_profile = function()
  vim.cmd([[profile stop]])
end

profile.start_plenary_profile = function()
  plenary_profile.start("/tmp/output_flame.log", { flame = true })
end

profile.stop_plenary_profile = function()
  plenary_profile.stop()
end

profile.setup = function(opts)
  opts = opts or {}
  profile.config = vim.tbl_extend("force", profile.config, opts)

  if profile.config.vim_profile_load then
    profile.start_vim_profile()
  end

  if profile.config.plenary_profile_load then
    profile.start_plenary_profile()
  end
end

return profile
