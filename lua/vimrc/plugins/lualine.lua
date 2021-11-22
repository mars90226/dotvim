require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_lsp", "coc" } } },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  -- builtin tabline
  -- tabline = {
  --   lualine_a = {},
  --   lualine_b = {},
  --   lualine_c = {
  --     {
  --       'tabs',
  --       max_length = vim.o.columns,
  --       mode = 2,
  --       tabs_color = {
  --         -- bg = GruvboxFg2, bg = GruvboxBg2
  --         active = {fg = '#D4C3A0', bg = '#4F4945'},
  --       }
  --     }
  --   },
  --   lualine_x = {},
  --   lualine_y = {},
  --   lualine_z = {}
  -- },

  -- tabline.nvim
  -- tabline = {
  --   lualine_a = {},
  --   lualine_b = {},
  --   lualine_c = { require'tabline'.tabline_buffers },
  --   lualine_x = { require'tabline'.tabline_tabs },
  --   lualine_y = {},
  --   lualine_z = {},
  -- },

  -- barbar.nvim, luatab.nvim, tabby.nvim
  tabline = {},
  extensions = { "fugitive", "fzf", "quickfix" },
})
