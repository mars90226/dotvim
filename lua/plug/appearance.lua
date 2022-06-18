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
    -- TODO: tabby.nvim broken in latest commit of "show-at-least-N-tabs"
    commit = "2ac781cae7aedade8def03d48a3a0616dce279ae",
    config = function()
      require("tabby").setup()
    end,
  })

  -- Devicons
  use({ "kyazdani42/nvim-web-devicons", module = "nvim-web-devicons" })

  -- Colors
  use({ "rktjmp/lush.nvim" })
  use({
    "ellisonleao/gruvbox.nvim",
    config = function()
      local hsl = require("lush").hsl
      local colors = require("gruvbox.colors")
      local utils = require("gruvbox.utils")

      local diff_darken_percent = 20
      local diff_colors = {
        dark_red = hsl(colors.faded_red).darken(diff_darken_percent).hex,
        dark_green = hsl(colors.faded_green).darken(diff_darken_percent).hex,
        dark_yellow = hsl(colors.faded_yellow).darken(diff_darken_percent).hex,
        dark_aqua = hsl(colors.faded_aqua).darken(diff_darken_percent).hex,
      }
      local custom_highlights = {
        -- NOTE: Only change background color
        DiffAdd = { bg = diff_colors.dark_green },
        DiffChange = { bg = diff_colors.dark_aqua },
        DiffDelete = { fg = diff_colors.dark_red, bg = colors.dark0, reverse = vim.g.gruvbox_inverse },
        DiffText = { bg = diff_colors.dark_yellow },

        -- NOTE: Avoid highlight link to avoid breaking tabby.nvim
        TabLine = { fg = colors.dark4, bg = colors.dark1, reverse = vim.g.gruvbox_invert_tabline },

        -- NOTE: Use similar highlight of StatusLine highlight for WinBar
        WinBar = { fg = colors.dark1, bg = colors.light3, reverse = vim.g.gruvbox_inverse },
        WinBarNC = { fg = colors.dark0, bg = colors.light4, reverse = vim.g.gruvbox_inverse },
      }

      utils.add_highlights(custom_highlights)
    end,
  })
  vim.g.colorscheme = "gruvbox"
  vim.g.lualine_theme = "auto"

  -- TODO: Disabled as diagnostic & vertical line highlight missing
  -- use({
  --   "luisiacc/gruvbox-baby",
  --   branch = "main",
  -- })
  -- vim.g.colorscheme = "gruvbox-baby"
  -- vim.g.lualine_theme = "gruvbox-baby"

  -- TODO: Fix cterm 16 colors in terminal
  -- use({
  --   "navarasu/onedark.nvim",
  --   config = function()
  --     local color = require("onedark.colors")
  --
  --     require("onedark").setup({
  --       style = "warmer",
  --       toggle_style_key = "<Leader>cs",
  --       highlights = {
  --         DiffAdd = { bg = color.diff_add },
  --         DiffChange = { bg = color.diff_change },
  --         DiffDelete = { bg = color.diff_delete },
  --         DiffText = { bg = color.diff_text },
  --       },
  --     })
  --
  --     require("onedark").load()
  --   end,
  -- })
  -- -- TODO: Avoid double loading & use correcty style
  -- vim.g.colorscheme = "onedark"
  -- vim.g.lualine_theme = "onedark"

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
