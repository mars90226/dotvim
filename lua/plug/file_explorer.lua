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

      nnoremap("<Space>nn", [[<Cmd>Neotree left<CR>]])
      nnoremap("<Space>nf", [[<Cmd>Neotree float<CR>]])
      nnoremap("<Space>n<Space>", [[<Cmd>Neotree toggle reveal_force_cwd<CR>]])
      nnoremap("<Space>nd", [["<Cmd>Neotree float reveal_file=".expand("<cfile>")." reveal_force_cwd<CR>"]], "expr")
      nnoremap("<Space>nb", [[<Cmd>Neotree toggle show buffers right<CR>]])
      nnoremap("<Space>ns", [[<Cmd>Neotree float git_status<CR>]])

      cnoremap("<C-X>d", [[v:lua.require('vimrc.plugins.neotree').get_current_dir('filesystem')]], "expr")
      cnoremap("<C-X>f", [[v:lua.require('vimrc.plugins.neotree').get_current_path('filesystem')]], "expr")
    end,
  })
end

return file_explorer
