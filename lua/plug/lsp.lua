local plugin_utils = require("vimrc.plugin_utils")

local lsp = {}

lsp.startup = function(use)
  -- Language Server Protocol
  use({
    "neovim/nvim-lspconfig",
    config = function()
      require("vimrc.lsp").setup({})
    end,
  })

  use({
    "williamboman/nvim-lsp-installer",
    config = function()
      local lsp_installer = require("nvim-lsp-installer")
      local lsp_configs = require("vimrc.lsp")

      -- TODO: Add ensure_installed
      lsp_installer.setup({
        automatic_installation = true,
      })

      -- Setup lsp servers
      -- TODO: Lazy load lsp on ft?
      local lsp_installer_servers = require("nvim-lsp-installer.servers")
      for server_name, _ in pairs(lsp_configs.get_servers()) do
        local ok, lsp_server = lsp_installer_servers.get_server(server_name)
        if ok then
          lsp_configs.setup_server(lsp_server.name, lsp_server:get_default_options())
        end

        -- nvim-lsp-installer unsupported servers or install failed servers
        if not ok or not lsp_server:is_installed() then
          -- Maybe lsp_installer not supported language server, but already installed
          -- TODO: use other attribute to record name
          if vim.fn.executable(server_name) then
            lsp_configs.setup_server(server_name, {})
          end
        end
      end
    end,
  })

  use("ii14/lsp-command")

  -- TODO: Use glepnir/lspsaga.nvim
  -- Currently not changed due to CursorLine highlight overridden after :Lspsaga lsp_finder
  -- Currently, glepnir/lspsaga.nvim cannot handle lsp that still response old SymbolInformation
  use({
    "tami5/lspsaga.nvim",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      require("lspsaga").setup({
        code_action_prompt = {
          enable = true,
          sign = true,
          sign_priority = 40,
          virtual_text = false,
        },
      })
    end,
  })

  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    cmd = { "Trouble", "TroubleToggle" },
    keys = { "<Space>xx", "<Space>xw", "<Space>xd", "<Space>xq", "<Space>xl", "<Space>xr" },
    config = function()
      require("trouble").setup({})

      local opts = { noremap = true, silent = true }

      vim.keymap.set("n", "<Space>xx", "<Cmd>TroubleToggle<CR>", opts)
      vim.keymap.set("n", "<Space>xw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", opts)
      vim.keymap.set("n", "<Space>xd", "<Cmd>TroubleToggle document_diagnostics<CR>", opts)
      vim.keymap.set("n", "<Space>xq", "<Cmd>TroubleToggle quickfix<CR>", opts)
      vim.keymap.set("n", "<Space>xl", "<Cmd>TroubleToggle loclist<CR>", opts)
      vim.keymap.set("n", "<Space>xr", "<Cmd>TroubleToggle lsp_references<CR>", opts)

      -- jump to the next item, skipping the groups
      vim.keymap.set("n", "]g", [[<Cmd>lua require("trouble").next({ skip_groups = true, jump = true })<CR>]], opts)

      -- jump to the previous item, skipping the groups
      vim.keymap.set("n", "[g", [[<Cmd>lua require("trouble").previous({ skip_groups = true, jump = true })<CR>]], opts)
    end,
  })

  -- TODO: null-ls.nvim cause performance problem, need to find a way to fix this
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local null_ls = require("null-ls")
      local utils = require("vimrc.utils")

      -- Skip null-ls.nvim in light vim mode
      if utils.is_light_vim_mode() then
        return
      end

      null_ls.setup({
        sources = {
          -- Code Action sources
          -- NOTE: use eslint_d instead
          -- null_ls.builtins.code_actions.eslint.with({
          --   condition = function()
          --     return vim.fn.executable("eslint") > 0
          --   end,
          -- }),
          -- null_ls.builtins.code_actions.eslint_d.with({
          --   condition = function()
          --     return vim.fn.executable("eslint_d") > 0
          --   end,
          -- }),
          -- NOTE: disabled for performance
          -- null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.code_actions.shellcheck.with({
            condition = function()
              return vim.fn.executable("shellcheck") > 0
            end,
          }),

          -- Diagnostic sources
          -- NOTE: use eslint_d instead
          -- null_ls.builtins.diagnostics.eslint.with({
          --   condition = function()
          --     return vim.fn.executable("eslint") > 0
          --   end,
          -- }),
          -- null_ls.builtins.diagnostics.eslint_d.with({
          --   condition = function()
          --     return vim.fn.executable("eslint_d") > 0
          --   end,
          --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          -- }),
          -- NOTE: use pylsp pyls-flake8
          -- null_ls.builtins.diagnostics.flake8.with({
          --   condition = function()
          --     return vim.fn.executable("flake8") > 0
          --   end,
          -- }),
          -- NOTE: Disabled as normal workflow will save & quit when writing git commit message
          -- null_ls.builtins.diagnostics.gitlint.with({
          --   condition = function()
          --     return vim.fn.executable("gitlint") > 0
          --   end,
          --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          -- }),
          -- TODO: pylint is slow with lsp linting, disabled for now
          -- TODO: should use nvim-lint or other on-demand linting plugin to lint pylint
          -- null_ls.builtins.diagnostics.pylint.with({
          --   condition = function()
          --     return vim.fn.executable('pylint') > 0
          --   end
          -- }),
          -- NOTE: use nvim-lint to lint
          -- null_ls.builtins.diagnostics.shellcheck.with({
          --   condition = function()
          --     return vim.fn.executable("shellcheck") > 0
          --   end,
          -- }),
          null_ls.builtins.diagnostics.standardrb.with({
            condition = function()
              return vim.fn.executable("standardrb") > 0
            end,
          }),
          null_ls.builtins.diagnostics.vint.with({
            condition = function()
              return vim.fn.executable("vint") > 0
            end,
          }),

          -- Formatting sources
          -- NOTE: use pylsp python-lsp-black
          -- null_ls.builtins.formatting.black.with({
          --   condition = function()
          --     return vim.fn.executable("black") > 0
          --   end,
          -- }),
          -- NOTE: use clangd clang-format
          -- null_ls.builtins.formatting.clang_format.with({
          --   condition = function()
          --     return vim.fn.executable("clang-format") > 0
          --   end,
          -- }),
          -- NOTE: use eslint_d instead
          -- null_ls.builtins.formatting.eslint.with({
          --   condition = function()
          --     return vim.fn.executable("eslint") > 0
          --   end,
          -- }),
          -- null_ls.builtins.formatting.eslint_d.with({
          --   condition = function()
          --     return vim.fn.executable("eslint_d") > 0
          --   end,
          -- }),
          null_ls.builtins.formatting.json_tool.with({
            condition = function()
              return vim.fn.executable("json.tool") > 0
            end,
          }),
          null_ls.builtins.formatting.lua_format.with({
            condition = function()
              return vim.fn.executable("lua-format") > 0
            end,
          }),
          -- NOTE: use prettierd instead
          -- null_ls.builtins.formatting.prettier.with({
          --   condition = function()
          --     return vim.fn.executable("prettier") > 0
          --   end,
          -- }),
          null_ls.builtins.formatting.prettierd.with({
            condition = function()
              return vim.fn.executable("prettierd") > 0
            end,
          }),
          null_ls.builtins.formatting.rustfmt.with({
            condition = function()
              return vim.fn.executable("rustfmt") > 0
            end,
          }),
          null_ls.builtins.formatting.shfmt.with({
            condition = function()
              return vim.fn.executable("shfmt") > 0
            end,
          }),
          null_ls.builtins.formatting.standardrb.with({
            condition = function()
              return vim.fn.executable("standardrb") > 0
            end,
          }),
          null_ls.builtins.formatting.stylua.with({
            condition = function()
              return vim.fn.executable("stylua") > 0
            end,
          }),

          -- Hover sources
        },
        on_attach = require("vimrc.lsp").on_attach,
      })
    end,
  })

  use({
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")

      -- Custom linters
      lint.linters.gitlint = {
        cmd = "gitlint",
        stdin = true,
        args = { "--msg-filename", "-" },
        stream = "stderr",
        ignore_exitcode = true,
        env = nil,
        parser = require("lint.parser").from_pattern([[(%d+): (%w+) (.+)]], { "lnum", "code", "message" }),
      }

      -- Setup linter
      -- TODO: Check for executable
      lint.linters_by_ft = {
        python = { "mypy", "pylint" },
        gitcommit = { "gitlint" },
        sh = { "shellcheck" },
      }

      nnoremap("<Space>ll", "<Cmd>lua require('lint').try_lint()<CR>", "silent")

      vim.cmd([[augroup nvim_lint_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd BufWritePost * lua require('lint').try_lint()]])
      vim.cmd([[augroup END]])
    end,
  })

  -- NOTE: Used in light vim mode when null-ls.nvim is disabled
  use({
    "mhartington/formatter.nvim",
    config = function()
      local plugin_utils = require("vimrc.plugin_utils")

      require("formatter").setup({
        filetype = {
          markdown = {
            plugin_utils.check_executable(require("formatter.defaults.prettierd"), "prettierd"),
          },
        },
      })

      nnoremap("<Leader>f", "<Cmd>Format<CR>", "silent")
    end,
  })

  if plugin_utils.is_enabled_plugin("lsp-status") then
    use({
      "nvim-lua/lsp-status.nvim",
      config = function()
        local lsp_status = require("lsp-status")

        lsp_status.config({
          diagnostics = false,
        })
      end,
    })
  end

  if plugin_utils.is_enabled_plugin("nvim-navic") then
    use({
      "SmiteshP/nvim-navic",
      requires = "neovim/nvim-lspconfig",
      config = function()
        require("nvim-navic").setup({})
      end,
    })
  end

  use({
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup({})
    end,
  })

  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  })

  -- Goto Definitions
  -- NOTE: Has symbol preview
  use({
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },
    keys = { "<F7>" },
    config = function()
      nnoremap("<F7>", [[<Cmd>SymbolsOutline<CR>]])
    end,
  })
  -- NOTE: Support treesitter
  -- TODO: Cannot lazy load due to lsp attach
  use({
    "stevearc/aerial.nvim",
    config = function()
      local plugin_utils = require("vimrc.plugin_utils")

      require("aerial").setup({
        backends = vim.tbl_filter(function(backend)
          return backend ~= nil
        end, {
          "lsp",
          plugin_utils.check_enabled_plugin("treesitter", "nvim-treesitter"),
          "markdown",
        }),
        filter_kind = {
          "Class",
          "Constructor",
          "Enum",
          "Function",
          "Interface",
          "Module",
          "Method",
          "Struct",
          -- "Variable",
        },
        width = vim.g.right_sidebar_width,
        on_attach = function(bufnr)
          -- Toggle the aerial window with <Space><F7>
          nnoremap("<Space><F7>", [[<Cmd>AerialToggle!<CR>]], "silent", "buffer")
          -- Jump forwards/backwards with '{' and '}'
          nnoremap("{", [[<Cmd>AerialPrev<CR>]], "silent", "buffer")
          nnoremap("}", [[<Cmd>AerialNext<CR>]], "silent", "buffer")
          -- Jump up the tree with '[[' or ']]'
          nnoremap("[[", [[<Cmd>AerialPrevUp<CR>]], "silent", "buffer")
          nnoremap("]]", [[<Cmd>AerialNextUp<CR>]], "silent", "buffer")
        end,
      })

      require("telescope").load_extension("aerial")
    end,
  })

  -- Specific LSP Support
  use({
    "simrat39/rust-tools.nvim",
    config = function()
      require("rust-tools").setup({})
    end,
  })
  use({ "jose-elias-alvarez/nvim-lsp-ts-utils" })

  -- Fold
  -- TODO: Check if folding not work in vimwiki
  -- TODO: Find a better place for fold
  -- There's several place for fold settings:
  -- 1. Here for nvim-ufo
  -- 2. vimwiki.vim for vimwiki specific config
  use({
    "kevinhwang91/nvim-ufo",
    requires = "kevinhwang91/promise-async",
    config = function()
      local ufo = require("ufo")
      local my_ufo = require("vimrc.plugins.ufo")

      -- TODO: Display fold symbol in foldcolumn
      -- Ref: https://github.com/kevinhwang91/nvim-ufo/issues/4#issuecomment-1157716294
      vim.wo.foldcolumn = "0"
      vim.wo.foldlevel = 99 -- feel free to decrease the value
      vim.wo.foldenable = true
      vim.o.foldlevelstart = 99

      nnoremap("<F10>", function()
        my_ufo.toggle_treesitter()
      end)

      ufo.setup({
        fold_virt_text_handler = my_ufo.fold_virt_text_handler,
        provider_selector = my_ufo.provider_selector,
      })
    end,
  })
end

return lsp
