local appearance = {}

appearance.startup = function(use)
  -- Status Line
  use({
    "nvim-lualine/lualine.nvim",
    config = function()
      require("vimrc.plugins.lualine")
    end,
  })

  -- Tabline
  use({
    "nanozuki/tabby.nvim",
    config = function()
      require("vimrc.plugins.tabby")
    end,
  })

  -- Devicons
  use({ "kyazdani42/nvim-web-devicons", module = "nvim-web-devicons" })

  -- Colors
  use("rktjmp/lush.nvim")
  use("ellisonleao/gruvbox.nvim")
  vim.g.colorscheme = "gruvbox"
  vim.g.lualine_theme = "auto"

  -- use("marko-cerovac/material.nvim")
  -- vim.g.material_style = "darker"
  -- vim.g.colorscheme = "material"
  -- vim.g.lualine_theme = "material-nvim"

  -- use({
  --   "catppuccin/nvim",
  --   as = "catppuccin",
  --   config = function()
  --     require("catppuccin").setup()
  --   end,
  -- })
  -- vim.g.colorscheme = "catppuccin"
  -- vim.g.lualine_theme = "catppuccin"

  -- Which key
  use({
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})

      vim.go.timeoutlen = 500
    end,
  })

  -- Dashboard
  use({
    "goolord/alpha-nvim",
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
  })

  -- Scrollbar
  use({
    "dstein64/nvim-scrollview",
    config = function()
      vim.cmd([[augroup nvim_scrollview_exclude_diff]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd DiffUpdated * execute &diff ? 'ScrollViewDisable' : 'ScrollViewEnable']])
      vim.cmd([[augroup END]])
    end,
  })
end

return appearance
