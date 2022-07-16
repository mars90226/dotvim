local plugin_utils = require("vimrc.plugin_utils")

local completion = {}

completion.setup_mapping = function()
  -- diagraph
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
        after = "nvim-cmp",
        module = "luasnip",
        config = function()
          require("vimrc.plugins.luasnip").setup()

          -- FIXME: nvim-cmp doesn't show new snippets, but it actually reloaded
          -- FIXME: Fix ReloadLuaSnip
          -- vim.cmd([[command! ReloadLuaSnip call vimrc#source("after/plugin/luasnip.lua")]])
        end,
      },
      -- Formatting
      "onsails/lspkind-nvim",
      -- Completion Sources
      { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", module = "cmp_nvim_lsp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
      { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
      { "hrsh7th/cmp-path", after = "nvim-cmp" },
      { "andersevenrud/cmp-tmux", after = "nvim-cmp" },
      { "octaltree/cmp-look", after = "nvim-cmp" },
      { "hrsh7th/cmp-calc", after = "nvim-cmp" },
      plugin_utils.check_enabled_plugin({ "ray-x/cmp-treesitter", after = "nvim-cmp" }, "nvim-treesitter"),
      {
        "petertriho/cmp-git",
        after = "nvim-cmp",
        config = function()
          require("cmp_git").setup()
        end,
      },
      { "hrsh7th/cmp-emoji", after = "nvim-cmp" },
      plugin_utils.check_executable({ "lukas-reineke/cmp-rg", after = "nvim-cmp" }, "rg"),
      { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
    }),
    event = { "InsertEnter", "CmdlineEnter" },
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
            end
          end, { "i" }),
          ["<M-k>"] = cmp.mapping(function(fallback)
            if luasnip.choice_active() then
              luasnip.change_choice(-1)
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
          vim.tbl_extend("force", buffer_source, {
            keyword_length = 5,
            max_item_count = 5,
            priority_weight = 70,
          }),
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

      -- Setup lspconfig in nvim-lsp-installer config function
    end,
  })

  -- Snippets source
  use("rafamadriz/friendly-snippets")

  -- Auto Pairs
  use({
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    config = function()
      ---@diagnostic disable-next-line -- packer.nvim will cache config function and cannot use outer local variables
      local choose = require("vimrc.choose")

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
