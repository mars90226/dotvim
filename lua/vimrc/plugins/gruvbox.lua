local gruvbox = {}

gruvbox.setup = function()
  local hsl = require("lush").hsl
  local palette = require("gruvbox.palette").colors

  local diff_percent = 20
  local custom_palette = {
    white_yellow = hsl(palette.bright_yellow).lighten(diff_percent * 2).hex,
    dark_red = hsl(palette.faded_red).darken(diff_percent).hex,
    dark_green = hsl(palette.faded_green).darken(diff_percent).hex,
    dark_yellow = hsl(palette.faded_yellow).darken(diff_percent).hex,
    dark_aqua = hsl(palette.faded_aqua).darken(diff_percent).hex,
  }
  local overrides = {
    NormalFloat = { fg = palette.light1, bg = palette.dark1 },
    TSOperator = { link = "Special" },

    -- NOTE: Only change background color
    DiffAdd = { fg = nil, bg = custom_palette.dark_green },
    DiffChange = { bg = custom_palette.dark_aqua },
    DiffDelete = { fg = palette.dark0, bg = custom_palette.dark_red },
    DiffText = { bg = custom_palette.dark_yellow },

    -- NOTE: Avoid highlight link to avoid breaking tabby.nvim
    TabLine = { fg = palette.dark1, bg = palette.dark4 },
    TabLineFill = { fg = palette.dark4, bg = palette.dark1 },

    -- NOTE: Use similar highlight of StatusLine highlight for WinBar
    -- Color is affected by lspsaga.nvim
    WinBar = { fg = palette.light3, bg = palette.dark0 },
    WinBarNC = { fg = palette.light4, bg = palette.dark0 },

    -- LSP semantic highlighting
    -- Use gruvbox.nvim highlight

    -- Plugin
    FocusedSymbol = { fg = palette.faded_blue, bg = custom_palette.white_yellow },
    GitSignsCurrentLineBlame = { fg = palette.dark4 },
    -- TODO: Make nvim-ufo capture correct Folded highlight
    UfoFoldedFg = { fg = palette.gray },
    UfoFoldedBg = { bg = palette.dark1 },
  }

  require("gruvbox").setup({})
  vim.cmd([[colorscheme gruvbox]])

  local augroup_id = vim.api.nvim_create_augroup("gruvbox_settings", {})
  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      -- Manually override as using "overrides" settings will merge "overrides"
      -- with default highlight groups, and cause unwanted results
      for group, settings in pairs(overrides) do
        vim.api.nvim_set_hl(0, group, settings)
      end
    end,
  })
end

return gruvbox
