local choose = require("vimrc.choose")

local text_manipulation = {
  -- Comment
  {
    "numToStr/Comment.nvim",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "junegunn/vim-easy-align",
    event = { "VeryLazy" },
    config = function()
      vim.keymap.set({ "n", "x" }, "ga", "<Plug>(EasyAlign)")
      vim.keymap.set({ "n", "x" }, "<Leader>ga", "<Plug>(LiveEasyAlign)")
    end,
  },

  {
    "vim-scripts/eraseSubword",
    keys = {
      "<C-B>",
    },
    init = function()
      vim.g.EraseSubword_insertMap = "<C-B>"
    end,
  },

  -- Substitute & Exchange
  {
    "gbprod/substitute.nvim",
    event = { "VeryLazy" },
    config = function()
      require("vimrc.plugins.substitute").setup()
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    event = { "VeryLazy" },
    config = function()
      require("nvim-surround").setup({})

      local nvim_surround_augroup_id = vim.api.nvim_create_augroup("nvim_surround_settings", {})
      vim.api.nvim_create_autocmd({ "BufRead", "CmdWinEnter", "VimEnter" }, {
        group = nvim_surround_augroup_id,
        pattern = "*",
        callback = function()
          require("vimrc.plugins.nvim_surround").buffer_setup_preset("vim_surround")
          require("vimrc.plugins.nvim_surround").buffer_setup_preset("vim_sandwich")
        end,
      })
    end,
  },

  -- imap <BS> & <CR> is overwritten, need to be careful of bugs
  {
    "mg979/vim-visual-multi",
    event = { "VeryLazy" },
    config = function()
      -- nvim-hlslens integration
      vim.cmd([[augroup vmlens_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd User visual_multi_start lua require('vimrc.plugins.vmlens').start()]])
      vim.cmd([[  autocmd User visual_multi_exit lua require('vimrc.plugins.vmlens').exit()]])
      vim.cmd([[augroup END]])
    end,
  },

  -- For vim-markdown :TableFormat
  {
    "godlygeek/tabular",
    cmd = "Tabularize",
  },

  -- Split-Join
  "AndrewRadev/splitjoin.vim",
  {
    "AckslD/nvim-trevJ.lua",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    keys = { "<Leader>jr" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("trevj").setup()

      nnoremap("<Leader>jr", [[<Cmd>lua require('trevj').format_at_cursor()<CR>]])
    end,
  },
  {
    "Wansmer/treesj",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = { "<Leader>jm", "<Leader>js", "<Leader>jj" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        -- Use default keymaps
        -- (<space>m - toggle, <space>j - join, <space>s - split)
        use_default_keymaps = false,

        -- Node with syntax error will not be formatted
        check_syntax_error = true,

        -- If line after join will be longer than max value,
        -- node will not be formatted
        max_join_length = 120,

        -- hold|start|end:
        -- hold - cursor follows the node/place on which it was called
        -- start - cursor jumps to the first symbol of the node being formatted
        -- end - cursor jumps to the last symbol of the node being formatted
        cursor_behavior = "hold",

        -- Notify about possible problems or not
        notify = true,
        -- langs = langs,
      })

      nnoremap("<Leader>jm", [[<Cmd>TSJToggle<CR>]])
      nnoremap("<Leader>js", [[<Cmd>TSJSplit<CR>]])
      nnoremap("<Leader>jj", [[<Cmd>TSJJoin<CR>]])
    end,
  },

  -- Increment/Decrement
  {
    "monaqa/dial.nvim",
    event = { "VeryLazy" },
    config = function()
      require("vimrc.plugins.dial").setup()
    end,
  },

  -- TODO: Remove editorconfig-vim as neovim 0.9 already support it
  "editorconfig/editorconfig-vim",
  "tpope/vim-repeat",
}

return text_manipulation
