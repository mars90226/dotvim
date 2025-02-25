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
      { "<Space>cL", [[<Cmd>CopilotForceEnable<CR>]], desc = "Copilot force enable" },
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
        -- NOTE: copilot.lua only enable for 'buflisted' buffer, so use `:set buflisted` to enable
        -- on non-'buflisted' buffers.
        -- NOTE: copilot.lua only enable for 'buftype' == "" buffer, so use `:set buflisted=""` to enable
        -- on special 'buftype' buffers.
        filetypes = {
          gitcommit = true,
          markdown = true,
          yaml = true,
        },
      })

      require("vimrc.plugins.copilot").setup()
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = choose.is_enabled_plugin("CopilotChat.nvim"),
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {
      show_help = "yes",
      debug = false,
      -- NOTE: When debug is needed, uncomment the following line and set the log_level to "trace"
      -- in CopilotChat.nvim because it's using default log level in plenary.nvim which is "debug".
      -- log_level = "trace",
      model = require("vimrc.plugins.copilot").default_model,
      chat_autocomplete = true, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)
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
      require("CopilotChat").setup(opts)
      require("vimrc.plugins.nvim_cmp").insert_luasnip_source_to_filetype("copilot-chat")
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
      { "<Leader>aa", mode = { "n", "v" },                             function() require("avante.api").ask() end,  desc = "avante: ask" },
      { "<Leader>ae", mode = { "v" },                                  function() require("avante.api").edit() end, desc = "avante: edit" },
      { "<Leader>ar", function() require("avante.api").refresh() end,  desc = "avante: refresh" },
      { "<Leader>ad", function() require("avante").toggle.debug() end, desc = "avante: toggle debug" },
      { "<Leader>ah", function() require("avante").toggle.hint() end,  desc = "avante: toggle hint" },
      { "<Leader>at", function() require("avante").toggle() end,       desc = "avante: toggle" },
    },
    opts = {
      provider = "copilot",
      -- TODO: Check if there's better way to choose one model and retaining all other models' info
      -- TODO: Merge with codecompanion.nvim's copilot config?
      -- TODO: Support o3-mini-high
      -- Ref: [feature support openai's reasoning_effort parameter · Issue 1252 · yetoneavante.nvim](https://github.com/yetone/avante.nvim/issues/1252)
      copilot = require("vimrc.plugins.copilot").get_model(),
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1" -- for windows
    dependencies = {
      -- Defined in file_explorer.lua
      -- "folke/snacks.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",      -- for providers='copilot'
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
      "CodeCompanionCmd",
      "CodeCompanionActions",
      "CodeCompanionChooseCopilotModels",
    },
    keys = {
      { "<Leader>cc",       mode = { "n", "v" },          "<Cmd>CodeCompanion<CR>",            silent = true,                desc = "CodeCompanion - Open" },
      { "<Leader>c<Space>", mode = { "n", "v" },          ":CodeCompanion<Space>",             desc = "CodeCompanion" },
      { "<Leader>ca",       mode = { "n", "v" },          "<Cmd>CodeCompanionActions<CR>",     silent = true,                desc = "CodeCompanion - Actions" },
      { "<Leader>cd",       "<Cmd>CodeCompanionChat<CR>", silent = true,                       desc = "CodeCompanion - Chat" },
      { "<Leader>c`",       mode = { "n", "v" },          "<Cmd>CodeCompanionChat Toggle<CR>", silent = true,                desc = "CodeCompanion - Toggle" },
      { "<Leader>cd",       mode = { "v" },               "<Cmd>CodeCompanionChat Add<CR>",    silent = true,                desc = "CodeCompanion - Add" },
      { "<Leader>c:",       mode = { "n" },               ":CodeCompanionCmd<Space>",          desc = "CodeCompanion - Cmd" },
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
        name = "nvim-cmp", -- Otherwise highlighting gets messed up
      },
      -- Defined in file_explorer.lua
      -- "folke/snacks.nvim", -- Optional: Improves the default Neovim UI
      -- TODO: Use snacks.nvim
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    },
    opts = {
      adapters = {
        copilot = function()
          -- NOTE: Need to use `require("codecompanion.adapters").extend()` to get `CodeCompanion.Adapter`.
          -- But it also means we have to merge the model configs, not just override it.
          local copilot_model = require("vimrc.plugins.codecompanion").get_copilot_model()
          return require("codecompanion.adapters").extend("copilot", copilot_model)
        end,
      },
      strategies = {
        chat = {
          adapter = "copilot",
          -- TODO: Refactor this to apply to all slash commands
          slash_commands = {
            ["file"] = {
              opts = {
                provider = "fzf_lua",
              },
            },
          }
        },
        inline = {
          adapter = "copilot",
        },
        agent = {
          adapter = "copilot",
        },
      },
      display = {
        chat = {
          -- TODO: Use render-markdown.nvim to render markdown in the chat buffer
          render_headers = false,
          show_settings = true,
        },
      },
      prompt_library = {
        ["Review"] = {
          strategy = "chat",
          description = "Review the code in a buffer",
          opts = {
            index = 5,
            is_slash_cmd = false,
            modes = { "v" },
            short_name = "explain",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "system",
              content = [[When asked to review code for readability and maintainability, follow these steps:

1. Identify the Programming Language
   - Recognize the language used in the provided code snippet and ensure that feedback aligns with its conventions.
2. Analyze Readability and Maintainability Issues

   - Examine the code for potential improvements related to:
     - Naming conventions that are unclear, misleading, or inconsistent with the language’s standards.
     - The presence of unnecessary comments or missing essential explanations.
     - Overly complex expressions that could be simplified.
     - High nesting levels that reduce code clarity.
     - Excessively long or cryptic variable and function names.
     - Inconsistent formatting, naming, or coding style.
     - Repetitive code patterns that could benefit from abstraction or optimization.

3. Provide Structured and Actionable Feedback

   - Each identified issue must be concise and directly address the problem.
   - Clearly indicate the specific line number(s) where the issue is found.
   - Provide a brief yet informative description of the problem.
   - Suggest a concrete improvement or correction.

4. Format Your Feedback As Follows:

   - For single-line issues:
     `line=<line_number>: <issue_description>`
   - For multi-line issues:
     `line=<start_line>-<end_line>: <issue_description>`
   - If multiple issues exist on the same line, separate them with a semicolon.

5. Example Feedback:

```
line=3: Variable 'x' is too generic; use a more descriptive name.
line=8: Expression is overly complex; consider breaking it into smaller steps.
line=10: Uses camel case, but snake case is standard in Lua.
line=11-15: Deep nesting reduces readability; consider refactoring.
```

6. If the Code is Well-Written:

- Confirm that the code is clear and follows best practices, without suggesting unnecessary changes.]],
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return string.format(
                  [[Please review this code from buffer %d:

  ```%s
  %s
  ```
  ]],
                  context.bufnr,
                  context.filetype,
                  code
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
      -- Uncomment when debugging
      -- log_level = "TRACE",
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
      require("vimrc.plugins.codecompanion").setup()
      require("vimrc.plugins.nvim_cmp").insert_luasnip_source_to_filetype("codecompanion")
    end,
  }
}

return completion
