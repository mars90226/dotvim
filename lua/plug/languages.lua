local plugin_utils = require("vimrc.plugin_utils")

local languages = {}

languages.startup = function(use)
  -- filetype
  use({
    "sheerun/vim-polyglot",
    disable = true,
    setup = function()
      -- Avoid conflict with vim-go, must after vim-go loaded
      vim.g.polyglot_disabled = { "go" }
    end,
  })
  use({ "rust-lang/rust.vim", ft = { "rust" } })
  use({ "leafo/moonscript-vim", ft = { "moon" } })
  use({
    "plasticboy/vim-markdown",
    ft = { "markdown" },
    require = { "godlygeek/tabular" },
  })
  use({ "mtdl9/vim-log-highlighting", ft = { "log" } })
  use({ "ClockworkNet/vim-apparmor", ft = { "apparmor" } })
  use({ "chrisbra/csv.vim", ft = { "csv" } })

  -- Highlighing
  -- nvim-treesitter
  if plugin_utils.is_enabled_plugin("nvim-treesitter") then
    use({
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("vimrc.plugins.nvim_treesitter")
      end,
    })
    use("nvim-treesitter/nvim-treesitter-refactor")
    use("nvim-treesitter/nvim-treesitter-textobjects")
    use("nvim-treesitter/playground")
    use("JoosepAlviste/nvim-ts-context-commentstring")
    -- TODO: Rename to 'mfussenegger/nvim-treehopper'
    use("mfussenegger/nvim-ts-hint-textobject")
    use("RRethy/nvim-treesitter-textsubjects")
    use({
      "lewis6991/spellsitter.nvim",
      config = function()
        require("spellsitter").setup()
      end,
    })
    use({
      "m-demare/hlargs.nvim",
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("hlargs").setup()
      end,
    })
    use({
      "ziontee113/syntax-tree-surfer",
      config = function()
        require("syntax-tree-surfer").setup({})

        -- Normal Mode Swapping:
        -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
        vim.keymap.set("n", "vU", function()
          vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
          return "g@l"
        end, { silent = true, expr = true })
        vim.keymap.set("n", "vD", function()
          vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
          return "g@l"
        end, { silent = true, expr = true })

        -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
        vim.keymap.set("n", "vd", function()
          vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
          return "g@l"
        end, { silent = true, expr = true })
        vim.keymap.set("n", "vu", function()
          vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
          return "g@l"
        end, { silent = true, expr = true })

        -- Visual Selection from Normal Mode
        nnoremap("vx", [[<Cmd>STSSelectMasterNode<CR>]], "silent")
        nnoremap("vn", [[<Cmd>STSSelectCurrentNode<CR>]], "silent")

        -- Select Nodes in Visual Mode
        xnoremap("<M-j>", [[<Cmd>STSSelectNextSiblingNode<CR>]], "silent")
        xnoremap("<M-k>", [[<Cmd>STSSelectPrevSiblingNode<CR>]], "silent")
        xnoremap("<M-h>", [[<Cmd>STSSelectParentNode<CR>]], "silent")
        xnoremap("<M-l>", [[<Cmd>STSSelectChildNode<CR>]], "silent")

        -- Swapping Nodes in Visual Mode
        xnoremap("<M-S-j>", [[<Cmd>STSSwapNextVisual<CR>]], "silent")
        xnoremap("<M-S-k>", [[<Cmd>STSSwapPrevVisual<CR>]], "silent")

        -- Targeted jump
        nnoremap(
          "<M-e>i",
          [[<Cmd>lua require("syntax-tree-surfer").targeted_jump({"string","number","true","false"})<CR>]]
        )

        -- filtered jump
        nnoremap("<M-S-n>", [[<Cmd>lua require("syntax-tree-surfer").filtered_jump("default", true)<CR>]], "silent")
        nnoremap("<M-S-p>", [[<Cmd>lua require("syntax-tree-surfer").filtered_jump("default", false)<CR>]], "silent")
      end,
    })
    use({
      "yioneko/nvim-yati",
      requires = "nvim-treesitter/nvim-treesitter",
    })
  end

  -- TODO: Check if this can be replaced by vim.lsp.buf.document_highlight()
  -- ref: :help vim.lsp.buf.document_highlight()
  use("jackguo380/vim-lsp-cxx-highlight")

  -- Context
  if plugin_utils.is_enabled_plugin("nvim-treesitter") then
    use({
      "nvim-treesitter/nvim-treesitter-context",
      config = function()
        -- NOTE: nvim-treesitter config is in nvim_treesitter.lua
        nnoremap("<F6>", ":TSContextToggle<CR>")
      end,
    })

    if plugin_utils.is_enabled_plugin('nvim-gps') then
      use({
        "SmiteshP/nvim-gps",
        requires = "nvim-treesitter/nvim-treesitter",
        config = function()
          require("nvim-gps").setup()
        end,
      })
    end
  end

  use({
    "mattn/emmet-vim",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      vim.g.user_emmet_leader_key = "<C-E>"
    end,
  })

  use({
    "mars90226/cscope_macros.vim",
    keys = { "<F11>", "<Space><F11>" },
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/cscope.vim")
    end,
  })

  -- Markdown preview
  -- FIXME: Seems not correctly installed using packer.nvim
  use({
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    run = "cd app & npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  })

  use({
    "fatih/vim-go",
    ft = { "go" },
    run = ":GoUpdateBinaries",
    config = function()
      vim.g.go_decls_mode = "fzf"

      -- TODO Add key mappings for vim-go commands
    end,
  })

  use({
    "rhysd/rust-doc.vim",
    ft = { "rust" },
    config = function()
      vim.g["rust_doc#define_map_K"] = 0
      vim.g["rust_doc#vim_open_cmd"] = "RustDocOpen"

      vim.cmd([[command! -nargs=1 RustDocOpen call vimrc#rust_doc#open(<f-args>)]])
    end,
  })

  use({
    "apeschel/vim-syntax-syslog-ng",
    config = function()
      vim.cmd([[augroup vim_syntax_syslog_ng_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd BufNewFile,BufReadPost syslog-ng.conf       setlocal filetype=syslog-ng]])
      vim.cmd([[  autocmd BufNewFile,BufReadPost syslog-ng/*/*.conf   setlocal filetype=syslog-ng]])
      vim.cmd([[  autocmd BufNewFile,BufReadPost patterndb.d/*.conf   setlocal filetype=syslog-ng]])
      vim.cmd([[  autocmd BufNewFile,BufReadPost patterndb.d/*/*.conf setlocal filetype=syslog-ng]])
      vim.cmd([[augroup END]])
    end,
  })

  use({
    "kkoomen/vim-doge",
    run = function()
      vim.fn["doge#install"]()
    end,
    cmd = { "DogeGenerate", "DogeCreateDocStandard" },
    keys = { "<Leader><Leader>d" },
    config = function()
      vim.g.doge_mapping = "<Leader><Leader>d"
    end,
  })

  use({ "mars90226/perldoc-vim", ft = { "perl" } })
  use({
    "fs111/pydoc.vim",
    ft = { "python" },
    config = function()
      vim.g.pydoc_perform_mappings = 0
    end,
  })
end

return languages
