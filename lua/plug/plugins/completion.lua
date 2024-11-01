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
      {
        "saadparwaiz1/cmp_luasnip",
        cond = choose.is_enabled_plugin("LuaSnip"),
      },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
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
      { "hrsh7th/cmp-emoji" },
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

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cond = choose.is_enabled_plugin("copilot.lua"),
    cmd = { "Copilot" },
    event = { "InsertEnter" },
    keys = {
      { "<Space>c;", [[:Copilot<Space>]],         desc = "Copilot" },
      { "<Space>cl", [[<Cmd>Copilot enable<CR>]], desc = "Copilot enable" },
    },
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
            accept_word = "<C-Right>",
            accept_line = "<C-Down>",
            next = "<M-j>",
            prev = "<M-k>",
          },
        },
        filetypes = {
          gitcommit = true,
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
    build = "make tiktoken",
    opts = {
      show_help = "yes",
      debug = false,
      -- model = "gpt-4o-2024-08-06",
      -- TODO: Evaluate the o1-mini model
      model = "o1-mini-2024-09-12",
      -- TODO: Enable this when policy settings allows it
      -- `Failed to get response: {"error":{"message":"model access is not permitted per policy settings","param":"","code":"","type":""}}`
      -- model = "claude-3.5-sonnet",
      prompts = {
        Wording = "Rewrite this using idiomatic English",
      },
      mappings = {
        complete = {
          insert = "",
        },
        reset = {
          normal = "<Space><C-L>",
          insert = "",
        },
      },
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatToggle",
      "CopilotChatModels",
      "CopilotChatModel",

      -- TODO: Add CopilotChat default prompts commands
    },
    keys = {
      {
        "<Space>c<Space>",
        ":CopilotChat<Space>",
        mode = { "n", "x" },
        desc = "CopilotChat - Open in vertical split",
      },
      { "<Space>c<C-R>", "<Cmd>CopilotChatReset<CR>",  desc = "CopilotChat - Reset chat history and clear buffer" },
      { "<Space>c`",     "<Cmd>CopilotChatToggle<CR>", desc = "CopilotChat - Toggle" },
      { "<Space>cs",     "<Cmd>CopilotChatStop<CR>",   desc = "CopilotChat - Stop current copilot output" },

      -- Telescope integration
      {
        "<Space>ch",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions",
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
        desc = "CopilotChat - Prompt actions",
      },

      -- Default Prompts
      { "<Space>ce", "<Cmd>CopilotChatExplain<CR>",       mode = { "n", "x" }, desc = "CopilotChat - Explain code" },
      { "<Space>cr", "<Cmd>CopilotChatReview<CR>",        mode = { "n", "x" }, desc = "CopilotChat - Review code" },
      { "<Space>cf", "<Cmd>CopilotChatExplain<CR>",       mode = { "n", "x" }, desc = "CopilotChat - Fix code" },
      { "<Space>co", "<Cmd>CopilotChatOptimize<CR>",      mode = { "n", "x" }, desc = "CopilotChat - Optimize code" },
      { "<Space>cd", "<Cmd>CopilotChatDocs<CR>",          mode = { "n", "x" }, desc = "CopilotChat - Document code" },
      { "<Space>ct", "<Cmd>CopilotChatTests<CR>",         mode = { "n", "x" }, desc = "CopilotChat - Generate tests" },
      { "<Space>cF", "<Cmd>CopilotChatFixDiagnostic<CR>", mode = { "n", "x" }, desc = "CopilotChat - Fix diagnostic" },
      {
        "<Space>cc",
        "<Cmd>CopilotChatCommit<CR>",
        mode = { "n", "x" },
        desc = "CopilotChat - Write commit message for the change",
      },
      {
        "<Space>cC",
        "<Cmd>CopilotChatCommitStaged<CR>",
        mode = { "n", "x" },
        desc = "CopilotChat - Write commit message for the change in staged",
      },

      -- Custom Prompts
      { "<Space>cW", "<Cmd>CopilotChatWording<CR>", mode = { "n", "x" }, desc = "CopilotChat - Improve wording" },

      -- Integration
      {
        "<Space>ch",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions",
      },
      {
        "<Space>cp",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Help actions",
      },
    },
    config = function(_, opts)
      require("CopilotChat.integrations.cmp").setup()
      require("CopilotChat").setup(opts)
    end,
  },

  -- AI
  {
    "yetone/avante.nvim",
    cond = choose.is_enabled_plugin("avante.nvim"),
    -- event = "VeryLazy",
    lazy = true,
    version = false, -- set this if you want to always pull the latest change
    cmd = {
      "AvanteAsk",
      "AvanteEdit",
      "AvanteBuild",
      "AvanteClear",
      "AvanteToggle",
      "AvanteRefresh",
      "AvanteSwitchProvider",
    },
    keys = {
      { "<Leader>aa", mode = { "n", "v" }, function() require("avante.api").ask() end, desc = "avante: ask" },
      { "<Leader>ae", mode = { "v" }, function() require("avante.api").edit() end, desc = "avante: edit" },
      { "<Leader>ar", function() require("avante.api").refresh() end, desc = "avante: refresh" },
      { "<Leader>ad", function() require("avante").toggle.debug() end, desc = "avante: toggle debug" },
      { "<Leader>ah", function() require("avante").toggle.hint() end, desc = "avante: toggle hint" },
      { "<Leader>at", function() require("avante").toggle() end, desc = "avante: toggle" },
    },
    opts = {
      provider = "copilot",
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",    -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      -- Defined in languages.lua
      -- "OXY2DEV/markview.nvim",
    },
  },
  {
    "olimorris/codecompanion.nvim",
    cond = choose.is_enabled_plugin("codecompanion.nvim"),
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionActions",
    },
    keys = {
      { "<Leader>cc", mode = { "n", "v" }, "<Cmd>CodeCompanion<CR>", silent = true, desc = "CodeCompanion - Open" },
      { "<Leader>c;", mode = { "n", "v" }, ":CodeCompanion<Space>", desc = "CodeCompanion" },
      { "<Leader>ca", mode = { "n", "v" }, "<Cmd>CodeCompanionActions<CR>", silent = true, desc = "CodeCompanion - Actions" },
      { "<Leader>cd", "<Cmd>CodeCompanionChat<CR>", silent = true, desc = "CodeCompanion - Chat" },
      { "<Leader>c`", mode = { "n", "v" }, "<Cmd>CodeCompanionChat Toggle<CR>", silent = true, desc = "CodeCompanion - Toggle" },
      { "<Leader>cd", mode = { "v" }, "<Cmd>CodeCompanionChat Add<CR>", silent = true, desc = "CodeCompanion - Add" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter", -- TODO: Check nvim-treesitter enabled?
      -- Optional: For using slash commands and variables in the chat buffer
      {
        -- TODO: Use 'iguanacucumber/magazine.nvim' instead of 'hrsh7th/nvim-cmp' for performance & bug
        -- fixes. Which also includes 'yioneko/nvim-cmp's performance improvements noteed in the following MR:
        -- Ref: https://github.com/hrsh7th/nvim-cmp/pull/1980
        "iguanacucumber/magazine.nvim",
        name = "nvim-cmp",     -- Otherwise highlighting gets messed up
      },
      {
        "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
        opts = {},
      },
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    },
    opts = {
      -- TODO: Seems not supporting o1 models yet
      -- `Error: Bad Request`
      -- adapters = {
      --   copilot = function()
      --     return require("codecompanion.adapters").extend("copilot", {
      --       schema = {
      --         model = {
      --           default = "o1-mini-2024-09-12",
      --         },
      --       },
      --     })
      --   end,
      -- },
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
        agent = {
          adapter = "copilot",
        },
      },
    },
    config = true
  }
}

return completion
