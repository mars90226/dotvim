local plugin_utils = require("vimrc.plugin_utils")

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = vim.g.lualine_theme,
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_diagnostic", "coc" } } },
    lualine_c = vim.tbl_filter(function(component)
      return component ~= nil
    end, {
      { "filename", path = 1 },
      plugin_utils.check_condition({
        function()
          return require("nvim-gps").get_location()
        end,
        cond = function()
          return require("nvim-gps").is_available()
        end,
      }, vim.fn["vimrc#plugin#is_enabled_plugin"]("nvim-gps") == 1),
    }),
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = {
      "location",
      {
        -- NOTE: Need to wrap lua function in user function
        -- ref: https://github.com/nvim-lualine/lualine.nvim/issues/392
        function()
          return require("lsp-status").status()
        end,
        cond = function()
          return #vim.lsp.buf_get_clients() > 0
        end,
      },
    },
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
