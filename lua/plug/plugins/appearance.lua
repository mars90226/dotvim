local choose = require("vimrc.choose")
local utils = require("vimrc.utils")

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
  -- NOTE: Lazy load will cause dashboard-nvim to show the statusline and not centered
  {
    "luukvbaal/statuscol.nvim",
    cond = choose.is_enabled_plugin("statuscol.nvim"),
    config = function()
      require("vimrc.plugins.statuscol").setup()
    end,
  },

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
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      -- Ref: https://github.com/LazyVim/LazyVim/blob/cbf1d335ed6a478a2e6144aa2d462a8330b2b0fc/lua/lazyvim/plugins/ui.lua
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  -- TODO: Add noice.nvim

  -- Indent Guide
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    -- NOTE: Latest commit requires neovim 0.11 nightly that has faster variant:
    --   `vim.validate(name, value, validator, optional, message)`
    -- Ref: [After upgrade to 3.8.3 config, an error occurs with old nightly Neovim versions · Issue 936 · lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim/issues/936)
    -- Ref: [Lua - Neovim docs](https://neovim.io/doc/user/lua.html#_lua-module:-vim.inspector)
    commit = "e7a4442",
    event = { "VeryLazy" },
    config = function()
      require("vimrc.plugins.indent_blankline").setup()
    end,
  },
}

return appearance
