local cmp_config_default = require("cmp.config.default")()

local nvim_cmp = {}

nvim_cmp.enabled = true

nvim_cmp.is_enabled = function()
  return cmp_config_default.enabled() and nvim_cmp.enabled
end

nvim_cmp.enable = function()
  nvim_cmp.enabled = true
end

nvim_cmp.disable = function()
  nvim_cmp.enabled = false
end

return nvim_cmp
