local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")

local blink_cmp = {}

blink_cmp.enabled = true

blink_cmp.is_enabled = function()
  return blink_cmp.enabled
end

blink_cmp.enable = function()
  blink_cmp.enabled = true
end

blink_cmp.disable = function()
  blink_cmp.enabled = false
end

blink_cmp.setup = function()
  local blink = require("blink.cmp")

  blink.setup({
    enabled = function()
      return blink_cmp.is_enabled()
    end,

    appearance = {
      use_nvim_cmp_as_default = false,
    },

    snippets = {
      expand = function(snippet)
        if choose.is_enabled_plugin("LuaSnip") then
          require("luasnip").lsp_expand(snippet)
        else
          vim.snippet.expand(snippet)
        end
      end,
    },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },

    keymap = {
      preset = "default",
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-J>"] = { "snippet_forward", "select_next", "fallback" },
      ["<C-K>"] = { "snippet_backward", "select_prev", "fallback" },

      -- Remap Tab and Shift-Tab to navigate completion menu
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },

      -- Enter to accept completion
      ["<CR>"] = { "accept", "fallback" },


      ["<M-[>"] = { "select_prev", "fallback" },
      ["<M-]>"] = { "select_next", "fallback" },
      ["<M-l>"] = { "accept", "fallback" },
    },

    sources = {
      default = vim.tbl_filter(function(name)
        return name ~= nil
      end, {
        "lsp",
        "path",
        "buffer",
        "snippets",
        choose.is_enabled_plugin("cmp-tmux") and "tmux" or nil,
        choose.is_enabled_plugin("cmp-dictionary") and "dictionary" or nil,
        choose.is_enabled_plugin("cmp-git") and "git" or nil,
        choose.is_enabled_plugin("cmp-emoji") and "emoji" or nil,
        choose.is_enabled_plugin("cmp-rg") and "rg" or nil,
        choose.is_enabled_plugin("cmp-calc") and "calc" or nil,
        choose.is_enabled_plugin("cmp-treesitter") and "treesitter" or nil,
        choose.is_enabled_plugin("blink-cmp-copilot") and "copilot" or nil,
      }),

      per_filetype = {
        ["dap-repl"] = { "dap" },
        ["dapui_watches"] = { "dap" },
        ["dapui_hover"] = { "dap" },
      },

      providers = {
        tmux = {
          module = "blink.compat.source",
          -- TODO: adjust score for blink.cmp
          -- score_offset = 50,
          enabled = function()
            return choose.is_enabled_plugin("cmp-tmux")
          end,
          opts = { all_panes = false },
        },

        dictionary = {
          module = "blink.compat.source",
          -- TODO: adjust score for blink.cmp
          -- score_offset = 50,
          enabled = function()
            return choose.is_enabled_plugin("cmp-dictionary")
          end,
          opts = {
            exact_length = 5,
            first_case_insensitive = true,
            paths = { plugin_utils.get_dictionary() },
          },
        },
        git = {
          module = "blink.compat.source",
          -- TODO: adjust score for blink.cmp
          -- score_offset = 70,
          enabled = function()
            return choose.is_enabled_plugin("cmp-git")
          end,
        },

        emoji = {
          module = "blink.compat.source",
          -- TODO: adjust score for blink.cmp
          -- score_offset = 70,
          enabled = function()
            return choose.is_enabled_plugin("cmp-emoji")
          end,
        },

        rg = {
          module = "blink.compat.source",
          -- TODO: adjust score for blink.cmp
          -- score_offset = 70,
          enabled = function()
            return choose.is_enabled_plugin("cmp-rg")
          end,
          opts = {
            keyword_length = 3,
            max_item_count = 10,
            additional_arguments = "--threads 2 --max-count 10",
            debounce = 500,
          },
        },

        calc = {
          module = "blink.compat.source",
          -- TODO: adjust score for blink.cmp
          -- score_offset = 60,
          enabled = function()
            return choose.is_enabled_plugin("cmp-calc")
          end,
        },

        treesitter = {
          module = "blink.compat.source",
          -- TODO: adjust score for blink.cmp
          -- score_offset = 60,
          enabled = function()
            return choose.is_enabled_plugin("cmp-treesitter")
          end,
        },

        copilot = {
          module = "blink-cmp-copilot",
          score_offset = 100,
          enabled = function()
            return choose.is_enabled_plugin("blink-cmp-copilot")
          end,
          async = true,
        },

        dap = {
          module = "blink.compat.source",
          -- TODO: adjust score for blink.cmp
          -- score_offset = 80,
          enabled = function()
            return true
          end,
        }
      }
    },

    cmdline = {
      enabled = true,
      keymap = {
        preset = "cmdline",
        ["<Right>"] = false,
        ["<Left>"] = false,
      },
      completion = {
        list = { selection = { preselect = false } },
        menu = {
          auto_show = true,
        },
        ghost_text = { enabled = true },
      },
    },
  })
end

return blink_cmp
