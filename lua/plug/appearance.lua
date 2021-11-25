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

  -- use 'marko-cerovac/material.nvim'
  -- vim.g.material_style = 'darker'
  -- vim.g.colorscheme = 'material'

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
end

return appearance
