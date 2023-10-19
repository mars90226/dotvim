local choose = require("vimrc.choose")
local utils = require("vimrc.utils")

local text_manipulation = {
  -- Comment
  {
    "numToStr/Comment.nvim",
    keys = {
      "gcO",
      "gco",
      "gc",
      "gb",
      "gcA",
      "gcc",
      "gbc",
      "gc",
      "gb",
      { "gc", mode = "x" },
      { "gb", mode = "x" },
    },
    config = function()
      require("Comment").setup()

      local ft = require("Comment.ft")
      ft({
        'dosini',
        'pfmain',
        'rspamd',
        'squid',
        'sshdconfig',
      }, '#%s')
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
      { "<C-B>", mode = "i" },
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
  {
    "cshuaimin/ssr.nvim",
    keys = { "<Leader>sr" },
    config = function()
      require("ssr").setup()

      vim.keymap.set({ "n", "x" }, "<Leader>sr", function()
        require("ssr").open()
      end)
    end,
  },
  {
    "AckslD/muren.nvim",
    cmd = { "MurenToggle", "MurenOpen", "MurenUnique", "MurenUniqueVisual" },
    keys = { "<Leader>mr", "<Leader>mu", "<Leader>mk", { "<Leader>mk", mode = "x" } },
    config = function()
      local muren = require("vimrc.plugins.muren")

      require("muren").setup()

      vim.api.nvim_create_user_command("MurenUniqueVisual", function()
        muren.open_unique_ui(utils.get_visual_selection())
      end, { range = true })

      nnoremap("<Leader>mr", [[<Cmd>MurenToggle<CR>]])
      nnoremap("<Leader>mu", [[<Cmd>MurenUnique<CR>]])
      nnoremap("<Leader>mk", function()
        muren.open_unique_ui(vim.fn.expand("<cword>"))
      end)
      xnoremap("<Leader>mk", [[:MurenUniqueVisual<CR>]])
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    event = { "VeryLazy" },
    config = function()
      require("nvim-surround").setup({})

      require("vimrc.plugins.nvim_surround").buffer_setup_preset("vim_surround")
      require("vimrc.plugins.nvim_surround").buffer_setup_preset("vim_sandwich")

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
    keys = { "<Space>hm", "<Space>hs", "<Space>hj" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- Setup comment for all languages
      -- Ref: https://github.com/Wansmer/treesj/issues/116#issuecomment-1666911090
      local langs = require('treesj.langs').presets
      for _, nodes in pairs(langs) do
        nodes.comment = {
          both = {
            fallback = function(tsn)
              vim.cmd('normal! gww')
            end,
          },
        }
      end

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
        langs = langs,
      })

      nnoremap("<Space>hm", [[<Cmd>TSJToggle<CR>]])
      nnoremap("<Space>hs", [[<Cmd>TSJSplit<CR>]])
      nnoremap("<Space>hj", [[<Cmd>TSJJoin<CR>]])
    end,
  },

  -- Increment/Decrement
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-A>", mode = { "n", "x" } },
      { "<C-X>", mode = { "n", "x" } },
      { "g<C-A>", mode = "x" },
      { "g<C-X>", mode = "x" },
    },
    config = function()
      require("vimrc.plugins.dial").setup()
    end,
  },

  "tpope/vim-repeat",
}

return text_manipulation
