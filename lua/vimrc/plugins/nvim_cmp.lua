local nvim_cmp = {}

nvim_cmp.enabled = true

nvim_cmp.is_enabled = function()
  return nvim_cmp.enabled
end

nvim_cmp.enable = function()
  nvim_cmp.enabled = true
end

nvim_cmp.disable = function()
  nvim_cmp.enabled = false
end

return nvim_cmp
