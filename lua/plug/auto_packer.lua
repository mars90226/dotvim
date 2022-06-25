local auto_packer = {}

auto_packer.packer_bootstrap = nil

auto_packer.init = function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    auto_packer.packer_bootstrap = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
  end
end

auto_packer.check_sync = function()
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if auto_packer.packer_bootstrap ~= nil then
    require("packer").sync()
  end
end

auto_packer.init()

return auto_packer
