local gruvbox = {}

gruvbox.config = {
  bold = true,
  error_inverse = true,
  inverse = true,
  transparent_mode = true,
  italic = {
    comments = true,
  }
}

gruvbox.load_overrides = function(overrides)
  -- Manually override as using "overrides" settings will merge "overrides"
  -- with default highlight groups, and cause unwanted results
  for group, settings in pairs(overrides) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

-- NOTE: Only support background=dark
gruvbox.custom_overrides = function()
  local hsl = require("lush").hsl
  local palette = require("gruvbox").palette

  local diff_percent = 20
  local custom_palette = {
    white_yellow = hsl(palette.bright_yellow).lighten(diff_percent * 2).hex,
    dark_red = hsl(palette.faded_red).darken(diff_percent).hex,
    dark_green = hsl(palette.faded_green).darken(diff_percent).hex,
    dark_yellow = hsl(palette.faded_yellow).darken(diff_percent).hex,
    dark_aqua = hsl(palette.faded_aqua).darken(diff_percent).hex,
  }
  local overrides = vim.tbl_extend("force", {
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
    MiniPickNormal = { link = "Normal" },

    -- Fix Vim's default highlight group linking
    -- Ref: https://github.com/neovim/neovim/issues/26378
    -- Ref: https://github.com/ellisonleao/gruvbox.nvim/issues/307
    ["@punctuation.bracket"] = { link = "Special" },
    ["@punctuation.delimiter"] = { link = "Special" },
    ["@punctuation.special"] = { link = "Special" },
  }, gruvbox.config.transparent_mode and {
    -- Fix for transparent mode
    OpaqueNormal = { fg = palette.light1, bg = palette.dark0 },
    OpaqueNormalFloat = { fg = palette.light1, bg = palette.dark1 },
    OpaqueTitle = { fg = palette.bright_green, bg = palette.dark0, bold = gruvbox.config.bold },
    OpaqueComment = { fg = palette.gray, bg = palette.dark0, italic = gruvbox.config.italic.comments },
    -- NOTE: Set background to nil. The 'cursorline' still has visual indication in line number
    -- column.
    CursorLine = { bg = nil },
    -- NOTE: Although `reverse` works, but it show the background color when switching to a new tab. So disabled it.
    StatusLine = { fg = palette.dark2, bg = nil, reverse = false },
    StatusLineNC = { fg = palette.dark1, bg = nil, reverse = false },
    WinBar = { fg = palette.light3, bg = nil },
    WinBarNC = { fg = palette.light4, bg = nil },

    -- NOTE: Link to OpaqueNormal to avoid warning message
    NotifyBackground = { link = "OpaqueNormal" },

    BqfPreviewFloat = { link = "OpaqueNormal" },
    BqfPreviewBorder = { link = "OpaqueNormalFloat" },
    BqfPreviewTitle = { link = "OpaqueTitle" },

    UfoFoldedBg = { bg = nil },

    -- nvim-treesitter-context
    TreesitterContextBottom = { underline = true, sp = palette.dark4 },
    TreesitterContextLineNumberBottom = { underline = true, sp = palette.dark4 },

    -- markview.nvim
    -- NOTE: gruvbox.nvim only provide 1 color in @markup.heading
    MarkviewPalette1 = { fg = palette.bright_red, bg = palette.dark1, bold = true },
    MarkviewPalette2 = { fg = palette.bright_orange, bg = palette.dark1, bold = true },
    MarkviewPalette3 = { fg = palette.bright_yellow, bg = palette.dark1, bold = true },
    MarkviewPalette4 = { fg = palette.bright_green, bg = palette.dark1, bold = true },
    MarkviewPalette5 = { fg = palette.bright_blue, bg = palette.dark1, bold = true },
    MarkviewPalette6 = { fg = palette.bright_aqua, bg = palette.dark1, bold = true },
    MarkviewPalette7 = { fg = palette.bright_purple, bg = palette.dark1, bold = true },
    MarkviewPalette1Fg = { fg = palette.bright_red },
    MarkviewPalette2Fg = { fg = palette.bright_orange },
    MarkviewPalette3Fg = { fg = palette.bright_yellow },
    MarkviewPalette4Fg = { fg = palette.bright_green },
    MarkviewPalette5Fg = { fg = palette.bright_blue },
    MarkviewPalette6Fg = { fg = palette.bright_aqua },
    MarkviewPalette7Fg = { fg = palette.bright_purple },
    MarkviewPalette1Bg = { bg = palette.dark1 },
    MarkviewPalette2Bg = { bg = palette.dark1 },
    MarkviewPalette3Bg = { bg = palette.dark1 },
    MarkviewPalette4Bg = { bg = palette.dark1 },
    MarkviewPalette5Bg = { bg = palette.dark1 },
    MarkviewPalette6Bg = { bg = palette.dark1 },
    MarkviewPalette7Bg = { bg = palette.dark1 },
    MarkviewPalette1Sign = { fg = palette.bright_red },
    MarkviewPalette2Sign = { fg = palette.bright_orange },
    MarkviewPalette3Sign = { fg = palette.bright_yellow },
    MarkviewPalette4Sign = { fg = palette.bright_green },
    MarkviewPalette5Sign = { fg = palette.bright_blue },
    MarkviewPalette6Sign = { fg = palette.bright_aqua },
    MarkviewPalette7Sign = { fg = palette.bright_purple },
  } or {})

  return overrides
end

gruvbox.toggle_error_inverse = function()
  gruvbox.config.error_inverse = not gruvbox.config.error_inverse

  local palette = require("gruvbox.palette").colors

  local overrides = {
    Error = { fg = palette.bright_red, bold = gruvbox.config.bold, reverse = gruvbox.config.error_inverse },
  }

  gruvbox.load_overrides(overrides)
end

gruvbox.reload = function()
  require("gruvbox").setup(gruvbox.config)
  require("gruvbox").load()
end

gruvbox.setup = function()
  require("gruvbox").setup(gruvbox.config)
  vim.cmd([[colorscheme gruvbox]])

  vim.api.nvim_create_user_command("ToggleErrorInverse", function()
    gruvbox.toggle_error_inverse()
  end, {})
  vim.keymap.set("n", "coi", "<Cmd>ToggleErrorInverse<CR>")

  local augroup_id = vim.api.nvim_create_augroup("gruvbox_settings", {})
  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      local custom_overrides = gruvbox.custom_overrides()
      gruvbox.load_overrides(custom_overrides)
    end,
  })
end

return gruvbox
