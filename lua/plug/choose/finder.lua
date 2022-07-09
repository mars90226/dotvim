local plugin_utils = require("vimrc.plugin_utils")

local finder = {}

finder.setup = function()
  -- Choose finder plugin
  -- telescope.nvim

  if not plugin_utils.has_linux_build_env() then
    vim.fn["vimrc#plugin#disable_plugin"]("telescope-fzf-native.nvim")
  end
end

return finder
