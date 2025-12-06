local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local completion = {
  -- Completion
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = vim.tbl_filter(function(plugin_spec)
      return plugin_spec ~= nil
    end, {
      -- Compatibility layer for nvim-cmp sources
      "saghen/blink.compat",
      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        cond = choose.is_enabled_plugin("LuaSnip"),
        version = false, -- NOTE: Use the latest version
        -- TODO: Check if it works on non-build env
        build = choose.is_enabled_plugin("LuaSnip-transform") and "make install_jsregexp" or "", -- optional
        config = function()
          require("vimrc.plugins.luasnip").setup()
        end,
      },
      -- Snippet collection
      "rafamadriz/friendly-snippets",
      -- Optional UI helpers
      "onsails/lspkind-nvim",
      "nvim-web-devicons",
      "xzbdmw/colorful-menu.nvim",

      -- Completion Sources (kept for compat layer)
      {
        "andersevenrud/cmp-tmux",
        cond = choose.is_enabled_plugin("cmp-tmux"),
      },
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        cond = choose.is_enabled_plugin("blink-cmp-dictionary"),
      },
      {
        "hrsh7th/cmp-calc",
        cond = choose.is_enabled_plugin("cmp-calc"),
      },
      {
        "ray-x/cmp-treesitter",
        cond = choose.is_enabled_plugin("nvim-treesitter") and choose.is_enabled_plugin("cmp-treesitter"),
      },
      {
        "petertriho/cmp-git",
        cond = choose.is_enabled_plugin("cmp-git"),
        config = function()
          require("cmp_git").setup()
        end,
      },
      {
        "moyiz/blink-emoji.nvim",
        cond = choose.is_enabled_plugin("blink-emoji.nvim"),
      },
      {
        "mikavilpas/blink-ripgrep.nvim",
        cond = choose.is_enabled_plugin("blink-ripgrep.nvim"),
        version = "*", -- use the latest stable version
      },
      {
        "fang2hou/blink-copilot",
        cond = choose.is_enabled_plugin("blink-copilot"),
      },
      {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        cond = choose.is_enabled_plugin("tailwindcss-colorizer-cmp.nvim"),
        -- Ref: nvim-lspconfig tailwindcss.lua
        ft = {
          -- html
          "aspnetcorerazor",
          "astro",
          "astro-markdown",
          "blade",
          "clojure",
          "django-html",
          "htmldjango",
          "edge",
          "eelixir", -- vim ft
          "elixir",
          "ejs",
          "erb",
          "eruby", -- vim ft
          "gohtml",
          "gohtmltmpl",
          "haml",
          "handlebars",
          "hbs",
          "html",
          "html-eex",
          "heex",
          "jade",
          "leaf",
          "liquid",
          "markdown",
          "mdx",
          "mustache",
          "njk",
          "nunjucks",
          "php",
          "razor",
          "slim",
          "twig",
          -- css
          "css",
          "less",
          "postcss",
          "sass",
          "scss",
          "stylus",
          "sugarss",
          -- js
          "javascript",
          "javascriptreact",
          "reason",
          "rescript",
          "typescript",
          "typescriptreact",
          -- mixed
          "vue",
          "svelte",
        },
        config = function()
          require("tailwindcss-colorizer-cmp").setup({
            color_square_width = 2,
          })
        end,
      },
    }),
    config = function()
      require("vimrc.plugins.blink_cmp").setup()
    end,
  },

  -- Snippets source
  {
    "rafamadriz/friendly-snippets",
    event = { "InsertEnter", "CmdlineEnter" },
  },

  -- Auto Pairs
  {
    "windwp/nvim-autopairs",
    cond = choose.is_enabled_plugin("nvim-autopairs"),
    event = { "InsertEnter" },
    config = function()
      local Rule = require("nvim-autopairs.rule")
      local npairs = require("nvim-autopairs")

      npairs.setup({
        check_ts = choose.is_enabled_plugin("nvim-treesitter"),
        fast_wrap = {},
      })

      -- Rules
      -- npairs.add_rule(Rule("%w<", ">", "cpp"):use_regex(true))
      -- npairs.add_rule(Rule("%w<", ">", "rust"):use_regex(true))
      npairs.add_rule(Rule("<", ">", "xml"))
    end,
  },

  -- NOTE: use 'abecodes/tabout.nvim'
  -- ref: https://github.com/windwp/nvim-autopairs/issues/167
  {
    "abecodes/tabout.nvim",
    cond = not utils.is_light_vim_mode() and choose.is_enabled_plugin("nvim-treesitter"),
    event = { "InsertEnter" },
    config = function()
      require("tabout").setup({
        tabkey = "<M-n>",           -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<M-N>", -- key to trigger backwards tabout, set to an empty string to disable
      })
    end,
  },
}

return completion
