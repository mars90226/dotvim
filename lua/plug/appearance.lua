local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")

local appearance = {}

appearance.startup = function(use)
  local use_config = function(plugin_spec)
    plugin_utils.use_config(use, plugin_spec)
  end

  -- Status Line
  use({
    "nvim-lualine/lualine.nvim",
    config = function()
      require("vimrc.plugins.lualine").setup()

      vim.cmd([[command! FixLualineStatusline set statusline=%{%v:lua.require'lualine'.statusline()%}]])
    end,
  })

  -- Tabline
  -- NOTE: Use lualine.nvim tabline

  -- Sidebar
  use({
    "sidebar-nvim/sidebar.nvim",
    cmd = { "SidebarNvimToggle", "SidebarNvimOpen" },
    keys = { "<F5>", "<Space><F5>" },
    config = function()
      local utils = require("vimrc.utils")
      local sidebar = require("sidebar-nvim")
      sidebar.setup({
        sections = {
          "datetime",
          "git",
          "diagnostics",
          "todos",
          "symbols",
          "files",
        },
        todos = {
          icon = "",
          ignored_paths = utils.table_concat({ "~" }, vim.g.sidebar_nvim_todo_secret_ignored_paths or {}), -- ignore certain paths, this will prevent huge folders like $HOME to hog Neovim with TODO searching
          initially_closed = true, -- whether the groups should be initially closed on start. You can manually open/close groups later.
        },
      })

      nnoremap("<F5>", "<Cmd>:SidebarNvimToggle<CR>")
      nnoremap("<Space><F5>", "<Cmd>:SidebarNvimFocus<CR>")
    end,
  })

  -- Winbar
  use_config({
    "mars90226/winbar",
    disable = choose.is_disabled_plugin("winbar"),
    config = function()
      -- TODO: Disable winbar in plugin window
      -- NOTE: Currently, it's not possible to hide winbar based on 'winbar' evaluated result
      -- Thus, we can only rely on autocmd to enable/disable winbar locally.
      -- So, we move the winbar enable logic to lsp on_attach.
      -- Ref: https://github.com/neovim/neovim/issues/18660
      -- vim.go.winbar = [[%{v:lua.require('vimrc.winbar').winbar()}]]

      require("vimrc.winbar").setup()
    end,
  })

  -- Statuscolumn
  if choose.is_enabled_plugin("statuscol.nvim") then
    use({
      "luukvbaal/statuscol.nvim",
      config = function()
        local builtin = require("statuscol.builtin")

        require("statuscol").setup({
          segments = {
            -- Default segments (fold -> sign -> line number -> separator)
            { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
            { text = { "%s" }, click = "v:lua.ScSa" },
            {
              text = { builtin.lnumfunc, " " },
              condition = { true, builtin.not_empty },
              click = "v:lua.ScLa",
            },
          },
        })
      end,
    })
  end

  -- Signcolumn
  use_config({
    "mars90226/signcolumn",
    config = function()
      local signcolumn_settings_augroup_id = vim.api.nvim_create_augroup("signcolumn_settings", {})
      vim.api.nvim_create_autocmd({ "WinNew" }, {
        group = signcolumn_settings_augroup_id,
        pattern = "*",
        callback = function()
          -- NOTE: Reset signcolumn to "auto" to avoid inheriting winbar setting from other window
          vim.wo.signcolumn = "auto"
        end,
      })
    end,
  })

  -- Devicons
  use({ "kyazdani42/nvim-web-devicons", module = "nvim-web-devicons" })

  -- Colors
  use({ "rktjmp/lush.nvim" })
  use({
    "ellisonleao/gruvbox.nvim",
    -- TODO: Remove after to avoid other plugin capture wrong highlight
    -- after = "syntax",
    config = function()
      require("vimrc.plugins.gruvbox").setup()
    end,
  })
  -- NOTE: Setup colorscheme in gruvbox.nvim config
  -- vim.g.colorscheme = "gruvbox"
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
  -- TODO: Try https://github.com/petertriho/nvim-scrollbar instead

  -- Notify
  use({
    "rcarriga/nvim-notify",
    -- TODO: Disabled as it cause other plugins slow?
    disable = true,
    config = function()
      vim.notify = require("notify")
    end,
  })

  -- UI
  -- TODO: Move nui.nvim here
  use({ "stevearc/dressing.nvim" })
end

return appearance
