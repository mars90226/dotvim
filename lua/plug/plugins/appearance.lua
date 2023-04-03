local choose = require("vimrc.choose")

local appearance = {
  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("vimrc.plugins.lualine").setup()

      vim.cmd([[command! FixLualineStatusline set statusline=%{%v:lua.require'lualine'.statusline()%}]])
    end,
  },

  -- Tabline
  -- NOTE: Use lualine.nvim tabline

  -- Sidebar
  {
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
  },

  -- Winbar
  -- NOTE: Use lualine.nvim winbar

  -- Statuscolumn
  {
    "luukvbaal/statuscol.nvim",
    cond = choose.is_enabled_plugin("statuscol.nvim"),
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
  },

  -- Devicons
    { "kyazdani42/nvim-web-devicons" },

  -- Colors
  { "rktjmp/lush.nvim" },
  {
    "ellisonleao/gruvbox.nvim",
    -- TODO: Remove after to avoid other plugin capture wrong highlight
    init = function()
      vim.g.lualine_theme = "auto"
    end,
    config = function()
      require("vimrc.plugins.gruvbox").setup()
    end,
  },
  -- NOTE: Setup colorscheme in gruvbox.nvim config
  -- vim.g.colorscheme = "gruvbox"
  -- vim.g.lualine_theme = "auto"

  -- TODO: Disabled as diagnostic & vertical line highlight missing
  -- {
  --   "luisiacc/gruvbox-baby",
  --   branch = "main",
  -- }
  -- vim.g.colorscheme = "gruvbox-baby"
  -- vim.g.lualine_theme = "gruvbox-baby"

  -- TODO: Fix cterm 16 colors in terminal
  -- {
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
  -- }
  -- -- TODO: Avoid double loading & use correcty style
  -- vim.g.colorscheme = "onedark"
  -- vim.g.lualine_theme = "onedark"

  -- "marko-cerovac/material.nvim"
  -- vim.g.material_style = "darker"
  -- vim.g.colorscheme = "material"
  -- vim.g.lualine_theme = "material-nvim"

  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   config = function()
  --     require("catppuccin").setup()
  --   end,
  -- }
  -- vim.g.colorscheme = "catppuccin"
  -- vim.g.lualine_theme = "catppuccin"

  -- Which key
    {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup({})

        vim.go.timeoutlen = 500
      end,
    },

  -- Dashboard
  {
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
  },

  -- Scrollbar
  -- TODO: Try https://github.com/petertriho/nvim-scrollbar instead

  -- Notify
  {
    "rcarriga/nvim-notify",
    -- TODO: Disabled as it cause other plugins slow?
    enabled = false,
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- UI
  -- TODO: Move nui.nvim here
  { "stevearc/dressing.nvim" },
}

return appearance
