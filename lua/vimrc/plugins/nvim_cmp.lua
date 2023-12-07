local cmp = require("cmp")
local luasnip = require("luasnip")
local select_choice = require("luasnip.extras.select_choice")
local lspkind = require("lspkind")
local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local cmp_config_default = require("cmp.config.default")()

local nvim_cmp = {}

nvim_cmp.enabled = true

nvim_cmp.is_enabled = function()
  return cmp_config_default.enabled() and nvim_cmp.enabled
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
      -- NOTE: Explicitly check for '#' to avoid expanding '#', as it's used in VimScript as
      -- namespace separator.
      local expanded = string.find(text, "#") == nil and vim.fn.expandcmd(text) or text
      if expanded ~= text then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, true, true) .. expanded, "n", false)
        cmp.complete()
      elseif cmp.visible() then
        direction()
      else
        cmp.complete()
      end
    else
      if cmp.visible() then
        direction()
      elseif utils.check_backspace() then
        -- NOTE: both <Tab> & <S-Tab> are inserting <Tab>
        vim.fn.feedkeys(utils.t("<Tab>"), "n")
      else
        cmp.complete()
      end
    end
  end
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
    performance = {
      debounce = 150, -- Same as LSP debounce
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    formatting = {
      format = lspkind.cmp_format({
        with_text = true,
        maxwidth = 50,
        menu = vim.tbl_extend("keep", {
          nvim_lsp = "[LSP]",
          path = "[Path]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[Lua]",
          buffer = "[Buffer]",
          calc = "[Calc]",
          emoji = "[Emoji]",
          treesitter = "[Treesitter]",
          cmp_git = "[Git]",
          tmux = "[Tmux]",
          rg = "[Rg]",
          dictionary = "[Dictionary]",
        }, plugin_utils.check_enabled_plugin({
          copilot = "[Copilot]",
        }, "copilot-cmp") or {}),
      }),
    },
    mapping = cmp.mapping.preset.insert(vim.tbl_extend("keep", {
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
      ["<C-J>"] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { "i", "s" }),
      ["<C-K>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { "i", "s" }),
      ["<M-j>"] = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        else
          fallback()
        end
      end, { "i" }),
      ["<M-k>"] = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
          luasnip.change_choice(-1)
        else
          fallback()
        end
      end, { "i" }),
      ["<M-s>"] = cmp.mapping(function(fallback)
        if luasnip.choice_active() then
          select_choice()
        else
          fallback()
        end
      end, { "i" }),
      ["<C-Space>"] = cmp.mapping.complete(),
    }, plugin_utils.check_enabled_plugin({
      ["<CR>"] = cmp.mapping(function(fallback)
        local copilot_suggestion = require("copilot.suggestion")

        if copilot_suggestion.is_visible() then
          copilot_suggestion.accept()
        else
          cmp.mapping.confirm({ select = true })(fallback)
        end
      end),
      -- Copilot
      -- Close nvim-cmp and accept copilot suggestion if visible
      ["<M-l>"] = cmp.mapping(function(fallback)
        local copilot_suggestion = require("copilot.suggestion")

        if copilot_suggestion.is_visible() then
          cmp.mapping.close()(fallback)
          copilot_suggestion.accept()
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
    }, "copilot-cmp") or {})),
    -- Ref: https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/plugins/nvim-cmp.lua#L54-L77
    sources = cmp.config.sources(
      vim.tbl_filter(function(component)
        return component ~= nil
      end, {
        plugin_utils.check_enabled_plugin({ name = "copilot", priority_weight = 120 }, "copilot-cmp"),
        { name = "path", priority_weight = 110 },
        { name = "nvim_lsp", max_view_entries = 20, priority_weight = 100 },
        { name = "nvim_lsp_signature_help", priority_weight = 100 },
        { name = "nvim_lua", priority_weight = 90 },
        { name = "luasnip", priority_weight = 80 },
        { name = "calc", priority_weight = 70 },
        { name = "emoji", priority_weight = 70 },
        { name = "treesitter", priority_weight = 70 },
        { name = "cmp_git", priority_weight = 70 },
        {
          name = "tmux",
          max_view_entries = 5,
          option = {
            all_panes = false,
          },
          priority_weight = 50,
        },
        {
          name = "dictionary",
          keyword_length = 2,
          max_view_entries = 10,
          priority_weight = 40,
        },
        {
          name = "crates",
          priority_weight = 30,
        },
      }),
      {
        vim.tbl_deep_extend("force", buffer_source, {
          keyword_length = 5,
          max_view_entries = 5,
          option = {
            keyword_length = 5,
          },
          priority_weight = 70,
        }),
        -- TODO: Timeout slow source?
        {
          name = "rg",
          keyword_length = 5,
          max_view_entries = 5,
          option = {
            additional_arguments = "--threads 2 --max-count 5",
            debounce = 500,
          },
          priority_weight = 60,
        },
      }
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
