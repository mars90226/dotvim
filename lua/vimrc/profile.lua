local has_plenary_profile, plenary_profile = pcall(require, "plenary.profile")

local utils = require("vimrc.utils")

local profile = {}

profile.config = {
  vim_profile_load = false,
  plenary_profile_load = false,
  vim_profile_path = "/tmp/profile.log",
  plenary_profile_path = "/tmp/output_flame.log",
  use_flame = true,
  setup_command = true,
}

profile.start_vim_profile = function()
  vim.cmd([[profile start ]]..profile.config.vim_profile_path)
  vim.cmd([[profile file *]])
  vim.cmd([[profile func *]])
end

profile.stop_vim_profile = function()
  vim.cmd([[profile stop]])
end

profile.open_vim_profile_log = function()
  vim.cmd([[tabedit ]]..profile.config.vim_profile_path)
end

profile.start_plenary_profile = function(use_flame)
  local opts = {
    flame = utils.ternary(use_flame ~= nil, use_flame, profile.config.use_flame)
  }

  if has_plenary_profile then
    plenary_profile.start(profile.config.plenary_profile_path, opts)
  else
    vim.notify("plenary.profile does not exist!", vim.log.levels.ERROR)
  end
end

profile.stop_plenary_profile = function()
  if has_plenary_profile then
    plenary_profile.stop()
  else
    vim.notify("plenary.profile does not exist!", vim.log.levels.ERROR)
  end
end

profile.open_plenary_profile_log = function()
  vim.cmd([[tabedit ]]..profile.config.plenary_profile_path)
end

profile.setup = function(opts)
  opts = opts or {}
  profile.config = vim.tbl_extend("force", profile.config, opts)

  if profile.config.vim_profile_load then
    profile.start_vim_profile()
  end

  if profile.config.plenary_profile_load then
    profile.start_plenary_profile(profile.config.use_flame)
  end

  if profile.config.setup_command then
    vim.cmd([[command! StartVimProfile lua require("vimrc.profile").start_vim_profile()]])
    vim.cmd([[command! StopVimProfile lua require("vimrc.profile").stop_vim_profile()]])
    vim.cmd([[command! -bang StartPlenaryProfile lua require("vimrc.profile").start_plenary_profile("<bang>" ~= "!")]])
    vim.cmd([[command! StopPlenaryProfile lua require("vimrc.profile").stop_plenary_profile()]])
  end
end

return profile
