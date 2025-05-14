local cmp = require("cmp")
local lspkind = require("lspkind")
local choose = require("vimrc.choose")
local insert = require("vimrc.insert")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local cmp_config_default = require("cmp.config.default")()

local nvim_cmp = {}

nvim_cmp.enabled = true

nvim_cmp.is_enabled = function()
  if not nvim_cmp.enabled then
    return false
  end

  if cmp_config_default.enabled() then
    return true
  end

  if require("vimrc.plugins.lazy").is_loaded("cmp-dap") and require("cmp_dap").is_dap_buffer() then
    return true
  end

  return false
end

nvim_cmp.enable = function()
  nvim_cmp.enabled = true
end

nvim_cmp.disable = function()
  nvim_cmp.enabled = false
end

-- Ref: https://github.com/hrsh7th/cmp-cmdline/issues/33#issuecomment-1793891721
nvim_cmp.handle_tab_completion = function(direction)
  return function(fallback)
    if vim.api.nvim_get_mode().mode == "c" and cmp.get_selected_entry() == nil then
      -- NOTE: Manually expand command line to handle '%'
      local text = vim.fn.getcmdline()
      ---@diagnostic disable-next-line: param-type-mismatch
      -- NOTE: Explicitly check for the following characters:
      -- 1. '#' to avoid expanding '#', as it's used in VimScript as namespace separator.
      -- 2. '\\' to avoid expanding '\', as it's used in pattern.
      -- 3. '%' in the beginning of the command line to avoid expanding '%', as it's command range, not current filename.
      local disable_expansion = string.find(text, "[#\\]") or string.find(text, "^%%")
      local expanded = (not disable_expansion) and vim.fn.expandcmd(text) or text
      if expanded ~= text then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, true, true) .. expanded, "n", false)
        cmp.complete()
      elseif cmp.visible() then
        -- FIXME: When using <Tab> to select item under some circumstances, the completion menu will
        -- not be updated with the current selected item.
        direction()
      else
        cmp.complete()
      end
    else
      if cmp.visible() then
        direction()
      elseif insert.check_backspace() then
        -- NOTE: both <Tab> & <S-Tab> are inserting <Tab>
        vim.fn.feedkeys(utils.t("<Tab>"), "n")
      else
        cmp.complete()
      end
    end
  end
end

-- TODO: Refactor this
nvim_cmp.insert_luasnip_source_to_filetype = function(filetype)
  local luasnip_source = plugin_utils.check_enabled_plugin({ name = "luasnip" }, "LuaSnip")
  local cmp_filetype_config = require("cmp.config").filetypes[filetype] or {}
  local cmp_filetype_config_sources = cmp_filetype_config.sources or {}
  table.insert(cmp_filetype_config_sources, luasnip_source)

  cmp.setup.filetype(filetype, {
    sources = cmp_filetype_config_sources,
  })
end

