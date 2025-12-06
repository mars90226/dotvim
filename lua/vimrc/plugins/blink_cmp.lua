local devicons = require("nvim-web-devicons")
local lspkind = require("lspkind")

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
      preset = 'luasnip',
    },

    -- TODO: Use 'winborder' instead
    completion = {
      menu = {
        draw = {
          -- We don't need label_description now because label and label_description are already
          -- combined together in label by colorful-menu.nvim.
          columns = { { "kind_icon" }, { "label", gap = 1 } },
          components = {
            -- nvim-web-devicons + lspkind-nvim
            -- Ref: https://cmp.saghen.dev/recipes.html#nvim-web-devicons-lspkind
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, _ = devicons.get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                else
                  icon = lspkind.symbolic(ctx.kind, {
                    mode = "symbol",
                  })
                end

                return icon .. ctx.icon_gap
              end,

              -- Optionally, use the highlight groups from nvim-web-devicons
              -- You can also add the same function for `kind.highlight` if you want to
              -- keep the highlight groups in sync with the icons.
              highlight = function(ctx)
                local hl = ctx.kind_hl
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, dev_hl = devicons.get_icon(ctx.label)
                  if dev_icon then
                    hl = dev_hl
                  end
                end
                return hl
              end,
            },

            -- colorful-menu.nvim
            -- Ref: https://github.com/xzbdmw/colorful-menu.nvim?tab=readme-ov-file#use-it-in-blinkcmp
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          }
        },
        border = "rounded",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
      },
      ghost_text = {
        enabled = true,
      },
    },
    signature = { window = { border = "rounded" } },

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

      -- Show ripgrep result
      ["<M-g>"] = {
        function()
          blink.show({ providers = { "ripgrep" } })
        end,
      },
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
        choose.is_enabled_plugin("blink-ripgrep.nvim") and "ripgrep" or nil,
        choose.is_enabled_plugin("cmp-calc") and "calc" or nil,
        choose.is_enabled_plugin("cmp-treesitter") and "treesitter" or nil,
        choose.is_enabled_plugin("blink-copilot") and "copilot" or nil,
      }),

      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
        ["dap-repl"] = { "dap" },
        ["dapui_watches"] = { "dap" },
        ["dapui_hover"] = { "dap" },
      },

      providers = {
        snippets = {
          opts = {
            -- see the list of frameworks in: https://github.com/rafamadriz/friendly-snippets/tree/main/snippets/frameworks
            -- and search for possible languages in: https://github.com/rafamadriz/friendly-snippets/blob/main/package.json
            -- the following is just an example, you should only enable the frameworks that you use
            extended_filetypes = {
              vue = { 'vue' },
            }
          }
        },
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

        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          score_offset = -3,
          enabled = function()
            return choose.is_enabled_plugin("blink-ripgrep.nvim")
          end,
          -- see the full configuration below for all available options
          ---@module "blink-ripgrep"
          ---@type blink-ripgrep.Options
          opts = {
            -- the minimum length of the current word to start searching
            -- (if the word is shorter than this, the search will not start)
            prefix_min_len = 3,
            backend = {
              -- - "gitgrep-or-ripgrep", use git grep if possible, otherwise
              --   use ripgrep. Uses the same options as the gitgrep backend
              use = "gitgrep-or-ripgrep",
              -- use = "ripgrep",
              ripgrep = {
                additional_rg_options = { "--threads", "2", "--max-count", "10" },
              },
              gitgrep = {
                -- TODO: Add these configs break the git grep. Don't know why.
                -- additional_gitgrep_options = { "--threads", "2", "--max-count", "10" },
              },
            }
          },
          async = true,
          max_items = 10,
          min_keyword_length = 3,
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
          module = "blink-copilot",
          score_offset = 100,
          enabled = function()
            return choose.is_enabled_plugin("blink-copilot")
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
        },

        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100, -- show at a higher priority than lsp
        },
      },
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
