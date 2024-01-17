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
  -- NOTE: Use lualine.nvim winbar
  {
    "Bekaboo/dropbar.nvim",
    cond = choose.is_enabled_plugin("dropbar.nvim") and choose.is_enabled_plugin("dropbar.nvim-winbar"),
    config = function()
      require("vimrc.plugins.dropbar").setup()
    end,
  },

  -- Statuscolumn
  {
    "luukvbaal/statuscol.nvim",
    cond = choose.is_enabled_plugin("statuscol.nvim"),
    branch = "0.10",
    config = function()
      local builtin = require("statuscol.builtin")

      require("statuscol").setup({
        segments = {
          -- Default segments (fold -> sign -> line number -> separator)
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          { text = { "%s" }, click = "v:lua.ScSa" },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
        },
      })

      vim.api.nvim_create_user_command("ResetStatusColumn", function()
        vim.wo.statuscolumn = ""
        vim.wo.statuscolumn = "%!v:lua.StatusCol()"
      end, {})
    end,
  },

  -- Devicons
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "ryanoasis/vim-devicons", lazy = true },

  -- Colors
  { "rktjmp/lush.nvim", lazy = true },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 999,
    -- TODO: Remove after to avoid other plugin capture wrong highlight
    init = function()
      vim.g.lualine_theme = "auto"
    end,
    config = function()
      require("vimrc.plugins.gruvbox").setup()
    end,
  },

  -- Which key
  {
    "folke/which-key.nvim",
    event = { "VeryLazy" },
    config = function()
      vim.go.timeout = true
      vim.go.timeoutlen = 300
      require("which-key").setup({})
    end,
  },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = { "VimEnter" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <CR>"),
        dashboard.button("SPC f f", "  Find file"),
        dashboard.button("SPC f o", "  Recently opened files"),
        dashboard.button("SPC f m", "  Frecency/MRU"),
        dashboard.button("SPC f r", "  Find word"),
        dashboard.button("SPC f `", "  Jump to bookmarks"),
      }
      alpha.setup(dashboard.opts)
    end,
  },

  -- Scrollbar
  -- TODO: Try https://github.com/petertriho/nvim-scrollbar instead

  -- Notify
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },

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
    event = { "VeryLazy" },
    config = function()
      require("vimrc.plugins.indent_blankline").setup()
    end,
  },
}

return appearance