nvim_cmp.setup = function()
  vim.cmd([[set completeopt=menu,menuone,noselect]])

  local max_buffer_size = 1024 * 1024 -- 1 Megabyte max

  local buffer_source = {
    name = "buffer",
    option = {
      get_bufnrs = function()
        local buf = vim.api.nvim_get_current_buf()
        local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
        if byte_size > max_buffer_size then
          return {}
        end
        return { buf }
      end,
      indexing_interval = 1000,
    },
  }

  cmp.setup({
    enabled = function()
      return require("vimrc.plugins.nvim_cmp").is_enabled()
    end,
    snippet = {
      expand = function(args)
        if choose.is_enabled_plugin("LuaSnip") then
          -- TODO: Do not expand snippets if the snippet is an interactive snippet (e.g. `choice`,
          -- or calling to tools like fzf, etc.)
          require("luasnip").lsp_expand(args.body)
        end
        -- TODO: Support neovim built-in snippets: `vim.snippet`
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol_text",
        maxwidth = 50,
        show_labelDetails = false,
        -- TODO: Refactor this
        menu = vim.tbl_extend(
          "keep",
          {
            nvim_lsp = "[LSP]",
            path = "[Path]",
            nvim_lua = "[Lua]",
            buffer = "[Buffer]",
          },
          plugin_utils.check_enabled_plugin({ tmux = "[Tmux]" }, "cmp-tmux", {}),
          plugin_utils.check_enabled_plugin({ dictionary = "[Dictionary]" }, "cmp-dictionary", {}),
          plugin_utils.check_enabled_plugin({ calc = "[Calc]" }, "cmp-calc", {}),
          plugin_utils.check_enabled_plugin({ treesitter = "[Treesitter]" }, "cmp-treesitter", {}),
          plugin_utils.check_enabled_plugin({ cmp_git = "[Git]" }, "cmp-git", {}),
          plugin_utils.check_enabled_plugin({ emoji = "[Emoji]" }, "cmp-emoji", {}),
          plugin_utils.check_enabled_plugin({ rg = "[Rg]" }, "cmp-rg", {}),
          plugin_utils.check_enabled_plugin({ luasnip = "[LuaSnip]" }, "LuaSnip", {}),
          plugin_utils.check_enabled_plugin({ copilot = "[Copilot]" }, "copilot-cmp", {})
        ),
        before = function(entry, vim_item)
          -- TODO: Monitor if this hinders cmp performance
          if require("vimrc.plugins.lazy").is_loaded("tailwindcss-colorizer-cmp.nvim") then
            vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
          end
          return vim_item
        end,
      }),
    },
    mapping = cmp.mapping.preset.insert(vim.tbl_extend(
      "keep",
      {
        ["<C-D>"] = cmp.mapping.scroll_docs(-4),
        ["<C-F>"] = cmp.mapping({
          c = function(fallback)
            cmp.abort()
            fallback()
          end,
          i = cmp.mapping.scroll_docs(4),
          s = cmp.mapping.scroll_docs(4),
        }),
        ["<Tab>"] = cmp.mapping(nvim_cmp.handle_tab_completion(cmp.select_next_item), { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(nvim_cmp.handle_tab_completion(cmp.select_prev_item), { "i", "s" }),
        ["<C-Space>"] = cmp.mapping.complete(),
      },
      -- TODO: Support neovim built-in snippets: `vim.snippet`
      plugin_utils.check_enabled_plugin({
        ["<C-J>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")

          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-K>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")

          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
        -- TODO: Combine LuaSnip with copilot.lua
        ["<M-S-j>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")

          if luasnip.choice_active() then
            luasnip.change_choice(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        -- TODO: Combine LuaSnip with copilot.lua
        ["<M-S-k>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")

          if luasnip.choice_active() then
            luasnip.change_choice(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<M-s>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")
          local select_choice = require("luasnip.extras.select_choice")

          if luasnip.choice_active() then
            select_choice()
          else
            fallback()
          end
        end, { "i" }),
      }, "LuaSnip", {}),
      -- Copilot
      plugin_utils.check_enabled_plugin({
        -- Dismiss copilot suggestion if visible and accept nvim-cmp completion
        ["<C-Y>"] = cmp.mapping(function(fallback)
          local copilot_suggestion = require("copilot.suggestion")

          if copilot_suggestion.is_visible() then
            copilot_suggestion.dismiss()
          end

          cmp.mapping.confirm({ select = false })(fallback)
        end),
        -- Dismiss copilot suggestion if visible and accept nvim-cmp completion
        ["<CR>"] = cmp.mapping(function(fallback)
          local copilot_suggestion = require("copilot.suggestion")

          if copilot_suggestion.is_visible() then
            copilot_suggestion.dismiss()
          end

          cmp.mapping.confirm({ select = false })(fallback)
        end),
        -- Close nvim-cmp and accept copilot suggestion if visible
        ["<M-l>"] = cmp.mapping(function(fallback)
          local copilot_suggestion = require("copilot.suggestion")

          if copilot_suggestion.is_visible() then
            cmp.mapping.close()(fallback)

            if choose.is_enabled_plugin("nvim-autopairs") then
              -- NOTE: Fix bug that nvim-autopairs adding extra closing brackets
              -- Ref: https://github.com/zbirenbaum/copilot.lua/issues/215#issuecomment-1918114065
              require("nvim-autopairs").disable()
            end

            copilot_suggestion.accept()

            if choose.is_enabled_plugin("nvim-autopairs") then
              require("nvim-autopairs").enable()
            end
          else
            fallback()
          end
        end),
        -- Close nvim-cmp and show copilot next suggestion
        ["<M-]>"] = cmp.mapping(function(fallback)
          local copilot_suggestion = require("copilot.suggestion")

          cmp.mapping.close()(fallback)
          copilot_suggestion.next()
        end),
        -- Close nvim-cmp and show copilot prev suggestion
        ["<M-[>"] = cmp.mapping(function(fallback)
          local copilot_suggestion = require("copilot.suggestion")

          cmp.mapping.close()(fallback)
          copilot_suggestion.prev()
        end),
      }, "copilot-cmp", {})
    )),
    -- Ref: https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/plugins/nvim-cmp.lua#L54-L77
    sources = cmp.config.sources(
      vim.tbl_filter(function(component)
        return component ~= nil
      end, {
        -- plugin_utils.check_enabled_plugin({ name = "copilot", priority_weight = 120 }, "copilot-cmp"),
        { name = "path",                    priority_weight = 110 },
        { name = "nvim_lsp",                max_item_count = 20,  priority_weight = 100 },
        plugin_utils.check_enabled_plugin({ name = "nvim_lsp_signature_help", priority_weight = 100 }, "cmp-nvim-lsp-signature-help"),
        { name = "nvim_lua",                priority_weight = 90 },
        plugin_utils.check_enabled_plugin({ name = "luasnip", priority_weight = 80 }, "LuaSnip"),
        plugin_utils.check_enabled_plugin({ name = "calc", priority_weight = 70 }, "cmp-calc"),
        plugin_utils.check_enabled_plugin({ name = "emoji", priority_weight = 70 }, "cmp-emoji"),
        plugin_utils.check_enabled_plugin({ name = "treesitter", priority_weight = 70 }, "cmp-treesitter"),
        plugin_utils.check_enabled_plugin({ name = "cmp_git", priority_weight = 70 }, "cmp-git"),
        plugin_utils.check_enabled_plugin({
          name = "tmux",
          max_item_count = 5,
          option = {
            all_panes = false,
          },
          priority_weight = 50,
        }, "cmp-tmux"),
        {
          name = "crates",
          priority_weight = 40,
        },
      }),
      vim.tbl_filter(function(component)
        return component ~= nil
      end, {
        -- TODO: Timeout slow source?
        plugin_utils.check_enabled_plugin({
          name = "rg",
          keyword_length = 3,
          max_item_count = 10,
          option = {
            additional_arguments = "--threads 2 --max-count 10",
            debounce = 500,
          },
          priority_weight = 70,
          entry_filter = function(entry)
            return not entry.exact
          end,
        }, "cmp-rg"),
        plugin_utils.check_enabled_plugin({
          name = "dictionary",
          keyword_length = 3,
          max_item_count = 5,
          priority_weight = 50,
          entry_filter = function(entry)
            return not entry.exact
          end,
        }, "cmp-dictionary"),
      }),
      vim.tbl_filter(function(component)
        return component ~= nil
      end, {
        vim.tbl_deep_extend("force", buffer_source, {
          max_item_count = 5,
          option = {
            keyword_length = 3,
          },
          priority_weight = 60,
          entry_filter = function(entry)
            return not entry.exact
          end,
        }),
      })
    ),
    experimental = {
      native_menu = false,
    },
  })

  -- Setup cmp-cmdline
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline({
      ["<Tab>"] = cmp.mapping(nvim_cmp.handle_tab_completion(cmp.select_next_item), { "c" }),
      ["<S-Tab>"] = cmp.mapping(nvim_cmp.handle_tab_completion(cmp.select_prev_item), { "c" }),
    }),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }, {
      buffer_source,
    }, {
      { name = "cmdline_history" },
    }),
  })
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      buffer_source,
    }, {
      { name = "cmdline_history" },
    }),
  })
  cmp.setup.cmdline("?", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      buffer_source,
    }, {
      { name = "cmdline_history" },
    }),
  })
  cmp.setup.cmdline("@", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }, {
      buffer_source,
    }),
  })

  -- TODO: Use `cmp.setup.filetype` to setup for specific filetypes

  if choose.enable_plugin("copilot-cmp") then
    -- Setup event for copilot.lua
    cmp.event:on("menu_opened", function()
      vim.b.copilot_suggestion_hidden = true
    end)

    cmp.event:on("menu_closed", function()
      vim.b.copilot_suggestion_hidden = false
    end)
  end
end

return nvim_cmp
