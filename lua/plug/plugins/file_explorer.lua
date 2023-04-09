local choose = require("vimrc.choose")

local file_explorer = {
  -- NOTE: Lazy load doesn't improve much and break the :UpdateRemotePlugins
  -- TODO: Try again after switch to lazy.nvim
  {
    "Shougo/defx.nvim",
    cond = choose.is_enabled_plugin("defx.nvim"),
    build = ":UpdateRemotePlugins",
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/defx.vim")
    end,
  },
  {
    "kristijanhusak/defx-git",
    cond = choose.is_enabled_plugin("defx.nvim"),
  },
  {
    "kristijanhusak/defx-icons",
    cond = choose.is_enabled_plugin("defx.nvim"),
    event = { "VeryLazy" },
    config = function()
      vim.fn["vimrc#defx#setup"](true)
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
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
  },

  { "vifm/vifm.vim" },
}

return file_explorer
