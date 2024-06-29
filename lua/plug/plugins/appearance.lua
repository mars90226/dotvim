local choose = require("vimrc.choose")

local appearance = {
  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    config = function()
      require("vimrc.plugins.lualine").setup()

      vim.cmd([[command! FixLualineStatusline set statusline=%{%v:lua.require'lualine'.statusline()%}]])
    end,
  },

  -- Tabline
  -- NOTE: Use lualine.nvim tabline

  -- Winbar
  -- NOTE: Use lualine.nvim winbar
  {
    "Bekaboo/dropbar.nvim",
    cond = choose.is_enabled_plugin("dropbar.nvim") and choose.is_enabled_plugin("dropbar.nvim-winbar"),
    config = function()
      require("vimrc.plugins.dropbar").setup()
    end,
  },

  -- Statuscolumn
  {
    "luukvbaal/statuscol.nvim",
    cond = choose.is_enabled_plugin("statuscol.nvim"),
    branch = "0.10",
    config = function()
      require("vimrc.plugins.statuscol").setup()
    end,
  },

  -- Devicons
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "ryanoasis/vim-devicons", lazy = true },

  -- Colors
  { "rktjmp/lush.nvim", lazy = true },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 999,
    -- TODO: Remove after to avoid other plugin capture wrong highlight
    init = function()
      vim.g.colorscheme = "gruvbox"
      vim.g.lualine_theme = "auto"
    end,
    config = function()
      require("vimrc.plugins.gruvbox").setup()
    end,
  },

  -- Which key
  {
    "folke/which-key.nvim",
    event = { "VeryLazy" },
    config = function()
      vim.go.timeout = true
      vim.go.timeoutlen = 300
      require("which-key").setup({})
    end,
  },

  -- Dashboard
  -- Ref: [LazyVim's dashboard-nvim config](https://www.lazyvim.org/plugins/ui#dashboard-nvim)
  {
    "nvimdev/dashboard-nvim",
    lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
    opts = function()
      -- NOTE: Suffix whitespace to align with the center
      local logo = [[
          ███╗   ███╗ █████╗ ██████╗ ███████╗██╗   ██╗██╗███╗   ███╗        
          ████╗ ████║██╔══██╗██╔══██╗██╔════╝██║   ██║██║████╗ ████║        
          ██╔████╔██║███████║██████╔╝███████╗██║   ██║██║██╔████╔██║        
          ██║╚██╔╝██║██╔══██║██╔══██╗╚════██║╚██╗ ██╔╝██║██║╚██╔╝██║        
          ██║ ╚═╝ ██║██║  ██║██║  ██║███████║ ╚████╔╝ ██║██║ ╚═╝ ██║        
          ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝        
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = 'FzfLua files', desc = " Find File", icon = " ", key = "f" },
            { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
            { action = 'FzfLua oldfiles', desc = " Recent Files", icon = " ", key = "r" },
            { action = 'FzfLua live_grep_native', desc = " Find Text", icon = " ", key = "g" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- open dashboard after closing lazy
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end

      return opts
    end,
  },

  -- Scrollbar
  -- TODO: Try https://github.com/petertriho/nvim-scrollbar instead

  -- Notify
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- UI
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      -- Ref: https://github.com/LazyVim/LazyVim/blob/cbf1d335ed6a478a2e6144aa2d462a8330b2b0fc/lua/lazyvim/plugins/ui.lua
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  -- TODO: Add noice.nvim

  -- Indent Guide
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "VeryLazy" },
    config = function()
      require("vimrc.plugins.indent_blankline").setup()
    end,
  },
}

return appearance
