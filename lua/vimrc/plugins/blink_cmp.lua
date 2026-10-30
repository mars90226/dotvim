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

--- Temporarily disable blink.cmp while running a callback.
--- Useful around nested cmdline prompts where rendering completion windows is not allowed.
blink_cmp.with_suspended = function(callback)
  local was_enabled = blink_cmp.is_enabled()

  if was_enabled then
    blink_cmp.disable()
    pcall(function()
      require("blink.cmp.completion.trigger").hide()
    end)
  end

  local success, result = pcall(callback)

  if was_enabled then
    vim.schedule(function()
      blink_cmp.enable()
    end)
  end

  if not success then
    error(result)
  end

  return result
end

-- Flags for blink-ripgrep's git grep backend, matching `additional_rg_options` of ripgrep backend.
-- `--max-count` limits matches per file, which reduces the output parsed on every keystroke.
blink_cmp.ripgrep_gitgrep_flags = { "--threads=2", "--max-count=10" }

-- NOTE: blink-ripgrep appends `additional_gitgrep_options` after the search pattern because it's
-- meant for pathspecs, so git grep rejects flags there ("option must come before non-option
-- arguments"). Insert flags before the pattern instead. This wraps an internal module of
-- blink-ripgrep.nvim, recheck after updating it.
blink_cmp.setup_ripgrep_gitgrep_flags = function()
  local ok, gitgrep_command = pcall(require, "blink-ripgrep.backends.git_grep.gitgrep_command")
  if not ok or gitgrep_command._vimrc_flags_wrapped then
    return
  end

  local get_command = gitgrep_command.get_command
  gitgrep_command.get_command = function(prefix, config)
    local command, err = get_command(prefix, config)
    if command then
      local pattern = prefix .. "[\\w_-]+"
      for i, arg in ipairs(command.command) do
        if arg == pattern then
          for j, flag in ipairs(blink_cmp.ripgrep_gitgrep_flags) do
            table.insert(command.command, i + j - 1, flag)
          end
          break
        end
      end
    end
    return command, err
  end
  gitgrep_command._vimrc_flags_wrapped = true
end

local ripgrep_parser_source_pattern = "/blink%-ripgrep/backends/[%w_]+/[%w_]+_parser%.lua$"

local wrap_ripgrep_parser = function(module_name, function_name)
  local ok, parser = pcall(require, module_name)
  if not ok or parser._vimrc_lazy_language then
    return
  end

  local parse = parser[function_name]
  parser[function_name] = function(...)
    local filetype_match = vim.filetype.match
    -- Parsing is synchronous, but only skip calls from the parsers themselves in case that changes.
    vim.filetype.match = function(args, ...)
      if debug.getinfo(2, "S").source:find(ripgrep_parser_source_pattern) then
        return nil
      end
      return filetype_match(args, ...)
    end
    local parse_ok, output = pcall(parse, ...)
    vim.filetype.match = filetype_match
    if not parse_ok then
      error(output, 0)
    end

    for _, file in pairs(output.files) do
      file.language = nil
    end
    return output
  end
  parser._vimrc_lazy_language = true
end

-- NOTE: blink-ripgrep parsers call `vim.filetype.match` (~35µs) for every matched file on every
-- keystroke, which blocks typing for 50-260ms in large repos. The result is only used by the
-- documentation preview, which calls `vim.filetype.match` again anyway. Skip it while parsing and
-- compute the language lazily when an item's documentation is rendered. This wraps internal
-- modules of blink-ripgrep.nvim, recheck after updating it.
blink_cmp.setup_ripgrep_lazy_language = function()
  wrap_ripgrep_parser("blink-ripgrep.backends.git_grep.git_grep_parser", "parse_output")
  wrap_ripgrep_parser("blink-ripgrep.backends.ripgrep.ripgrep_parser", "parse")

  local ok, documentation = pcall(require, "blink-ripgrep.documentation")
  if not ok or documentation._vimrc_lazy_language then
    return
  end

  local render = documentation.render_item_documentation
  documentation.render_item_documentation = function(config, draw_opts, file, match)
    if file.language == nil then
      -- Same fallback chain as blink-ripgrep's parsers
      local ext = vim.fn.fnamemodify(file.path, ":e")
      file.language = vim.filetype.match({ filename = file.path })
        or vim.treesitter.language.get_lang(ext or "text")
        or ext
    end
    return render(config, draw_opts, file, match)
  end
  documentation._vimrc_lazy_language = true
end

blink_cmp.setup = function()
  local blink = require("blink.cmp")

  if choose.is_enabled_plugin("blink-ripgrep.nvim") then
    blink_cmp.setup_ripgrep_gitgrep_flags()
  end

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
          columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_name" } },
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
                  local lspkind_icon = lspkind.symbolic(ctx.kind, {
                    mode = "symbol",
                  })
                  if lspkind_icon ~= "" then
                    icon = lspkind_icon
                  end
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
        choose.is_enabled_plugin("blink-cmp-dictionary") and "dictionary" or nil,
        choose.is_enabled_plugin("cmp-git") and "git" or nil,
        choose.is_enabled_plugin("blink-emoji.nvim") and "emoji" or nil,
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
          module = 'blink-cmp-dictionary',
          name = 'Dict',
          score_offset = -5,
          enabled = function()
            return choose.is_enabled_plugin("blink-cmp-dictionary")
          end,
          -- Make sure this is at least 2.
          -- 3 is recommended
          min_keyword_length = 3,
          max_items = 5,
          opts = {
            dictionary_files = { plugin_utils.get_dictionary() },
          }
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
          module = "blink-emoji",
          name = "Emoji",
          enabled = function()
            return choose.is_enabled_plugin("blink-emoji.nvim")
          end,
          score_offset = 15, -- Tune by preference
          opts = {
            insert = true,   -- Insert emoji (default) or complete its name
            ---@type string|table|fun():table
            trigger = function()
              return { ":" }
            end,
          },
          should_show_items = function()
            return vim.tbl_contains(
            -- Enable emoji completion only for git commits and markdown.
            -- By default, enabled for all file-types.
              { "gitcommit", "markdown" },
              vim.o.filetype
            )
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
                -- NOTE: Avoid searching huge directories when the project root falls back to them
                -- (no .git found and cwd is one of these). The output of every keystroke is kept in
                -- memory until rg exits. Matched exactly against the search root.
                ignore_paths = { "/", "/tmp", "/var/tmp", vim.env.HOME },
              },
              gitgrep = {
                -- NOTE: Only pathspecs work here. Flags are set by `blink_cmp.ripgrep_gitgrep_flags`.
                -- additional_gitgrep_options = {},
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

  -- NOTE: After blink.setup(), as blink-ripgrep.documentation reads blink config when loaded
  if choose.is_enabled_plugin("blink-ripgrep.nvim") then
    blink_cmp.setup_ripgrep_lazy_language()
  end
end

return blink_cmp
