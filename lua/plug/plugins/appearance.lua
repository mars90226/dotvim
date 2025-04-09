local choose = require("vimrc.choose")

local appearance = {
  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    config = function()
      require("vimrc.plugins.lualine").setup()

      vim.cmd([[command! FixLualineStatusline set statusline=%{%v:lua.require'lualine'.statusline()%}]])
    end,
  },

  -- Tabline
  -- NOTE: Use lualine.nvim tabline

  -- Winbar
  {
    "Bekaboo/dropbar.nvim",
    cond = choose.is_enabled_plugin("dropbar.nvim") and choose.is_enabled_plugin("dropbar.nvim-winbar"),
    config = function()
      require("vimrc.plugins.dropbar").setup()
    end,
  },

  -- Statuscolumn
  -- Use snacks.nvim statuscolumn

  -- Devicons
  -- TODO: Replace with mini.icon
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Colors
  { "rktjmp/lush.nvim", lazy = true },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 999,
    -- TODO: Remove after to avoid other plugin capture wrong highlight
    init = function()
      vim.g.colorscheme = "gruvbox"
      vim.g.lualine_theme = "auto"
    end,
    config = function()
      require("vimrc.plugins.gruvbox").setup()
    end,
  },

  -- Which key
  -- TODO: May need to check all keys that depends on timeoutlen (has overlapping prefix)
  -- TODO: which-key.nvim check key every 50 ms, may need to check if it affects performance.
  {
    "folke/which-key.nvim",
    event = { "VeryLazy" },
    opts = {
      preset = "modern",
    },
    keys = {
      -- NOTE: Some key mappings cannot be triggered when using which-key menu triggered by key
      -- mapping prefix. But those are actually working when using which-key show command.
      {
        "<Space>?",
        function()
          require("which-key").show()
        end,
        desc = "All Keymaps (which-key)",
      },
      {
        "<Leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- Dashboard
  -- Use snacks.nvim dashboard

  -- Scrollbar
  -- TODO: Try https://github.com/petertriho/nvim-scrollbar instead

  -- Notify
  -- Use snacks.nvim notifier

  -- UI
  -- Use snacks.nvim input & picker.select
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  -- TODO: Add noice.nvim

  -- Indent Guide
  -- Use snacks.nvim indent
}

return appearance
