local plugin_utils = require("vimrc.plugin_utils")

local completion = {}

completion.setup_mapping = function()
  -- Completion setting
  inoremap("<CR>", [[pumvisible() ? "\<C-Y>" : "\<CR>"]], "expr")
  inoremap("<Down>", [[pumvisible() ? "\<C-N>" : "\<Down>"]], "expr")
  inoremap("<Up>", [[pumvisible() ? "\<C-P>" : "\<Up>"]], "expr")
  inoremap("<PageDown>", [[pumvisible() ? "\<PageDown>\<C-P>\<C-N>" : "\<PageDown>"]], "expr")
  inoremap("<PageUp>", [[pumvisible() ? "\<PageUp>\<C-P>\<C-N>" : "\<PageUp>"]], "expr")
  inoremap("<Tab>", [[pumvisible() ? "\<C-N>" : "\<Tab>"]], "expr")
  inoremap("<S-Tab>", [[pumvisible() ? "\<C-P>" : "\<S-Tab>"]], "expr")
  inoremap("<M-K>", [[<C-K>]])

  -- mapping for decrease number
  nnoremap("<C-X><C-X>", "<C-X>")
end

completion.startup = function(use)
  completion.setup_mapping()

  -- Completion
  use({
    "hrsh7th/nvim-cmp",
    requires = vim.tbl_filter(function(plugin_spec)
      return plugin_spec ~= nil
    end, {
      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        config = function()
          -- FIXME: nvim-cmp doesn't show new snippets, but it actually reloaded
          vim.cmd([[command! ReloadLuaSnip call vimrc#source("after/plugin/luasnip.lua")]])
        end,
      }, -- stylua: force newline
      -- Formatting
      "onsails/lspkind-nvim", -- stylua: force newline
      -- Completion Sources
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "andersevenrud/cmp-tmux",
      "octaltree/cmp-look",
      "hrsh7th/cmp-calc",
      plugin_utils.check_enabled_plugin("ray-x/cmp-treesitter", "nvim-treesitter"),
      {
        "petertriho/cmp-git",
        config = function()
          require("cmp_git").setup()
        end,
      },
      "hrsh7th/cmp-emoji",
      plugin_utils.check_executable("lukas-reineke/cmp-rg", "rg"),
      "hrsh7th/cmp-cmdline",
    }),
    config = function()
      vim.cmd([[set completeopt=menu,menuone,noselect]])

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local utils = require("vimrc.utils")

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
        },
      }

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
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
          ["<C-F>"] = cmp.mapping.scroll_docs(4),
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
          ["<C-L>"] = cmp.mapping(function(fallback)
            if luasnip.choice_active() then
              luasnip.change_choice(1)
            end
          end, { "i" }),
          ["<C-E>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        -- Ref: https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/plugins/nvim-cmp.lua#L54-L77
        sources = cmp.config.sources({
          { name = "path", priority_weight = 110 },
          { name = "nvim_lsp", max_item_count = 20, priority_weight = 100 },
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
          vim.tbl_extend("force", buffer_source, {
            max_item_count = 5,
          }),
        }, {
          -- TODO: Timeout slow source?
          {
            name = "rg",
            keyword_length = 5,
            max_item_count = 5,
            option = {
              additional_arguments = "--max-depth 4 --max-count 5",
              debounce = 500,
            },
            priority_weight = 60,
          },
        }),
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

      -- Setup lspconfig in nvim-lsp-installer config function
    end,
  })

  -- Snippets source
  use("rafamadriz/friendly-snippets")

  -- Auto Pairs
  use({
    "windwp/nvim-autopairs",
    config = function()
      ---@diagnostic disable-next-line -- packer.nvim will cache config function and cannot use outer local variables
      local plugin_utils = require("vimrc.plugin_utils")

      local Rule = require("nvim-autopairs.rule")
      local npairs = require("nvim-autopairs")

      npairs.setup({
        check_ts = plugin_utils.is_enabled_plugin("nvim-treesitter"),
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
  })
  -- TODO: use 'abecodes/tabout.nvim'
  -- ref: https://github.com/windwp/nvim-autopairs/issues/167
  use({
    "abecodes/tabout.nvim",
    config = function()
      require("tabout").setup({
        tabkey = "<M-n>", -- key to trigger tabout, set to an empty string to disable
        backwards_tabkey = "<M-N>", -- key to trigger backwards tabout, set to an empty string to disable
      })
    end,
    wants = { "nvim-treesitter" }, -- or require if not used so far
    after = { "nvim-cmp" }, -- if a completion plugin is using tabs load it before
  })
end

return completion
