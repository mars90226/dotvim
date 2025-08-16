local choose = require("vimrc.choose")

local ai = {
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
        copilot_model = "gpt-4o-copilot",
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
      providers = {
        github_models = {
          disabled = false
        }
      }
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
      { "<Leader>a`", function() require("avante").toggle() end,       desc = "avante: toggle" },
    },
    opts = {
      provider = "copilot",
      providers = {
        copilot = require("vimrc.plugins.avante").get_copilot_model(),
      },
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
      -- Optional: For using tools from the MCP Servers
      {
        "ravitemer/mcphub.nvim",
        cond = choose.is_enabled_plugin("mcphub.nvim"),
      },
      "ravitemer/codecompanion-history.nvim",
    },
    opts = {
      adapters = {
        copilot = function()
          -- NOTE: Need to use `require("codecompanion.adapters").extend()` to get `CodeCompanion.Adapter`.
          -- But it also means we have to merge the model configs, not just override it.
          local copilot_model = require("vimrc.plugins.codecompanion").get_copilot_model()
          return require("codecompanion.adapters").extend("copilot", copilot_model)
        end,
        githubmodels = function()
          -- NOTE: Need to use `require("codecompanion.adapters").extend()` to get `CodeCompanion.Adapter`.
          -- But it also means we have to merge the model configs, not just override it.
          local github_model = require("vimrc.plugins.codecompanion").get_github_model()
          return require("codecompanion.adapters").extend("githubmodels", github_model)
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
          },
          tools = {},
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
          -- NOTE: Set show_settings = false to allow changing adapter
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
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
        vectorcode = {
          ---@type VectorCode.CodeCompanion.ExtensionOpts
          opts = {
            tool_group = {
              -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
              enabled = true,
              -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
              -- if you use @vectorcode_vectorise, it'll be very handy to include
              -- `file_search` here.
              extras = {},
              collapse = false, -- whether the individual tools should be shown in the chat
            },
            tool_opts = {
              ---@type VectorCode.CodeCompanion.ToolOpts
              ["*"] = {},
              ---@type VectorCode.CodeCompanion.LsToolOpts
              ls = {},
              ---@type VectorCode.CodeCompanion.VectoriseToolOpts
              vectorise = {},
              ---@type VectorCode.CodeCompanion.QueryToolOpts
              query = {
                max_num = { chunk = -1, document = -1 },
                default_num = { chunk = 50, document = 10 },
                include_stderr = false,
                use_lsp = false,
                no_duplicate = true,
                chunk_mode = false,
                ---@type VectorCode.CodeCompanion.SummariseOpts
                summarise = {
                  ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
                  enabled = false,
                  adapter = nil,
                  query_augmented = true,
                }
              },
              files_ls = {},
              files_rm = {}
            }
          },
        },
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "sc",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = true,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 0,
            -- Picker interface (auto resolved to a valid picker)
            picker = "telescope",     --- ("telescope", "snacks", "fzf-lua", or "default")
            ---Optional filter function to control which chats are shown when browsing
            chat_filter = nil,        -- function(chat_data) return boolean end
            -- Customize picker keymaps (optional)
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
              duplicate = { n = "<C-y>", i = "<C-y>" },
            },
            ---Automatically generate titles for new chats
            auto_generate_title = true,
            title_generation_opts = {
              ---Adapter for generating titles (defaults to current chat adapter)
              adapter = nil,                     -- "copilot"
              ---Model for generating titles (defaults to current chat model)
              model = nil,                       -- "gpt-4o"
              ---Number of user prompts after which to refresh the title (0 to disable)
              refresh_every_n_prompts = 0,       -- e.g., 3 to refresh after every 3rd user prompt
              ---Maximum number of times to refresh the title (default: 3)
              max_refreshes = 3,
              format_title = function(original_title)
                -- this can be a custom function that applies some custom
                -- formatting to the title.
                return original_title
              end
            },
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,

            -- Summary system
            summary = {
              -- Keymap to generate summary for current chat (default: "gcs")
              create_summary_keymap = "gcs",
              -- Keymap to browse summaries (default: "gbs")
              browse_summaries_keymap = "gbs",

              generation_opts = {
                adapter = nil,                       -- defaults to current chat adapter
                model = nil,                         -- defaults to current chat model
                context_size = 90000,                -- max tokens that the model supports
                include_references = true,           -- include slash command content
                include_tool_outputs = true,         -- include tool execution results
                system_prompt = nil,                 -- custom system prompt (string or function)
                format_summary = nil,                -- custom function to format generated summary e.g to remove <think/> tags from summary
              },
            },

            -- Memory system (requires VectorCode CLI)
            memory = {
              -- Automatically index summaries when they are generated
              auto_create_memories_on_summary_generation = true,
              -- Path to the VectorCode executable
              vectorcode_exe = "vectorcode",
              -- Tool configuration
              tool_opts = {
                -- Default number of memories to retrieve
                default_num = 10
              },
              -- Enable notifications for indexing progress
              notify = true,
              -- Index all existing memories on startup
              -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
              index_on_startup = false,
            },
          }
        }
      },
      -- Uncomment when debugging
      -- log_level = "TRACE",
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
      require("vimrc.plugins.codecompanion").setup()
      require("vimrc.plugins.nvim_cmp").insert_luasnip_source_to_filetype("codecompanion")
    end,
  },

  -- MCP
  {
    "ravitemer/mcphub.nvim",
    cond = choose.is_enabled_plugin("mcphub.nvim"),
    dependencies = {
      "nvim-lua/plenary.nvim",  -- Required for Job and HTTP requests
    },
    cmd = "MCPHub", -- lazily start the hub when `MCPHub` is called
    -- NOTE: Use `pnpm` to install in user's home directory to avoid permission issues
    build = "pnpm add -g mcp-hub@latest", -- Installs required mcp-hub npm module
    config = function()
      -- NOTE: Cannot install MCP servers in WSL for now
      require("mcphub").setup({
        -- Required options
        port = 9527,  -- Port for MCP Hub server
        config = vim.fn.expand("~/.config/mcphub/servers.json"),  -- Absolute path to config file
      })
    end
  },

  -- Index
  {
    "Davidyz/VectorCode",
    cond = choose.is_enabled_plugin("VectorCode"),
    version = "*",
    build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
    -- build = "pipx upgrade vectorcode", -- If you used pipx to install the CLI
    dependencies = { "nvim-lua/plenary.nvim" },
  }
}

return ai
