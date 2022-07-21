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
      -- TODO: Create issue for substitute not change cursor position back to original position for expand('<cword>')
      require("substitute").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })

      -- Substitute
      nnoremap("ss", "<Cmd>lua require('substitute').operator()<CR>")
      nnoremap("sS", "<Cmd>lua require('substitute').line()<CR>")
      nnoremap("sl", "<Cmd>lua require('substitute').eol()<CR>")
      xnoremap("ss", "<Cmd>lua require('substitute').visual()<CR>")

      -- Substitute using system clipboard
      nnoremap("=ss", "<Cmd>lua require('substitute').operator({ register = '+' })<CR>")
      nnoremap("=sS", "<Cmd>lua require('substitute').line({ register = '+' })<CR>")
      nnoremap("=sl", "<Cmd>lua require('substitute').eol({ register = '+' })<CR>")
      xnoremap("=ss", "<Cmd>lua require('substitute').visual({ register = '+' })<CR>")

      -- Substitute over range
      nnoremap("<Leader>s", "<Cmd>lua require('substitute.range').operator()<CR>")
      xnoremap("<Leader>s", "<Cmd>lua require('substitute.range').visual()<CR>")
      nnoremap("<Leader>ss", "<Cmd>lua require('substitute.range').word()<CR>")

      -- Substitute over range confirm
      nnoremap("scr", "<Cmd>lua require('substitute.range').operator({ confirm = true })<CR>")
      xnoremap("scr", "<Cmd>lua require('substitute.range').visual({ confirm = true })<CR>")
      nnoremap("scrr", "<Cmd>lua require('substitute.range').word({ confirm = true })<CR>")

      -- Substitute over range Subvert (depends on vim-abolish)
      nnoremap("<Leader><Leader>s", "<Cmd>lua require('substitute.range').operator({ prefix = 'S' })<CR>")
      xnoremap("<Leader><Leader>s", "<Cmd>lua require('substitute.range').visual({ prefix = 'S' })<CR>")
      nnoremap("<Leader><Leader>ss", "<Cmd>lua require('substitute.range').word({ prefix = 'S' })<CR>")

      -- Exchange
      nnoremap("cx", "<Cmd>lua require('substitute.exchange').operator()<CR>")
      nnoremap("cxx", "<Cmd>lua require('substitute.exchange').line()<CR>")
      xnoremap("X", "<Cmd>lua require('substitute.exchange').visual()<CR>")
      nnoremap("cxc", "<Cmd>lua require('substitute.exchange').cancel()<CR>")
    end,
  })

  -- Surround
  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})

      local nvim_surround_augroup_id = vim.api.nvim_create_augroup("nvim_surround_settings", {})
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = nvim_surround_augroup_id,
        pattern = "*",
        callback = function()
          require("nvim-surround").buffer_setup({
            keymaps = { -- vim-surround style keymaps
              normal = "ys",
              normal_cur = "yss",
              normal_line = "yS",
              normal_cur_line = "ySS",
              visual = "S",
              visual_line = "gS",
              delete = "ds",
              change = "cs",
            },
          })
          -- NOTE: Second key mapping
          require("nvim-surround").buffer_setup({
            keymaps = { -- vim-sandwich style keymaps
              normal = "sa",
              normal_cur = "sas",
              normal_line = "sA",
              normal_cur_line = "sAs",
              visual = "sa",
              visual_line = "sA",
              delete = "sd",
              change = "sr",
            },
          })
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

  use("editorconfig/editorconfig-vim")
  use("AndrewRadev/splitjoin.vim")
  use("tpope/vim-repeat")
end

return text_manipulation
