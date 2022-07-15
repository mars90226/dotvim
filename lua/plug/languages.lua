local choose = require("vimrc.choose")

local languages = {}

languages.startup = function(use)
  -- filetype
  use({ "rust-lang/rust.vim", ft = { "rust" } })
  use({ "leafo/moonscript-vim", ft = { "moon" } })
  use({
    "plasticboy/vim-markdown",
    ft = { "markdown" },
    requires = { "godlygeek/tabular" },
  })
  use({ "mtdl9/vim-log-highlighting", ft = { "log" } })
  use({ "ClockworkNet/vim-apparmor", ft = { "apparmor" } })
  use({ "chrisbra/csv.vim", ft = { "csv" } })

  -- Highlighing
  -- nvim-treesitter
  -- TODO: Move to dedicate place?
  if choose.is_enabled_plugin("nvim-treesitter") then
    use({
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("vimrc.plugins.nvim_treesitter").setup()
      end,
    })
    use({
      "nvim-treesitter/nvim-treesitter-refactor",
      requires = { "nvim-treesitter/nvim-treesitter" },
    })
    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      requires = { "nvim-treesitter/nvim-treesitter" },
    })
    use({
      "nvim-treesitter/playground",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
      requires = { "nvim-treesitter/nvim-treesitter" },
      keys = { "<Space>hp", "<Space>hh" },
      config = function()
        require("nvim-treesitter.configs").setup({
          playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
              toggle_query_editor = "o",
              toggle_hl_groups = "i",
              toggle_injected_languages = "t",
              toggle_anonymous_nodes = "a",
              toggle_language_display = "I",
              focus_language = "f",
              unfocus_language = "F",
              update = "R",
              goto_node = "<cr>",
              show_help = "?",
            },
          },
        })

        nnoremap("<Space>hp", [[<Cmd>TSPlaygroundToggle<CR>]])
        nnoremap("<Space>hh", [[<Cmd>TSHighlightCapturesUnderCursor<CR>]])
      end,
    })
    use({
      "JoosepAlviste/nvim-ts-context-commentstring",
      requires = { "nvim-treesitter/nvim-treesitter" },
    })
    -- TODO: Rename to 'mfussenegger/nvim-treehopper'
    use({
      "mfussenegger/nvim-ts-hint-textobject",
      requires = { "nvim-treesitter/nvim-treesitter" },
    })
    use({
      "RRethy/nvim-treesitter-textsubjects",
      requires = { "nvim-treesitter/nvim-treesitter" },
    })
    use({
      "lewis6991/spellsitter.nvim",
      requires = { "nvim-treesitter/nvim-treesitter" },
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
      requires = { "nvim-treesitter/nvim-treesitter" },
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
          [[<Cmd>lua require("syntax-tree-surfer").targeted_jump({"string", "string_literal","number", "number_literal","true","false"})<CR>]]
        )

        -- filtered jump
        nnoremap("<M-S-n>", [[<Cmd>lua require("syntax-tree-surfer").filtered_jump("default", true)<CR>]], "silent")
        nnoremap("<M-S-p>", [[<Cmd>lua require("syntax-tree-surfer").filtered_jump("default", false)<CR>]], "silent")
      end,
    })
    use({
      "yioneko/nvim-yati",
      requires = { "nvim-treesitter/nvim-treesitter" },
    })
    use({
      "ThePrimeagen/refactoring.nvim",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
      },
      config = function()
        require("refactoring").setup({})

        -- Remaps for the refactoring operations currently offered by the plugin
        vim.api.nvim_set_keymap(
          "v",
          "<Space>re",
          [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
          { noremap = true, silent = true, expr = false }
        )
        vim.api.nvim_set_keymap(
          "v",
          "<Space>rf",
          [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
          { noremap = true, silent = true, expr = false }
        )
        vim.api.nvim_set_keymap(
          "v",
          "<Space>rv",
          [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
          { noremap = true, silent = true, expr = false }
        )
        vim.api.nvim_set_keymap(
          "v",
          "<Space>ri",
          [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
          { noremap = true, silent = true, expr = false }
        )

        -- Extract block doesn't need visual mode
        vim.api.nvim_set_keymap(
          "n",
          "<Space>rb",
          [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
          { noremap = true, silent = true, expr = false }
        )
        vim.api.nvim_set_keymap(
          "n",
          "<Space>rbf",
          [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
          { noremap = true, silent = true, expr = false }
        )

        -- Inline variable can also pick up the identifier currently under the cursor without visual mode
        vim.api.nvim_set_keymap(
          "n",
          "<Space>ri",
          [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
          { noremap = true, silent = true, expr = false }
        )

        -- remap to open the Telescope refactoring menu in visual mode
        vim.api.nvim_set_keymap(
          "v",
          "<Space>rr",
          "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
          { noremap = true }
        )

        -- load refactoring Telescope extension
        require("telescope").load_extension("refactoring")
      end,
    })
  end

  -- TODO: Check if this can be replaced by vim.lsp.buf.document_highlight()
  -- ref: :help vim.lsp.buf.document_highlight()
  use("jackguo380/vim-lsp-cxx-highlight")

  -- Context
  if choose.is_enabled_plugin("nvim-treesitter") then
    use({
      "nvim-treesitter/nvim-treesitter-context",
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        -- NOTE: nvim-treesitter config is in nvim_treesitter.lua
        nnoremap("<F6>", ":TSContextToggle<CR>")
      end,
    })

    if choose.is_enabled_plugin("nvim-gps") then
      use({
        "SmiteshP/nvim-gps",
        requires = { "nvim-treesitter/nvim-treesitter" },
        config = function()
          require("nvim-gps").setup()
        end,
      })
    end
  end

  -- TODO: Replace with emmet lsp
  use({
    "mattn/emmet-vim",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    setup = function()
      vim.g.user_emmet_leader_key = "<M-m>"
    end,
  })

  use({
    "mars90226/cscope_macros.vim",
    keys = { "<F11>", "<Space><F11>" },
    config = function()
      nnoremap("<F11>", [[<Cmd>lua require("vimrc.cscope").generate_files()<CR>]])
      nnoremap("<Space><F11>", [[<Cmd>lua require("vimrc.cscope").reload()<CR>]])
    end,
  })

  -- Markdown preview
  use({
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    run = "cd app & npm install",
    setup = function()
      local plugin_utils = require("vimrc.plugin_utils")

      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_open_to_the_world = 1

      if plugin_utils.is_executable("open_url.sh") then
        vim.g.mkdp_browser = "open_url.sh"
      end
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

  use({ "apeschel/vim-syntax-syslog-ng" })

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
