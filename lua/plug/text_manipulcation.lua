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
        range = {
          complete_word = true,
        },
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

  use({
    "AckslD/nvim-trevJ.lua",
    keys = { "<Leader>j" },
    config = function()
      require("trevj").setup()

      nnoremap("<Leader>j", [[<Cmd>lua require('trevj').format_at_cursor()<CR>]])
    end,
  })

  -- Increment/Decrement
  use({
    "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        -- default augends used when no group name is specified
        default = {
          -- NOTE: Original default
          augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
          augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
          augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%m/%d"],
          augend.date.alias["%H:%M"],
          augend.constant.alias.ja_weekday_full,

          -- Custom
          augend.date.alias["%H:%M:%S"],
          augend.constant.alias.bool,
          augend.constant.new({
            elements = { "and", "or" },
            word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
            cyclic = true, -- "or" is incremented into "and".
          }),
          augend.constant.new({
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "yes", "no" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({
            elements = { "on", "off" },
            word = true,
            cyclic = true,
          }),
          augend.semver.alias.semver,
        },
      })

      vim.api.nvim_set_keymap("n", "<C-A>", require("dial.map").inc_normal(), { noremap = true })
      vim.api.nvim_set_keymap("n", "<C-X>", require("dial.map").dec_normal(), { noremap = true })
      vim.api.nvim_set_keymap("v", "<C-A>", require("dial.map").inc_visual(), { noremap = true })
      vim.api.nvim_set_keymap("v", "<C-X>", require("dial.map").dec_visual(), { noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-A>", require("dial.map").inc_gvisual(), { noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-X>", require("dial.map").dec_gvisual(), { noremap = true })
    end,
  })

  use("editorconfig/editorconfig-vim")
  use("AndrewRadev/splitjoin.vim")
  use("tpope/vim-repeat")
end

return text_manipulation
