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

    -- Plugin
    FocusedSymbol = { fg = palette.faded_blue, bg = custom_palette.white_yellow },
    GitSignsCurrentLineBlame = { fg = palette.dark4 },
    -- TODO: Make nvim-ufo capture correct Folded highlight
    UfoFoldedFg = { fg = palette.gray },
    UfoFoldedBg = { bg = palette.dark1 },

    -- Navic
    NavicIconsFile = { fg = palette.bright_blue, bg = "NONE" },
    NavicIconsModule = { fg = palette.bright_blue, bg = "NONE" },
    NavicIconsNamespace = { fg = palette.bright_blue, bg = "NONE" },
    NavicIconsPackage = { fg = palette.bright_blue, bg = "NONE" },
    NavicIconsClass = { fg = palette.bright_yellow, bg = "NONE" },
    NavicIconsMethod = { fg = palette.bright_blue, bg = "NONE" },
    NavicIconsProperty = { fg = palette.bright_green, bg = "NONE" },
    NavicIconsField = { fg = palette.bright_green, bg = "NONE" },
    NavicIconsConstructor = { fg = palette.bright_blue, bg = "NONE" },
    NavicIconsEnum = { fg = palette.bright_green, bg = "NONE" },
    NavicIconsInterface = { fg = palette.bright_yellow, bg = "NONE" },
    NavicIconsFunction = { fg = palette.bright_blue, bg = "NONE" },
    NavicIconsVariable = { fg = palette.bright_purple, bg = "NONE" },
    NavicIconsConstant = { fg = palette.bright_orange, bg = "NONE" },
    NavicIconsString = { fg = palette.bright_green, bg = "NONE" },
    NavicIconsNumber = { fg = palette.bright_orange, bg = "NONE" },
    NavicIconsBoolean = { fg = palette.bright_orange, bg = "NONE" },
    NavicIconsArray = { fg = palette.bright_orange, bg = "NONE" },
    NavicIconsObject = { fg = palette.bright_orange, bg = "NONE" },
    NavicIconsKey = { fg = palette.neutral_purple, bg = "NONE" },
    NavicIconsNull = { fg = palette.bright_orange, bg = "NONE" },
    NavicIconsEnumMember = { fg = palette.neutral_red, bg = "NONE" },
    NavicIconsStruct = { fg = palette.bright_blue, bg = "NONE" },
    NavicIconsEvent = { fg = palette.bright_blue, bg = "NONE" },
    NavicIconsOperator = { fg = palette.neutral_blue, bg = "NONE" },
    NavicIconsTypeParameter = { fg = palette.bright_blue, bg = "NONE" },
    NavicText = { fg = palette.bright_blue, bg = "NONE" },
    NavicSeparator = { fg = palette.gray, bg = "NONE" },
  }

  require("gruvbox").setup({})
  vim.cmd([[colorscheme gruvbox]])

  -- Manually override as using "overrides" settings will merge "overrides"
  -- with default highlight groups, and cause unwanted results
  for group, settings in pairs(overrides) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

return gruvbox
