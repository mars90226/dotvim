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
    },
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
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  -- builtin tabline
  tabline = {
    lualine_a = {
      {
        "tabs",
        max_length = vim.o.columns * 2 / 3, -- Maximum width of tabs component.
                                            -- Note:
                                            -- It can also be a function that returns
                                            -- the value of `max_length` dynamically.
        mode = 2, -- 0: Shows tab_nr
                  -- 1: Shows tab_name
                  -- 2: Shows tab_nr + tab_name
        -- tabs_color = {
        --   -- Same values as the general color option can be used here.
        --   active = "TabLineSel", -- Color for active tab.
        --   inactive = "TabLine", -- Color for inactive tab.
        -- },
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {
        'windows',
        show_filename_only = true,   -- Shows shortened relative path when set to false.
        show_modified_status = true, -- Shows indicator when the window is modified.

        mode = 0, -- 0: Shows window name
                  -- 1: Shows window index
                  -- 2: Shows window name + window index

        max_length = vim.o.columns / 3, -- Maximum width of windows component,
                                        -- it can also be a function that returns
                                        -- the value of `max_length` dynamically.
        filetype_names = {
          TelescopePrompt = 'Telescope',
          dashboard = 'Dashboard',
          packer = 'Packer',
          fzf = 'FZF',
          alpha = 'Alpha'
        }, -- Shows specific window name for that filetype ( { `filetype` = `window_name`, ... } )

        disabled_buftypes = { 'quickfix', 'prompt' }, -- Hide a window if its buffer's type is disabled

        -- windows_color = {
        --   -- Same values as the general color option can be used here.
        --   active = 'lualine_{section}_normal',     -- Color for active window.
        --   inactive = 'lualine_{section}_inactive', -- Color for inactive window.
        -- },
      }
    },
  },

  -- barbar.nvim, tabby.nvim
  -- tabline = {},

  winbar = plugin_utils.check_enabled_plugin({
    lualine_a = {},
    lualine_b = {},
    lualine_c = vim.tbl_filter(function(component)
      return component ~= nil
    end, {
      { "filename", path = 1 },
      plugin_utils.check_enabled_plugin({
        function()
          return require("nvim-navic").get_location()
        end,
        cond = function()
          return require("nvim-navic").is_available()
        end,
      }, "nvim-navic"),
    }),
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  }, "lualine.nvim-winbar") or {},
  inactive_winbar = plugin_utils.check_condition({
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  }, "lualine.nvim-winbar") or {},

  extensions = {
    "fugitive",
    "fzf",
    "man",
    "mundo",
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
      },
    },
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
