local plugin_utils = require("vimrc.plugin_utils")

local lualine = {}

lualine.default_option = {
  options = {
    icons_enabled = true,
    theme = vim.g.lualine_theme,
    disabled_filetypes = {},
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_diagnostic" } } },
    lualine_c = vim.tbl_filter(function(component)
      return component ~= nil
    end, {
      { "filename", path = 1 },
      plugin_utils.check_enabled_plugin({
        function()
          return require("nvim-gps").get_location()
        end,
        cond = function()
          return require("nvim-gps").is_available()
        end,
      }, "nvim-gps"),
    }),
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
  extensions = {
    "fugitive",
    "fzf",
    "man",
    "neo-tree",
    "quickfix",
    "symbols-outline",
  },
}

lualine.setup_refresh_interval = function(interval)
  local new_interval = vim.F.if_nil(interval, 1000)
  local new_config = vim.tbl_deep_extend("force", lualine.default_option, {
    options = {
      refresh = {
        statusline = new_interval,
        tabline = new_interval,
        winbar = new_interval,
      }
    }
  })

  require("lualine").setup(new_config)
end

lualine.setup_performance_trick = function()
  -- Performance trick
  -- Ref: nvim_treesitter.lua performance trick
  local augroup_id = vim.api.nvim_create_augroup("lualine_settings", {})
  vim.api.nvim_create_autocmd({ "FocusGained" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      lualine.setup_refresh_interval()
    end,
  })
  vim.api.nvim_create_autocmd({ "FocusLost" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      lualine.setup_refresh_interval(60 * 1000)
    end,
  })
end

lualine.setup = function()
  require("lualine").setup(lualine.default_option)

  lualine.setup_performance_trick()
end

return lualine
