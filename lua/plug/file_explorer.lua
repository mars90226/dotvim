local file_explorer = {}

file_explorer.startup = function(use)
  -- NOTE: Lazy load doesn't improve much and break the :UpdateRemotePlugins
  use({
    "Shougo/defx.nvim",
    run = ":UpdateRemotePlugins",
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/defx.vim")
    end,
  })
  use("kristijanhusak/defx-git")
  use({
    "kristijanhusak/defx-icons",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      vim.fn["vimrc#defx#setup"](true)
    end,
  })

  use({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Neotree" },
    keys = { "<Space>nn", "<Space>nf", "<Space>n<Space>", "<Space>nd", "<Space>nb", "<Space>ns" },
    config = function()
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

      require("neo-tree").setup({
        window = {
          mappings = {
            ["z"] = function(_) end, -- Do nothing
            ["zr"] = "close_all_nodes",
            ["zz"] = function(_)
              vim.cmd([[normal! zz]])
            end,
            ["zt"] = function(_)
              vim.cmd([[normal! zt]])
            end,
            ["zb"] = function(_)
              vim.cmd([[normal! zb]])
            end,
            ["z/"] = function(_)
              vim.api.nvim_feedkeys("/", "n", false)
            end,
            ["z?"] = function(_)
              vim.api.nvim_feedkeys("?", "n", false)
            end,
          },
        },
      })

      nnoremap("<Space>nn", [[<Cmd>Neotree left<CR>]])
      nnoremap("<Space>nf", [[<Cmd>Neotree float<CR>]])
      nnoremap("<Space>n<Space>", [[<Cmd>Neotree reveal_force_cwd<CR>]])
      nnoremap("<Space>nd", [["<Cmd>Neotree float reveal_file=".expand("<cfile>")." reveal_force_cwd<CR>"]], "expr")
      nnoremap("<Space>nb", [[<Cmd>Neotree toggle show buffers right<CR>]])
      nnoremap("<Space>ns", [[<Cmd>Neotree float git_status<CR>]])

      cnoremap("<C-X>d", [[v:lua.require('vimrc.plugins.neotree').get_current_dir('filesystem')]], "expr")
      cnoremap("<C-X>f", [[v:lua.require('vimrc.plugins.neotree').get_current_path('filesystem')]], "expr")
    end,
  })

  use({ "vifm/vifm.vim" })
end

return file_explorer
