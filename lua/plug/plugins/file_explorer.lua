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
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- TODO: Enable this
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    cmd = { "Neotree" },
    keys = { "<Space>nn", "<Space>nf", "<Space>n<Space>", "<Space>nd", "<Space>nb", "<Space>ns" },
    config = function()
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

      require("neo-tree").setup({
        sources = {
          "filesystem",
          "buffers",
          "git_status",
          "diagnostics",
          -- "netman.ui.neo-tree",
          -- ...and any additional source
        },
        window = {
          mappings = {
            ["z"] = function(_) end, -- Do nothing
            ["zm"] = "expand_all_nodes",
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
        source_selector = {
          winbar = true,
          statusline = false,
        }
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
  {
    "mrbjarksen/neo-tree-diagnostics.nvim",
    requires = "nvim-neo-tree/neo-tree.nvim",
    module = "neo-tree.sources.diagnostics",
    lazy = true,
  },

  {
    "vifm/vifm.vim",
    cmd = { "EditVifm", "Vifm", "SplitVifm", "VsplitVifm", "TabVifm" },
  },

  -- TODO: Lazy load for oil:// schema
  -- Ref: https://github.com/stevearc/oil.nvim/issues/75
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Oil" },
    keys = { "<Space>o", "<Space>O", "<Space><C-O>" },
    config = function()
      require("vimrc.plugins.oil").setup()
    end,
  },

  -- Protocol
  {
    "miversen33/netman.nvim",
    enabled = false,
    config = function()
      require("netman")
    end
  }
}

return file_explorer
