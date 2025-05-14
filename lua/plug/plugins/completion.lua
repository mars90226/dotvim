local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local completion = {
  -- Completion
  {
    -- TODO: Use 'iguanacucumber/magazine.nvim' instead of 'hrsh7th/nvim-cmp' for performance & bug
    -- fixes. Which also includes 'yioneko/nvim-cmp's performance improvements noteed in the following MR:
    -- Ref: https://github.com/hrsh7th/nvim-cmp/pull/1980
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp", -- Otherwise highlighting gets messed up
    dependencies = vim.tbl_filter(function(plugin_spec)
      return plugin_spec ~= nil
    end, {
      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        cond = choose.is_enabled_plugin("LuaSnip"),
        version = false, -- NOTE: Use the latest version
        -- TODO: Check if it works on non-build env
        build = choose.is_enabled_plugin("LuaSnip-transform") and "make install_jsregexp" or "", -- optional
        config = function()
          require("vimrc.plugins.luasnip").setup()

          -- NOTE: nvim-cmp doesn't show new snippets, but it actually reloaded
          -- FIXME: Fix ReloadLuaSnip
          -- vim.cmd([[command! ReloadLuaSnip call vimrc#source("after/plugin/luasnip.lua")]])
        end,
      },
      -- Formatting
      "onsails/lspkind-nvim",
      -- Completion Sources
      {
        "saadparwaiz1/cmp_luasnip",
        cond = choose.is_enabled_plugin("LuaSnip"),
      },
      { "hrsh7th/cmp-nvim-lsp" },
      {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        cond = choose.is_enabled_plugin("cmp-nvim-lsp-signature-help"),
      },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      {
        "andersevenrud/cmp-tmux",
        cond = choose.is_enabled_plugin("cmp-tmux"),
      },
      {
        "uga-rosa/cmp-dictionary",
        cond = choose.is_enabled_plugin("cmp-dictionary"),
        config = function()
          require("cmp_dictionary").setup({
            paths = { plugin_utils.get_dictionary() },
            exact_length = 5,
            first_case_insensitive = true,
            document = {
              enable = plugin_utils.is_executable("wn"),
              command = { "wn", "${label}", "-over" },
            },
          })
        end,
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
        "hrsh7th/cmp-emoji",
        cond = choose.is_enabled_plugin("cmp-emoji"),
      },
      {
        "lukas-reineke/cmp-rg",
        cond = choose.is_enabled_plugin("cmp-rg"),
      },
      { "hrsh7th/cmp-cmdline" },
      {
        "zbirenbaum/copilot-cmp",
        cond = choose.is_enabled_plugin("copilot-cmp"),
        config = function()
          require("copilot_cmp").setup()
        end,
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
          -- 'HTML (Eex)',
          -- 'HTML (EEx)',
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
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require("vimrc.plugins.nvim_cmp").setup()

      -- Setup lspconfig in mason.nvim config function
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

      -- nvim-cmp integration
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

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
