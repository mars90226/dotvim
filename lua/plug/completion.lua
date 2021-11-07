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

  -- Language Server Protocol
  use {
    'neovim/nvim-lspconfig',
    config = function()
      nnoremap('<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', 'silent')
      nnoremap('1gD',   '<Cmd>lua vim.lsp.buf.type_definition()<CR>', 'silent')
      nnoremap('gR',    '<Cmd>lua vim.lsp.buf.references()<CR>', 'silent')
      nnoremap('g0',    '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', 'silent')

      -- Remap for K
      nnoremap('gK', 'K')

      vim.go.omnifunc = [[v:lua.vim.lsp.omnifunc]]
    end
  }
  use {
    'williamboman/nvim-lsp-installer',
    config = function()
      local lsp_installer = require("nvim-lsp-installer")
      local lsp_configs = require('vimrc.lsp')
      local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

      lsp_installer.on_server_ready(function(server)
        local opts = lsp_configs[server.name] or {}
        opts = vim.tbl_extend('keep', opts, server:get_default_options() or {})

        -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
        opts.capabilities = capabilities

        -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
        server:setup(opts)
        vim.cmd [[ do User LspAttachBuffers ]]
      end)

      -- Ensure lsp servers
      local lsp_installer_servers = require'nvim-lsp-installer.servers'
      for lsp, lsp_config in pairs(lsp_configs.servers) do
        local ok, lsp_server = lsp_installer_servers.get_server(lsp)
        if ok then
          if not lsp_server:is_installed() then
            lsp_server:install()
          end
        else
          -- Maybe lsp_installer not supported language server, but already installed
          -- TODO: use other attribute to record name
          if vim.fn.executable(lsp) then
            -- TODO: Reduce duplication
            local cmp_lsp_config = vim.deepcopy(lsp_config or {})

            -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
            cmp_lsp_config.capabilities = capabilities

            require'lspconfig'[lsp].setup(cmp_lsp_config)
            vim.cmd [[ do User LspAttachBuffers ]]
          end
        end
      end
    end
  }
  use {
    'tami5/lspsaga.nvim',
    config = function()
      require'lspsaga'.setup{}

      nnoremap('gd', '<Cmd>Lspsaga lsp_finder<CR>', 'silent')
      nnoremap('gi', '<Cmd>Lspsaga implement<CR>', 'silent')
      nnoremap('gp', '<Cmd>Lspsaga preview_definition<CR>', 'silent')
      nnoremap('gy', '<Cmd>Lspsaga signature_help<CR>', 'silent')
      nnoremap('gr', '<Cmd>Lspsaga rename<CR>', 'silent')
      nnoremap('gx', '<Cmd>Lspsaga code_action<CR>', 'silent')
      xnoremap('gx', ':<C-U>Lspsaga range_code_action<CR>', 'silent')
      nnoremap('K',  "<Cmd>lua require('vimrc.plugins.lspsaga').show_doc()<CR>", 'silent')
      nnoremap('go', '<Cmd>Lspsaga show_line_diagnostics<CR>', 'silent')
      nnoremap('gC', '<Cmd>Lspsaga show_cursor_dianostics<CR>', 'silent')
      nnoremap(']c', '<Cmd>Lspsaga diagnostic_jump_next<CR>', 'silent')
      nnoremap('[c', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', 'silent')
      nnoremap('<C-U>', "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>")
      nnoremap('<C-D>', "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>")
    end
  } 

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
