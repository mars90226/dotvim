local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")

local completion = {
  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = vim.tbl_filter(function(plugin_spec)
      return plugin_spec ~= nil
    end, {
      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
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
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "andersevenrud/cmp-tmux" },
      {
        "uga-rosa/cmp-dictionary",
        config = function()
          require("cmp_dictionary").setup({
            paths = { "/usr/share/dict/words" },
            exact_length = 2,
            first_case_insensitive = true,
            document = {
              enable = plugin_utils.is_executable("wn"),
              command = { "wn", "${label}", "-over" },
            },
          })
        end,
      },
      { "hrsh7th/cmp-calc" },
      plugin_utils.check_enabled_plugin({ "ray-x/cmp-treesitter" }, "nvim-treesitter"),
      {
        "petertriho/cmp-git",
        config = function()
          require("cmp_git").setup()
        end,
      },
      { "hrsh7th/cmp-emoji" },
      plugin_utils.check_executable({ "lukas-reineke/cmp-rg" }, "rg"),
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
        -- Ref: nvim-lspconfig tailwindcss.lua
        ft = {
          -- html
          'aspnetcorerazor',
          'astro',
          'astro-markdown',
          'blade',
          'clojure',
          'django-html',
          'htmldjango',
          'edge',
          'eelixir', -- vim ft
          'elixir',
          'ejs',
          'erb',
          'eruby', -- vim ft
          'gohtml',
          'gohtmltmpl',
          'haml',
          'handlebars',
          'hbs',
          'html',
          -- 'HTML (Eex)',
          -- 'HTML (EEx)',
          'html-eex',
          'heex',
          'jade',
          'leaf',
          'liquid',
          'markdown',
          'mdx',
          'mustache',
          'njk',
          'nunjucks',
          'php',
          'razor',
          'slim',
          'twig',
          -- css
          'css',
          'less',
          'postcss',
          'sass',
          'scss',
          'stylus',
          'sugarss',
          -- js
          'javascript',
          'javascriptreact',
          'reason',
          'rescript',
          'typescript',
          'typescriptreact',
          -- mixed
          'vue',
          'svelte',
        },
        config = function()
          require("tailwindcss-colorizer-cmp").setup({
            color_square_width = 2,
          })
        end
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
    event = { "InsertEnter", "CmdlineEnter" },
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
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require("tabout").setup({
        tabkey = "<M-n>", -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<M-N>", -- key to trigger backwards tabout, set to an empty string to disable
      })
    end,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cond = choose.is_enabled_plugin("copilot.lua"),
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          auto_refresh = true,
          keymap = {
            accept = "<M-CR>",
          },
        },
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<M-l>",
          }
        },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = choose.is_enabled_plugin("CopilotChat.nvim"),
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      show_help = "yes",
      debug = false,
      prompts = {
        Explain = "Explain how it works.",
        Review = "Review the following code and provide concise suggestions.",
        Tests = "Briefly explain how the selected code works, then generate unit tests.",
        Refactor = "Refactor the code to improve clarity and readability.",
        Wording = "Rewrite this using idiomatic English",
      },
    },
    event = "VeryLazy",
    -- TODO: Add new key mappings for the new CopilotChat features
    keys = {
      { "<Space>c<Space>", ":CopilotChat<Space>", mode = { "n", "x" }, desc = "CopilotChat - Open in vertical split" },
      { "<Space>cf", "<Cmd>CopilotChatFixDiagnostic<CR>", desc = "CopilotChat - Fix diagnostic" },
      { "<Space>c<C-R>", "<Cmd>CopilotChatReset<CR>", desc = "CopilotChat - Reset chat history and clear buffer" },
      { "<Space>cT", "<Cmd>CopilotChatVisplitToggle<CR>", desc = "CopilotChat - Toggle Vsplit" },

      -- Telescope integration
      {
        "<Space>ch",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions"
      },
      {
        "<Space>cp",
        function()
          local actions = require("CopilotChat.actions")
          local select = require("CopilotChat.select")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions({
            selection = select.visual,
          }))
        end,
        mode = { "n", "x" },
        desc = "CopilotChat - Prompt actions"
      },

      -- Prompts
      { "<Space>ce", "<Cmd>CopilotChatExplain<CR>", desc = "CopilotChat - Explain code" },
      { "<Space>ce", "y<Cmd>CopilotChatExplain<CR>", mode = { "x" }, desc = "CopilotChat - Explain code" },
      { "<Space>ct", "<Cmd>CopilotChatTests<CR>", desc = "CopilotChat - Generate tests" },
      { "<Space>ct", "y<Cmd>CopilotChatTests<CR>", mode = { "x" }, desc = "CopilotChat - Generate tests" },
      { "<Space>cr", "<Cmd>CopilotChatReview<CR>", desc = "CopilotChat - Review code" },
      { "<Space>cr", "y<Cmd>CopilotChatReview<CR>", mode = { "x" }, desc = "CopilotChat - Review code" },
      { "<Space>cR", "<Cmd>CopilotChatRefactor<CR>", desc = "CopilotChat - Refactor code" },
      { "<Space>cR", "y<Cmd>CopilotChatRefactor<CR>", mode = { "x" }, desc = "CopilotChat - Refactor code" },
      { "<Space>cW", "<Cmd>CopilotChatWording<CR>", desc = "CopilotChat - Improve wording" },
      { "<Space>cW", "y<Cmd>CopilotChatWording<CR>", mode = { "x" }, desc = "CopilotChat - Improve wording" },
    },
  },
}

return completion
