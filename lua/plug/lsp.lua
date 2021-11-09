local lsp = {}

lsp.startup = function(use)
  -- Language Server Protocol
  use {
    'neovim/nvim-lspconfig',
    config = function()
      nnoremap('<C-]>',     '<Cmd>lua vim.lsp.buf.definition()<CR>', 'silent')
      nnoremap('1gD',       '<Cmd>lua vim.lsp.buf.type_definition()<CR>', 'silent')
      nnoremap('gR',        '<Cmd>lua vim.lsp.buf.references()<CR>', 'silent')
      nnoremap('g0',        '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', 'silent')
      nnoremap('<Space>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', 'silent')

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
    event = 'VimEnter',
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
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup {}

      nnoremap('<Space>xx', '<Cmd>TroubleToggle<CR>', 'silent')
      nnoremap('<Space>xw', '<Cmd>TroubleToggle lsp_workspace_diagnostics<CR>', 'silent')
      nnoremap('<Space>xd', '<Cmd>TroubleToggle lsp_document_diagnostics<CR>', 'silent')
      nnoremap('<Space>xq', '<Cmd>TroubleToggle quickfix<CR>', 'silent')
      nnoremap('<Space>xl', '<Cmd>TroubleToggle loclist<CR>', 'silent')
      nnoremap('<Space>xr', '<Cmd>TroubleToggle lsp_references<CR>', 'silent')
    end
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      local null_ls = require('null-ls')

      null_ls.config({
        sources = {
          -- Code Action sources
          null_ls.builtins.code_actions.gitsigns,

          -- Diagnostic sources
          null_ls.builtins.diagnostics.eslint.with({
            condition = function()
              return vim.fn.executable('eslint') > 0
            end
          }),
          null_ls.builtins.diagnostics.flake8.with({
            condition = function()
              return vim.fn.executable('flake8') > 0
            end
          }),
          -- TODO: pylint is slow with lsp linting, disabled for now
          -- TODO: should use nvim-lint or other on-demand linting plugin to lint pylint
          -- null_ls.builtins.diagnostics.pylint.with({
          --   condition = function()
          --     return vim.fn.executable('pylint') > 0
          --   end
          -- }),
          null_ls.builtins.diagnostics.shellcheck.with({
            condition = function()
              return vim.fn.executable('shellcheck') > 0
            end
          }),
          null_ls.builtins.diagnostics.standardrb.with({
            condition = function()
              return vim.fn.executable('standardrb') > 0
            end
          }),
          null_ls.builtins.diagnostics.vint.with({
            condition = function()
              return vim.fn.executable('vint') > 0
            end
          }),

          -- Formatting sources
          null_ls.builtins.formatting.black.with({
            condition = function()
              return vim.fn.executable('black') > 0
            end
          }),
          null_ls.builtins.formatting.clang_format.with({
            condition = function()
              return vim.fn.executable('clang-format') > 0
            end
          }),
          null_ls.builtins.formatting.eslint.with({
            condition = function()
              return vim.fn.executable('eslint') > 0
            end
          }),
          null_ls.builtins.formatting.json_tool.with({
            condition = function()
              return vim.fn.executable('json.tool') > 0
            end
          }),
          null_ls.builtins.formatting.lua_format.with({
            condition = function()
              return vim.fn.executable('lua-format') > 0
            end
          }),
          null_ls.builtins.formatting.prettier.with({
            condition = function()
              return vim.fn.executable('prettier') > 0
            end
          }),
          null_ls.builtins.formatting.rustfmt.with({
            condition = function()
              return vim.fn.executable('rustfmt') > 0
            end
          }),
          null_ls.builtins.formatting.shfmt.with({
            condition = function()
              return vim.fn.executable('shfmt') > 0
            end
          }),
          null_ls.builtins.formatting.standardrb.with({
            condition = function()
              return vim.fn.executable('standardrb') > 0
            end
          }),

          -- Hover sources
        }
      })

      require('lspconfig')['null-ls'].setup({})
    end
  }
end

return lsp
