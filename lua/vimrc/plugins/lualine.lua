local check = require("vimrc.check")
local plugin_utils = require("vimrc.plugin_utils")

local gruvbox_dark_theme = require("vimrc.plugins.lualine_theme.gruvbox_dark")

local lualine = {}

lualine.default_refresh_interval = check.is_resource_limited() and 1000 or 100
lualine.inactive_refresh_interval = 60 * 1000

lualine.get_refresh_interval = function(interval)
  local new_interval = vim.F.if_nil(interval, lualine.default_refresh_interval)
  return {
    statusline = new_interval,
    tabline = check.is_resource_limited() and new_interval * 10 or new_interval,
    winbar = new_interval,
  }
end

lualine.custom_extensions = {
  outline = {
    sections = {
      lualine_a = { "filetype" },
    },
    filetypes = { "Outline" },
  },
}

lualine.default_option = {
  options = {
    icons_enabled = true,
    theme = gruvbox_dark_theme,
    disabled_filetypes = {},
    refresh = lualine.get_refresh_interval(),
  },

  -- Statusline
  sections = {
    lualine_a = { "mode" },
    lualine_b = vim.tbl_filter(function(component)
      return component ~= nil
    end, {
      plugin_utils.check_condition("branch", not check.is_resource_limited()),
      plugin_utils.check_condition("diff", not check.is_resource_limited()),
      { "diagnostics", sources = { "nvim_diagnostic" } },
    }),
    lualine_c = { { "filename", path = 1 } },
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

  -- Tabline
  tabline = {
    lualine_a = {
      {
        "tabs",
        max_length = math.floor(vim.o.columns * 2 / 3), -- Maximum width of tabs component.
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
        "windows",
        show_filename_only = true, -- Shows shortened relative path when set to false.
        show_modified_status = true, -- Shows indicator when the window is modified.

        mode = 0, -- 0: Shows window name
        -- 1: Shows window index
        -- 2: Shows window name + window index

        max_length = math.floor(vim.o.columns / 3), -- Maximum width of windows component,
        -- it can also be a function that returns
        -- the value of `max_length` dynamically.
        filetype_names = {
          TelescopePrompt = "Telescope",
          dashboard = "Dashboard",
          fzf = "FZF",
          alpha = "Alpha",
          fugitive = "Fugitive",
        }, -- Shows specific window name for that filetype ( { `filetype` = `window_name`, ... } )

        disabled_buftypes = { "quickfix", "prompt" }, -- Hide a window if its buffer's type is disabled

        -- windows_color = {
        --   -- Same values as the general color option can be used here.
        --   active = 'lualine_{section}_normal',     -- Color for active window.
        --   inactive = 'lualine_{section}_inactive', -- Color for inactive window.
        -- },
      },
    },
  },

  -- Winbar
  winbar = plugin_utils.check_enabled_plugin({
    lualine_a = {},
    lualine_b = {},
    lualine_c = vim.tbl_filter(function(component)
      return component ~= nil
    end, {
      { "filename", path = 1, color = "WinBar" },
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
  }, "lualine.nvim-winbar", {}),
  inactive_winbar = plugin_utils.check_enabled_plugin({
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1, color = "WinBarNC" } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  }, "lualine.nvim-winbar", {}),

  extensions = {
    -- builtin
    "fugitive",
    "fzf",
    "lazy",
    "man",
    "mason",
    "mundo",
    "nvim-dap-ui",
    "oil",
    "overseer",
    "quickfix",
    "trouble",

    -- custom
    lualine.custom_extensions.outline,
  },
}

lualine.setup_refresh_interval = function(interval)
  local new_interval = lualine.get_refresh_interval(interval)
  local new_config = vim.tbl_deep_extend("force", lualine.default_option, {
    options = {
      refresh = vim.tbl_extend(
        "force",
        {
          statusline = new_interval.statusline,
          tabline = new_interval.tabline,
        },
        plugin_utils.check_enabled_plugin({
          winbar = new_interval.winbar,
        }, "lualine.nvim-winbar", {})
      ),
    },
  })

  require("lualine").setup(new_config)
end

lualine.setup_performance_trick = function()
  -- Performance trick
  -- Ref: nvim_treesitter.lua performance trick
  -- TODO: Check if this cause empty lualine occasionally
  local augroup_id = vim.api.nvim_create_augroup("lualine_settings", {})
  vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      lualine.setup_refresh_interval()
    end,
  })
  -- TODO: Check if this cause weird tabline background color
  vim.api.nvim_create_autocmd({ "FocusLost", "VimSuspend" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      lualine.setup_refresh_interval(lualine.inactive_refresh_interval)
    end,
  })

  if check.is_resource_limited() then
    -- NOTE: Manually refresh tabline on TabEnter
    local tabline_refresh_enable = false
    local tabline_refresh_debounce = lualine.default_refresh_interval / 5
    vim.api.nvim_create_autocmd({ "TabEnter" }, {
      group = augroup_id,
      pattern = "*",
      callback = function()
        tabline_refresh_enable = true

        vim.defer_fn(function()
          if tabline_refresh_enable then
            require("lualine").refresh()
            tabline_refresh_enable = false
          end
        end, tabline_refresh_debounce)
      end,
    })
  end
end

lualine.setup = function()
  require("lualine").setup(lualine.default_option)

  lualine.setup_performance_trick()
end

return lualine
