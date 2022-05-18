local file_explorer = {}

file_explorer.startup = function(use)
  use({
    "Shougo/defx.nvim",
    run = ":UpdateRemotePlugins",
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/defx.vim")
      vim.fn["vimrc#source"]("vimrc/plugins/defx_after.vim")
    end,
  })
  use("kristijanhusak/defx-git")
  use("kristijanhusak/defx-icons")

  use({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
    end,
  })
end

return file_explorer
