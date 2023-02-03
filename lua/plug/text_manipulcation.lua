local choose = require("vimrc.choose")

local text_manipulation = {}

text_manipulation.startup = function(use)
  -- Comment
  use({
    "numToStr/Comment.nvim",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      require("Comment").setup()
    end,
  })

  use({
    "junegunn/vim-easy-align",
    config = function()
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      xmap("ga", "<Plug>(EasyAlign)")

      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      nmap("ga", "<Plug>(EasyAlign)")

      nmap("<Leader>ga", "<Plug>(LiveEasyAlign)")
      xmap("<Leader>ga", "<Plug>(LiveEasyAlign)")
    end,
  })

  use({
    "vim-scripts/eraseSubword",
    config = function()
      vim.g.EraseSubword_insertMap = "<C-B>"
    end,
  })

  -- Substitute & Exchange
  use({
    "gbprod/substitute.nvim",
    config = function()
      require("vimrc.plugins.substitute").setup()
    end,
  })

  -- Surround
  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})

      local nvim_surround_augroup_id = vim.api.nvim_create_augroup("nvim_surround_settings", {})
      vim.api.nvim_create_autocmd({ "BufRead", "CmdWinEnter" }, {
        group = nvim_surround_augroup_id,
        pattern = "*",
        callback = function()
          require("vimrc.plugins.nvim_surround").buffer_setup_preset("vim_surround")
          require("vimrc.plugins.nvim_surround").buffer_setup_preset("vim_sandwich")
        end,
      })
    end,
  })

  -- imap <BS> & <CR> is overwritten, need to be careful of bugs
  use({
    "mg979/vim-visual-multi",
    config = function()
      -- nvim-hlslens integration
      vim.cmd([[augroup vmlens_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd User visual_multi_start lua require('vimrc.plugins.vmlens').start()]])
      vim.cmd([[  autocmd User visual_multi_exit lua require('vimrc.plugins.vmlens').exit()]])
      vim.cmd([[augroup END]])
    end,
  })

  -- For vim-markdown :TableFormat
  use({
    "godlygeek/tabular",
    cmd = "Tabularize",
  })

  -- Split-Join
  use("AndrewRadev/splitjoin.vim")
  if choose.is_enabled_plugin("nvim-treesitter") then
    use({
      "AckslD/nvim-trevJ.lua",
      keys = { "<Leader>jr" },
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("trevj").setup()

        nnoremap("<Leader>jr", [[<Cmd>lua require('trevj').format_at_cursor()<CR>]])
      end,
    })
    use({
      "Wansmer/treesj",
      cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
      keys = { "<Leader>jm", "<Leader>js", "<Leader>jj" },
      requires = { "nvim-treesitter/nvim-treesitter" },
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
    })
  end

  -- Increment/Decrement
  use({
    "monaqa/dial.nvim",
    config = function()
      require("vimrc.plugins.dial").setup()
    end,
  })

  use("editorconfig/editorconfig-vim")
  use("tpope/vim-repeat")
end

return text_manipulation
