local utils = {}

utils.get_packer_dir = function()
  return require('packer').config.package_root
end

utils.get_packer_start_dir = function()
  return utils.get_packer_dir() .. '/packer/start'
end

utils.get_packer_opt_dir = function()
  return utils.get_packer_dir() .. '/packer/opt'
end

return utils
