local gruvbox = {}

gruvbox.config = {
  bold = true,
  error_inverse = true,
}

gruvbox.load_overrides = function(overrides)
  -- Manually override as using "overrides" settings will merge "overrides"
  -- with default highlight groups, and cause unwanted results
  for group, settings in pairs(overrides) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

gruvbox.custom_overrides = function()
  local hsl = require("lush").hsl

  -- TODO: Think of a better way to avoid changes needed for future gruvbox.nvim update
  local dark_palette = require("gruvbox.palette").get_base_colors({}, "dark")
  local light_palette = require("gruvbox.palette").get_base_colors({}, "light")

  local diff_percent = 20
  -- NOTE: Assume background is dark
  local custom_palette = {
    white_yellow = hsl(dark_palette.yellow).lighten(diff_percent * 2).hex,
    dark_red = hsl(light_palette.red).darken(diff_percent).hex,
    dark_green = hsl(light_palette.green).darken(diff_percent).hex,
    dark_yellow = hsl(light_palette.yellow).darken(diff_percent).hex,
    dark_aqua = hsl(light_palette.aqua).darken(diff_percent).hex,
  }
  local overrides = {
    NormalFloat = { fg = dark_palette.fg1, bg = dark_palette.bg1 },
    TSOperator = { link = "Special" },

    -- NOTE: Only change background color
    DiffAdd = { fg = nil, bg = custom_palette.dark_green },
    DiffChange = { bg = custom_palette.dark_aqua },
    DiffDelete = { fg = dark_palette.bg0, bg = custom_palette.dark_red },
    DiffText = { bg = custom_palette.dark_yellow },

    -- NOTE: Avoid highlight link to avoid breaking tabby.nvim
    TabLine = { fg = dark_palette.bg1, bg = dark_palette.bg4 },
    TabLineFill = { fg = dark_palette.bg4, bg = dark_palette.bg1 },

    -- NOTE: Use similar highlight of StatusLine highlight for WinBar
    -- Color is affected by lspsaga.nvim
    WinBar = { fg = dark_palette.fg3, bg = dark_palette.bg0 },
    WinBarNC = { fg = dark_palette.fg4, bg = dark_palette.bg0 },

    -- LSP semantic highlighting
    -- Use gruvbox.nvim highlight

    -- Plugin
    FocusedSymbol = { fg = light_palette.blue, bg = custom_palette.white_yellow },
    GitSignsCurrentLineBlame = { fg = dark_palette.bg4 },
    -- TODO: Make nvim-ufo capture correct Folded highlight
    UfoFoldedFg = { fg = dark_palette.gray },
    UfoFoldedBg = { bg = dark_palette.bg1 },
  }

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
  nnoremap("coi", "<Cmd>ToggleErrorInverse<CR>")

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
