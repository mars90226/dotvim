local plugin_utils = require("vimrc.plugin_utils")

local utility = {}

utility.startup = function(use)
  local use_builtin = function(plugin_spec)
    plugin_utils.use_builtin(use, plugin_spec)
  end

  -- Undo Tree
  use({
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
    keys = { "<F9>" },
    config = function()
      nnoremap("<F9>", ":UndotreeToggle<CR>")
    end,
  })
  -- NOTE: vim-mundo is slow, but featureful
  use({
    "simnalamburt/vim-mundo",
    cmd = { "MundoToggle" },
    keys = { "<Space><F9>" },
    config = function()
      if vim.fn.has("python3") == 1 then
        vim.g.mundo_prefer_python3 = 1
      end

      nnoremap("<Space><F9>", ":MundoToggle<CR>")
    end,
  })

  use({
    "tpope/vim-unimpaired",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    setup = function()
      vim.g.nremap = {
        -- url encode/decode
        ["[u"] = [[\[u]],
        ["]u"] = [[\]u]],
        ["[uu"] = [[\[uu]],
        ["]uu"] = [[\]uu]],

        -- xml encode/decode
        ["[x"] = [[\[x]],
        ["]x"] = [[\]x]],
        ["[xx"] = [[\[xx]],
        ["]xx"] = [[\]xx]],
      }
    end,
    config = function()
      local utils = require("vimrc.utils")

      nnoremap("coc", ":set termguicolors!<CR>")
      nnoremap("coe", ":set expandtab!<CR>")
      nnoremap("com", ":set modifiable!<CR>")
      nnoremap("coo", ":set readonly!<CR>")
      nnoremap("cop", ":set paste!<CR>")
      nnoremap("yoa", ":setlocal autoread!<CR>")

      vim.keymap.set("n", "codh", function()
        utils.toggle_list_option_flag(vim.opt.diffopt, "algorithm:histogram")
      end, { noremap = true })
    end,
  })

  use({
    "tpope/vim-characterize",
    keys = { "gA" },
    config = function()
      nmap("gA", "<Plug>(characterize)")
    end,
  })

  -- Registers
  use({
    "tversteeg/registers.nvim",
  })

  -- Colors
  -- TODO: Change ColorV global leader to avoid key mapping conflict
  use({
    "gu-fan/colorv.vim",
    cmd = { "ColorV", "ColorVName", "ColorVView" },
    keys = { "<Leader>vv", "<Leader>vn", "<Leader>vw" },
    requires = { "mattn/webapi-vim" },
    config = function()
      nnoremap("<Leader>vv", ":ColorV<CR>", "silent")
      nnoremap("<Leader>vn", ":ColorVName<CR>", "silent")
      nnoremap("<Leader>vw", ":ColorVView<CR>", "silent")
    end,
  })
  use({
    "max397574/colortils.nvim",
    cmd = { "Colortils" },
    keys = { "<Leader>ct" },
    config = function()
      require("colortils").setup({
        mappings = {
          replace_default_format = "<M-CR>",
          replace_choose_format = "g<M-CR>",
        },
      })

      nnoremap("<Leader>ct", [[<Cmd>Colortils picker black<CR>]])
      xnoremap("<Leader>ct", [[:<C-U>execute 'Colortils picker '..vimrc#utility#get_visual_selection()<CR>]])
    end,
  })

  -- Project
  use({
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        ignore_lsp = { "null-ls" },

        -- What scope to change the directory, valid options are
        -- * global (default)
        -- * tab
        -- * win
        scope_chdir = 'win',
      })
      require("telescope").load_extension("projects")

      nnoremap("<Leader>r", "<Cmd>ProjectRoot<CR>")
    end,
  })

  -- Note Taking
  use({
    "vimwiki/vimwiki",
    branch = "dev",
    ft = { "vimwiki", "todo" }, -- NOTE: Add custom todo filetype
    setup = function()
      -- disable vimwiki on markdown file
      vim.g.vimwiki_ext2syntax = { [".wiki"] = "default" }
      -- disable <Tab> & <S-Tab> mappings in insert mode
      vim.g.vimwiki_key_mappings = { lists_return = 1, table_mappings = 0 }
      -- Toggle after vim
      vim.g.vimwiki_folding = "expr:quick"

      -- NOTE: For lazy load vimwiki as it doesn't use ftdetect
      vim.cmd([[augroup vimwiki_filetypedetect]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd BufRead,BufNewFile *.wiki setfiletype vimwiki]])
      vim.cmd([[augroup END]])
    end,
    config = function()
      vim.cmd([[command! VimwikiToggleFolding    call vimrc#vimwiki#toggle_folding()]])
      vim.cmd([[command! VimwikiToggleAllFolding call vimrc#vimwiki#toggle_all_folding()]])
      vim.cmd([[command! VimwikiManualFolding    call vimrc#vimwiki#manual_folding()]])
      vim.cmd([[command! VimwikiManualAllFolding call vimrc#vimwiki#manual_all_folding()]])
      vim.cmd([[command! VimwikiExprFolding      call vimrc#vimwiki#expr_folding()]])
      vim.cmd([[command! VimwikiExprAllFolding   call vimrc#vimwiki#expr_all_folding()]])

      vim.cmd([[augroup vimwiki_settings]])
      vim.cmd([[  autocmd!]])
      -- TODO: Need to check if this is needed
      vim.cmd([[  autocmd VimEnter *.wiki  VimwikiManualAllFolding]])
      vim.cmd([[augroup END]])
    end,
  })

  -- NOTE: require nvim-treesitter
  use({
    "nvim-neorg/neorg",
    ft = { "norg" },
    cmd = { "Neorg" },
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neorg").setup({
        -- Tell Neorg what modules to load
        load = {
          ["core.defaults"] = {}, -- Load all the default modules
          ["core.norg.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.norg.concealer"] = {}, -- Allows for use of icons
          ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
              workspaces = {
                my_workspace = "~/neorg",
                -- TODO: Wait for gtd config
                -- gtd = "~/gtd",
              },
            },
          },
          ["core.norg.qol.toc"] = {},
          -- TODO: Need to create workspace folder first
          -- ["core.gtd.base"] = {
          --   config = {
          --     workspace = "~/gtd",
          --   },
          -- },
        },
      })

      -- TODO: Add check for nvim-treesitter, and disable treesitter module
      require("nvim-treesitter.install").ensure_installed({
        "norg",
        "norg_meta",
        "norg_table",
      })
    end,
  })

  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      -- Currently, there's no way to differentiate tab and space.
      -- The only way to differentiate is to disable indent-blankline.nvim
      -- temporarily.
      nnoremap("<Space>il", ":IndentBlanklineToggle<CR>")
      nnoremap("<Space>ir", ":IndentBlanklineRefresh<CR>")

      require("indent_blankline").setup({
        char = "│",
        show_end_of_line = true,
        filetype_exclude = {
          "any-jump",
          "defx",
          "help",
          "fugitive",
          "git",
          "gitcommit",
          "gitrebase",
          "gitsendemail",
          "man",
          "norg",
        },
        buftype_exclude = { "nofile", "terminal" },
        show_current_context = true,
        show_current_context_start = true,
      })
    end,
  })

  use({
    "powerman/vim-plugin-AnsiEsc",
    cmd = { "AnsiEsc" },
    keys = { "coa" },
    config = function()
      nnoremap("coa", ":AnsiEsc<CR>")
    end,
  })

  use({
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help", "terminal" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = false,
      })
    end,
  })

  use({
    "embear/vim-localvimrc",
    config = function()
      -- NOTE: Avoid lazy load error with upvalues (captured values)
      local utils = require("vimrc.utils")

      -- Be careful of malicious localvimrc
      vim.g.localvimrc_sandbox = 0

      vim.g.localvimrc_whitelist = {
        vim.env.HOME .. "/.vim",
        vim.env.HOME .. "/.tmux",
        vim.env.HOME .. "/test",
      }

      if vim.g.localvimrc_secret_whitelist ~= nil then
        vim.g.localvimrc_whitelist = utils.table_concat(vim.g.localvimrc_whitelist, vim.g.localvimrc_secret_whitelist)
      end

      if vim.g.localvimrc_local_whitelist ~= nil then
        vim.g.localvimrc_whitelist = utils.table_concat(vim.g.localvimrc_whitelist, vim.g.localvimrc_local_whitelist)
      end
    end,
  })

  use({ "kevinhwang91/nvim-bqf", ft = { "qf" } })

  use({ "thinca/vim-qfreplace", ft = { "qf" } })

  use({
    "romainl/vim-qf",
    ft = { "qf" },
    config = function()
      -- Don't auto open quickfix list because it make vim-dispatch not able to
      -- restore 'makeprg' after make.
      -- https://github.com/tpope/vim-dispatch/issues/254
      vim.g.qf_auto_open_quickfix = 0
    end,
  })

  use({
    "arthurxavierx/vim-caser",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
  })

  -- Focus
  use({
    "Pocco81/true-zen.nvim",
    cmd = { "TZAtaraxis", "TZFocus", "TZMinimalist", "TZNarrow", "TZForCopy" },
    keys = { "<Leader>za", "<Leader>zc", "<Leader>zm", "<Leader>zn", "<Leader>zM" },
    config = function()
      nnoremap("<Leader>za", [[<Cmd>TZAtaraxis<CR>]])
      nnoremap("<Leader>zc", [[<Cmd>TZFocus<CR>]])
      nnoremap("<Leader>zm", [[<Cmd>TZMinimalist<CR>]])
      nnoremap("<Leader>zn", [[<Cmd>TZNarrow<CR>]])
      xnoremap("<Leader>zn", [[:'<,'>TZNarrow<CR>]])

      vim.api.nvim_create_user_command("TZForCopy", function()
        vim.wo.list = not vim.wo.list
        require("vimrc.lsp").toggle_show_diagnostics()
        vim.cmd([[IndentBlanklineToggle]])
        vim.cmd([[TZMinimalist]])
      end, {})
      nnoremap("<Leader>zM", [[<Cmd>TZForCopy<CR>]])
    end,
  })

  use({
    "folke/twilight.nvim",
    cmd = { "Twilight" },
    keys = { "<Leader><C-L>" },
    config = function()
      require("twilight").setup({})

      nnoremap("<Leader><C-L>", ":Twilight<CR>")
    end,
  })

  use({
    "tpope/vim-dispatch",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      -- TODO Check if disabling tmux is good
      -- As currently, it break tmux zoom.
      -- But using Job makes closing vim while git push failed
      vim.g.dispatch_no_tmux_make = 1

      -- Mappings
      nnoremap("<Leader>dq", [[<Cmd>Copen<CR>]])
    end,
  })

  -- See https://www.reddit.com/r/vim/comments/bwp7q3/code_execution_vulnerability_in_vim_811365_and/
  -- and https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md for more details
  use("ciaranm/securemodelines")

  -- Do not lazy load vim-scriptease, as it breaks :Breakadd/:Breakdel
  -- TODO: Check if lazy load works
  use({ "tpope/vim-scriptease", cmd = { "PP", "Messages", "Verbose", "Time" } })

  use("tyru/open-browser.vim")

  -- Colorizer
  use({
    "NvChad/nvim-colorizer.lua",
    config = function()
      vim.go.termguicolors = true

      require("colorizer").setup({
        filetypes = {
          "*",
          css = { css = true },
          scss = { css = true },
        },
        user_default_options = {
          names = false,
        },
      })
    end,
  })

  use({
    "lambdalisue/suda.vim",
    cmd = { "SudaRead", "SudaWrite" },
  })

  -- Window Layout
  use({
    "simeji/winresizer",
    cmd = { "WinResizerStartResize" },
    keys = { "<Leader>R" },
    setup = function()
      vim.g.winresizer_start_key = "<Leader>R"
    end,
  })
  use({
    "sindrets/winshift.nvim",
    cmd = { "WinShift" },
    keys = { "<C-W><C-M>", "<C-W>m", "<C-W>X" },
    config = function()
      require("winshift").setup({})

      nnoremap("<C-W><C-M>", [[<Cmd>WinShift<CR>]])
      nnoremap("<C-W>m", [[<Cmd>WinShift<CR>]])
      nnoremap("<C-W>X", [[<Cmd>WinShift swap<CR>]])
    end,
  })

  use({
    "folke/todo-comments.nvim",
    requires = { "nvim-lua/plenary.nvim", "folke/todo-comments.nvim" },
    config = function()
      require("todo-comments").setup({})

      nnoremap("<F8>", "<Cmd>TodoTrouble<CR>")
      nnoremap("<Space><F8>", "<Cmd>TodoTelescope<CR>")
      nnoremap("[x", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment"})
      nnoremap("]x", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment"})
    end,
  })

  -- NOTE: stabilize.nvim is merged into neovim 0.9.0 as `splitkeep` option
  -- Ref: https://github.com/neovim/neovim/pull/19243
  -- TODO: Enable `splitkeep` option when upgrading to neovim 0.9.0

  use({
    "antoinemadec/FixCursorHold.nvim",
    config = function()
      vim.go.updatetime = 4000 -- default
      vim.g.cursorhold_updatetime = 300
    end,
  })

  -- Cmdline
  use({
    "VonHeikemen/fine-cmdline.nvim",
    requires = { { "MunifTanjim/nui.nvim" } },
    cmd = { "FineCmdline" },
    keys = { "<C-P>" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local my_fine_cmdline = require("vimrc.plugins.fine-cmdline")

      -- TODO: Check if tab variable is needed
      local related_bufnr = 0

      require("fine-cmdline").setup({
        popup = {
          buf_options = {
            ft = "fine-cmdline",
          },
        },
        hooks = {
          before_mount = function(_)
            my_fine_cmdline.set_related_bufnr(vim.api.nvim_get_current_buf())
          end,
          set_keymaps = function(imap, feedkeys)
            -- TODO: Refactor
            local max_buffer_size = 1024 * 1024 -- 1 Megabyte max

            local buffer_source = {
              name = "buffer",
              option = {
                get_bufnrs = function()
                  local buf = my_fine_cmdline.get_related_bufnr()
                  local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                  if byte_size > max_buffer_size then
                    return {}
                  end
                  return { buf }
                end,
              },
            }

            -- NOTE: cmp-cmdline seems not working in insert mode
            cmp.setup.buffer({
              sources = cmp.config.sources({
                { name = "path" },
                { name = "luasnip" },
              }, {
                buffer_source,
              }),
              -- NOTE: Use native_menu to make cmp.visible() work.
              -- As cmp custom menu will draw outside of fine-line and is considered not "visible"?
              view = {
                entries = "native",
              },
            })

            -- Ref: cmp.mapping.preset.cmdline without fallback
            local keymaps = {
              -- nvim-cmp
              -- NOTE: Use <C-/> & <M-/> to trigger cmp to preserve fine-cmdline original completion
              -- <C-_> for <C-/>
              ["<C-_>"] = function()
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  cmp.complete()
                end
              end,
              ["<M-/>"] = function()
                if cmp.visible() then
                  cmp.select_prev_item()
                end
              end,
              ["<C-E>"] = function()
                if not cmp.close() then
                  feedkeys("<C-E>")
                end
              end,

              -- LuaSnip
              ["<C-J>"] = function()
                if luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                end
              end,
              ["<C-K>"] = function()
                if luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                end
              end,
              ["<M-j>"] = function()
                if luasnip.choice_active() then
                  luasnip.change_choice(1)
                end
              end,
              ["<M-k>"] = function()
                if luasnip.choice_active() then
                  luasnip.change_choice(-1)
                end
              end,
            }

            for key, mapping in pairs(keymaps) do
              imap(key, mapping)
            end
          end,
        },
      })

      nnoremap("<C-P>", [[<Cmd>lua require('fine-cmdline').open()<CR>]])
    end,
  })

  use({
    "hoschi/yode-nvim",
    keys = { "<Leader>yc", "<Leader>yr" },
    config = function()
      require("yode-nvim").setup({})

      noremap("<Leader>yc", [[:YodeCreateSeditorFloating<CR>]])
      noremap("<Leader>yr", [[:YodeCreateSeditorReplace<CR>]])
      nnoremap("<Leader>bd", [[:YodeBufferDelete<CR>]])

      nnoremap("<C-W>r", [[<Cmd>YodeLayoutShiftWinDown<CR>]])
      nnoremap("<C-W>R", [[<Cmd>YodeLayoutShiftWinUp<CR>]])
      nnoremap("<C-W>J", [[<Cmd>YodeLayoutShiftWinBottom<CR>]])
      nnoremap("<C-W>K", [[<Cmd>YodeLayoutShiftWinTop<CR>]])

      -- For no gap between floating windows
      vim.go.showtabline = 2
    end,
  })

  use({
    "bennypowers/nvim-regexplainer",
    cmd = { "RegexplainerToggle" },
    keys = { "<Leader>er" },
    requires = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("regexplainer").setup({
        mappings = {
          toggle = "<Leader>er",
        },
      })
    end,
  })

  use({
    "axieax/urlview.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      local urlview = require("vimrc.plugins.urlview")
      local has_secret_urlview, secret_urlview = pcall(require, "secret.urlview")

      require("urlview").setup({
        default_action = vim.fn["vimrc#plugin#check#has_ssh_host_client"]() and "client_open_browser" or "system",
      })
      urlview.setup()

      if has_secret_urlview then
        secret_urlview.setup()
      end

      nnoremap("<Leader>uu", [[<Cmd>UrlView buffer picker=telescope<CR>]], { desc = "view buffer URLs" })
      nnoremap("<Leader>up", [[<Cmd>UrlView packer picker=telescope<CR>]], { desc = "view plugin URLs" })
    end,
  })

  if vim.fn.executable("jq") == 1 then
    use({ "gennaro-tedesco/nvim-jqx" })
  end

  -- Disabled by default, enable to profile
  -- Plug 'norcalli/profiler.nvim'

  use({
    "s1n7ax/nvim-window-picker",
    tag = "v1.*",
    config = function()
      require("window-picker").setup()
    end,
  })
  use({
    "lpinilla/vim-codepainter",
    keys = { "<Leader>cp", "<Leader>cn" },
    config = function()
      vim.g.codepainter_default_mappings = 0

      vnoremap("<Leader>cp", [[:<C-U>call codepainter#paintText(visualmode())<CR>]])
      nnoremap("<Leader>cp", [[:<C-U>call codepainter#paintText('')<CR>]])
      nnoremap("<Leader>cn", [[:<C-U>call codepainter#navigate()<CR>]])
    end,
  })

  -- Translate
  -- NOTE: Requires curl 7.76.0. Otherwise, curl do not understand `--fail-with-body` and return exit status 2
  -- TODO: Check for curl version
  use({
    "potamides/pantran.nvim",
    cmd = { "Pantran" },
    keys = { "<Leader>pt", "<Leader>ptt" },
    config = function()
      local pantran = require("pantran")

      pantran.setup({
        engines = {
          argos = {
            default_target = "zh",
          },
        },
      })

      local opts = { noremap = true, silent = true, expr = true }
      vim.keymap.set("n", "<Leader>pt", pantran.motion_translate, opts)
      vim.keymap.set("n", "<Leader>ptt", function()
        return pantran.motion_translate() .. "_"
      end, opts)
      vim.keymap.set("x", "<Leader>pt", pantran.motion_translate, opts)
    end,
  })
  use({
    "uga-rosa/translate.nvim",
    cmd = { "Translate" },
    keys = { "<Leader>tr" },
    config = function()
      require("translate").setup({})

      nnoremap("<Leader>tr", [[viw:Translate ZH-TW<CR>]])
      xnoremap("<Leader>tr", [[:Translate ZH-TW<CR>]])
    end,
  })

  use({
    "AndrewRadev/linediff.vim",
    cmd = { "Linediff" },
    keys = { "<M-d>l" },
    config = function()
      nnoremap("<M-d>l", [[V:Linediff<CR>]])
      xnoremap("<M-d>l", [[:Linediff<CR>]])
    end,
  })

  use({ "tpope/vim-dadbod", cmd = { "DB" } })
  use({ "tpope/vim-abolish", cmd = { "Abolish", "Subvert", "S" }, keys = { "cr" } })
  use({ "will133/vim-dirdiff", cmd = { "DirDiff" } })
  use({ "Shougo/vinarise.vim", cmd = { "Vinarise" } })
  use({ "alx741/vinfo", cmd = { "Vinfo" } })
  use("kopischke/vim-fetch")
  use({
    "Valloric/ListToggle",
    cmd = { "QToggle", "LToggle" },
    keys = { "<Leader>q", "<Leader>l" },
  })
  use("tpope/vim-eunuch")
  use({ "DougBeney/pickachu", cmd = { "Pick" } })
  use({ "tweekmonster/helpful.vim", cmd = { "HelpfulVersion" } })
  use({ "tweekmonster/startuptime.vim", cmd = { "StartupTime" } })
  use({ "gyim/vim-boxdraw", keys = { "+o", "+O", "+c", "+-", "+_" } })
  use("lambdalisue/reword.vim")
  use({ "nicwest/vim-http", cmd = { "Http", "Http!" } })
  use({ "kristijanhusak/vim-carbon-now-sh", cmd = { "CarbonNowSh" } })
  use({ "taybart/b64.nvim", cmd = { "B64Encode", "B64Decode" } })

  -- builtin Termdebug plugin
  use_builtin({
    "neovim/termdebug",
    cmd = { "Termdebug", "TermdebugCommand" },
    config = function()
      -- Mappings
      nnoremap("<Leader>dd", [[:Termdebug<Space>]])
      nnoremap("<Leader>dD", [[:TermdebugCommand<Space>]])

      nnoremap("<Leader>dr", [[:Run<Space>]])
      nnoremap("<Leader>da", [[:Arguments<Space>]])

      nnoremap("<Leader>db", [[<Cmd>Break<CR>]])
      nnoremap("<Leader>dC", [[<Cmd>Clear<CR>]])

      nnoremap("<Leader>ds", [[<Cmd>Step<CR>]])
      nnoremap("<Leader>do", [[<Cmd>Over<CR>]])
      nnoremap("<Leader>df", [[<Cmd>Finish<CR>]])
      nnoremap("<Leader>dc", [[<Cmd>Continue<CR>]])
      nnoremap("<Leader>dS", [[<Cmd>Stop<CR>]])

      -- `:Evaluate` evaluate cursor variable and show result in floating window
      -- which may not be large enough to contain all result
      nnoremap("<Leader>de", [[:Evaluate<Space>]])
      xnoremap("<Leader>de", [[<Cmd>Evaluate]])
      -- `:Evaluate variable` show result in echo
      nnoremap("<Leader>dk", [[<Cmd>execute 'Evaluate '.expand('<cword>')<CR>]])
      nnoremap("<Leader>dK", [[<Cmd>execute 'Evaluate '.expand('<cWORD>')<CR>]])

      nnoremap("<Leader>dg", [[<Cmd>Gdb<CR>]])
      nnoremap("<Leader>dp", [[<Cmd>Program<CR>]])
      nnoremap("<Leader>dO", [[<Cmd>Source<CR>]])

      nnoremap("<Leader>d,", [[<Cmd>call TermDebugSendCommand(input('Gdb command> '))<CR>]])
    end,
  })

  -- nvim-gdb
  -- Disabled for now as neovim's neovim_gdb.vim seems not exists
  -- if vim.fn.has("nvim") == 1 then
  -- use {'sakhnik/nvim-gdb', run = './install.sh'}
  -- end
end

return utility
