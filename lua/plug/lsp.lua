local choose = require("vimrc.choose")

local lsp = {}

lsp.startup = function(use)
  -- Language Server Protocol
  use({ "neovim/nvim-lspconfig" })
  use({
    "williamboman/mason.nvim",
    config = function()
      local lsp_configs = require("vimrc.lsp")

      require("mason").setup()
      require("mason-lspconfig").setup()

      -- Setup lsp servers
      lsp_configs.setup({})
    end,
  })
  use({
    "williamboman/mason-lspconfig.nvim",
    require = { "williamboman/mason.nvim" },
  })
  use({
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    require = { "williamboman/mason.nvim" },
  })
  use({
    "tamago324/nlsp-settings.nvim",
    config = function()
      require("nlspsettings").setup({
        config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
        local_settings_dir = ".nlsp-settings",
        local_settings_root_markers_fallback = { ".git" },
        append_default_schemas = true,
        loader = "json",
      })
    end,
  })

  use("ii14/lsp-command")

  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      local saga = require("lspsaga")
      local choose = require("vimrc.choose")

      saga.init_lsp_saga({
        code_action_lightbulb = {
          enable = true, -- NOTE: lspsaga will show error once when lsp not support codeAction
          sign = true,
          sign_priority = 20,
          virtual_text = false,
        },
        symbol_in_winbar = {
          enable = choose.is_enabled_plugin("lspsaga.nvim-winbar") and choose.is_enabled_plugin("lspsaga.nvim-context"),
          click_support = function(node, clicks, button, modifiers)
            -- To see all avaiable details: vim.pretty_print(node)
            local st = node.range.start
            local en = node.range["end"]
            if button == "l" then
              if clicks == 2 then
                -- double left click to do nothing
              else -- jump to node's starting line+char
                vim.fn.cursor(st.line + 1, st.character + 1)
              end
            elseif button == "r" then
              if modifiers == "s" then
                print("lspsaga") -- shift right click to print "lspsaga"
              end -- jump to node's ending line+char
              vim.fn.cursor(en.line + 1, en.character + 1)
            elseif button == "m" then
              -- middle click to visual select node
              vim.fn.cursor(st.line + 1, st.character + 1)
              vim.cmd("normal v")
              vim.fn.cursor(en.line + 1, en.character + 1)
            end
          end,
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
          -- NOTE: disabled for performance
          -- TODO: Check if there's way to toggle it?
          -- null_ls.builtins.code_actions.shellcheck.with({
          --   condition = function()
          --     return vim.fn.executable("shellcheck") > 0
          --   end,
          -- }),

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
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
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

      -- Customize built-in linter parameters
      require("lint.linters.shellcheck").args = {
        "-x",
        "--format",
        "json",
        "-",
      }

      -- Setup linter
      -- TODO: Check for executable
      lint.linters_by_ft = {
        gitcommit = { "gitlint" },
        javascript = { "jshint" },
        python = { "mypy", "pylint" },
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

  if choose.is_enabled_plugin("nvim-navic") then
    use({
      "SmiteshP/nvim-navic",
      requires = "neovim/nvim-lspconfig",
      config = function()
        require("nvim-navic").setup({
          highlight = true,
        })
      end,
    })
  end

  use({
    "rmagatti/goto-preview",
    module = "goto-preview",
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
      require("symbols-outline").setup({
        -- NOTE: Should colortheme plugin fix the highlight?
        -- Ref: https://github.com/simrat39/symbols-outline.nvim/issues/185#issuecomment-1312618041
        symbols = {
          File = { hl = "@text.uri" },
          Module = { hl = "@namespace" },
          Namespace = { hl = "@namespace" },
          Package = { hl = "@namespace" },
          Class = { hl = "@type" },
          Method = { hl = "@method" },
          Property = { hl = "@method" },
          Field = { hl = "@field" },
          Constructor = { hl = "@constructor" },
          Enum = { hl = "@type" },
          Interface = { hl = "@type" },
          Function = { hl = "@function" },
          Variable = { hl = "@constant" },
          Constant = { hl = "@constant" },
          String = { hl = "@string" },
          Number = { hl = "@number" },
          Boolean = { hl = "@boolean" },
          Array = { hl = "@constant" },
          Object = { hl = "@type" },
          Key = { hl = "@type" },
          Null = { hl = "@type" },
          EnumMember = { hl = "@field" },
          Struct = { hl = "@type" },
          Event = { hl = "@type" },
          Operator = { hl = "@operator" },
          TypeParameter = { hl = "@parameter" },
        },
      })

      nnoremap("<F7>", [[<Cmd>SymbolsOutline<CR>]])
    end,
  })

  -- Specific LSP Support
  use({
    "p00f/clangd_extensions.nvim",
    module = "clangd_extensions",
  })
  use({
    "simrat39/rust-tools.nvim",
    module = { "rust-tools" },
  })
  use({ "jose-elias-alvarez/nvim-lsp-ts-utils" })
  -- NOTE: Maybe a little slow?
  use({
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup({})
    end
  })

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
        open_fold_hl_timeout = 150,
        close_fold_kinds = { "imports", "comment" },
        fold_virt_text_handler = my_ufo.fold_virt_text_handler,
        provider_selector = my_ufo.provider_selector,
      })

      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          -- fallback to 'keywordprg'
          vim.api.nvim_feedkeys("K", "n", false)
        end
      end)

      -- Performance trick
      -- Ref: nvim_treesitter.lua performance trick
      local augroup_id = vim.api.nvim_create_augroup("nvim_ufo_settings", {})
      vim.api.nvim_create_autocmd({ "FocusGained" }, {
        group = augroup_id,
        pattern = "*",
        callback = function()
          vim.cmd([[UfoEnable]])
        end,
      })
      vim.api.nvim_create_autocmd({ "FocusLost" }, {
        group = augroup_id,
        pattern = "*",
        callback = function()
          vim.cmd([[UfoDisable]])
        end,
      })
    end,
  })
end

return lsp
