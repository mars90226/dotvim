local completion = {}

completion.setup_mapping = function()
  -- Completion setting
  inoremap('<CR>',       [[pumvisible() ? "\<C-Y>" : "\<CR>"]], 'expr')
  inoremap('<Down>',     [[pumvisible() ? "\<C-N>" : "\<Down>"]], 'expr')
  inoremap('<Up>',       [[pumvisible() ? "\<C-P>" : "\<Up>"]], 'expr')
  inoremap('<PageDown>', [[pumvisible() ? "\<PageDown>\<C-P>\<C-N>" : "\<PageDown>"]], 'expr')
  inoremap('<PageUp>',   [[pumvisible() ? "\<PageUp>\<C-P>\<C-N>" : "\<PageUp>"]], 'expr')
  inoremap('<Tab>',      [[pumvisible() ? "\<C-N>" : "\<Tab>"]], 'expr')
  inoremap('<S-Tab>',    [[pumvisible() ? "\<C-P>" : "\<S-Tab>"]], 'expr')

  -- mapping for decrease number
  nnoremap('<C-X><C-X>', '<C-X>')
end

completion.startup = function(use)
  completion.setup_mapping()

  -- Completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      -- Snippets
      {
        'L3MON4D3/LuaSnip',
        config = function()
          local utils = require('vimrc.utils')

          require("luasnip.loaders.from_vscode").lazy_load({
            paths = {
              utils.get_packer_start_dir() .. '/friendly-snippets'
            }
          })
        end
      },

      -- Formatting
      'onsails/lspkind-nvim',

      -- Completion Sources
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      {
        'andersevenrud/compe-tmux',
        branch = 'cmp'
      },
      'octaltree/cmp-look',
      'hrsh7th/cmp-calc',
      'ray-x/cmp-treesitter',
      'hrsh7th/cmp-emoji',
    },
    config = function()

      vim.cmd [[set completeopt=menu,menuone,noselect]]

      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')
      local utils = require('vimrc.utils')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          format = lspkind.cmp_format({maxwidth = 50})
        },
        mapping = {
          ['<C-D>'] = cmp.mapping.scroll_docs(-4),
          ['<C-F>'] = cmp.mapping.scroll_docs(4),
          ['<Tab>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            elseif utils.check_backspace() then
              vim.fn.feedkeys(utils.t'<Tab>', 'n')
            else
              cmp.complete()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-J>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-K>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
          ['<C-E>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'luasnip' },
          { name = 'nvim_lua' },
          { name = 'buffer' },
          { name = 'calc' },
          { name = 'emoji' },
          { name = 'treesitter' },
          { name = 'tmux' },
          { name = 'look', keyword_length = 2, opts = { convert_case = true, loud = true } },
        }
      })

      -- Setup lspconfig in nvim-lsp-installer config function
    end
  }

  -- Snippets source
  use 'rafamadriz/friendly-snippets'
end

return completion
