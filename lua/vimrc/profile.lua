-- Profile {{{
-- Disabled by default, enable to profile
-- vim.cmd [[profile start /tmp/profile.log]]
-- vim.cmd [[profile file *]]
-- vim.cmd [[profile func *]]
-- }}}

local profile_load = false

if profile_load then
  require("plenary.profile").start("/tmp/output_flame.log", { flame = true })
end
