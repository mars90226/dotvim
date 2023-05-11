local cmp = require("cmp")
local luasnip = require("luasnip")
local select_choice = require("luasnip.extras.select_choice")
local lspkind = require("lspkind")
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
        menu = {
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
          look = "[Look]",
        },
      }),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-D>"] = cmp.mapping.scroll_docs(-4),
      ["<C-F>"] = cmp.mapping({
        c = function(fallback)
          cmp.abort()
          fallback()
        end,
        i = cmp.mapping.scroll_docs(4),
        s = cmp.mapping.scroll_docs(4),
      }),
      ["<Tab>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_next_item()
        elseif utils.check_backspace() then
          vim.fn.feedkeys(utils.t("<Tab>"), "n")
        else
          cmp.complete()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
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
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    -- Ref: https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/plugins/nvim-cmp.lua#L54-L77
    sources = cmp.config.sources({
      { name = "path", priority_weight = 110 },
      { name = "nvim_lsp", max_item_count = 20, priority_weight = 100 },
      { name = "nvim_lsp_signature_help", priority_weight = 100 },
      { name = "nvim_lua", priority_weight = 90 },
      { name = "luasnip", priority_weight = 80 },
      { name = "calc", priority_weight = 70 },
      { name = "emoji", priority_weight = 70 },
      { name = "treesitter", priority_weight = 70 },
      { name = "cmp_git", priority_weight = 70 },
      {
        name = "tmux",
        max_item_count = 5,
        option = {
          all_panes = false,
        },
        priority_weight = 50,
      },
      {
        name = "look",
        keyword_length = 5,
        max_item_count = 5,
        option = { convert_case = true, loud = true },
        priority_weight = 40,
      },
    }, {
      vim.tbl_deep_extend("force", buffer_source, {
        keyword_length = 5,
        max_item_count = 5,
        option = {
          keyword_length = 5,
        },
        priority_weight = 70,
      }),
      -- TODO: Timeout slow source?
      {
        name = "rg",
        keyword_length = 5,
        max_item_count = 5,
        option = {
          additional_arguments = "--threads 2 --max-count 5",
          debounce = 500,
        },
        priority_weight = 60,
      },
    }),
    experimental = {
      native_menu = false,
    },
  })

  -- Setup cmp-cmdline
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
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
end

return nvim_cmp
