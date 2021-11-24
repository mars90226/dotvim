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
          local utils = require("vimrc.utils")

          require("luasnip.loaders.from_vscode").lazy_load({
            paths = vim.tbl_filter(function(path)
              return vim.fn.isdirectory(path) > 0
            end, {
              utils.get_packer_start_dir() .. "/friendly-snippets",
              vim.env.HOME .. "/.vim_secret",
            }),
          })
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
      { "andersevenrud/compe-tmux", branch = "cmp" },
      "octaltree/cmp-look",
      "hrsh7th/cmp-calc",
      plugin_utils.check_condition(
        "ray-x/cmp-treesitter",
        vim.fn["vimrc#plugin#is_enabled_plugin"]("nvim-treesitter") == 1
      ),
      {
        "petertriho/cmp-git",
        config = function()
          require("cmp_git").setup()
        end,
      },
      "hrsh7th/cmp-emoji",
      plugin_utils.check_condition("lukas-reineke/cmp-rg", vim.fn.executable("rg") > 0),
    }),
    config = function()
      vim.cmd([[set completeopt=menu,menuone,noselect]])

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local utils = require("vimrc.utils")

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
        mapping = {
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
          ["<C-E>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip" },
          { name = "nvim_lua" },
          { name = "buffer" },
          { name = "calc" },
          { name = "emoji" },
          { name = "treesitter" },
          { name = "cmp_git" },
          { name = "tmux" },
          { name = "rg" },
          {
            name = "look",
            keyword_length = 2,
            option = { convert_case = true, loud = true },
          },
        },
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
      local Rule = require("nvim-autopairs.rule")
      local npairs = require("nvim-autopairs")

      npairs.setup({
        check_ts = vim.fn["vimrc#plugin#is_enabled_plugin"]("nvim-treesitter") == 1,
        fast_wrap = {},
      })

      -- nvim-cmp integration
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

      inoremap("<M-n>", [[<Cmd>call vimrc#auto_pairs#jump()<CR>]], "<silent>")
      nnoremap("<M-n>", [[<Cmd>call vimrc#auto_pairs#jump()<CR>]], "<silent>")

      -- Rules
      npairs.add_rule(Rule("%w<", ">", "cpp"):use_regex(true))
      npairs.add_rule(Rule("%w<", ">", "rust"):use_regex(true))
      npairs.add_rule(Rule("<", ">", "xml"))
    end,
  })
  -- TODO: use 'abecodes/tabout.nvim'
  -- ref: https://github.com/windwp/nvim-autopairs/issues/167
end

return completion
