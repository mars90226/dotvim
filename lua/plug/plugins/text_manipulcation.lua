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
        "dosini",
        "pfmain",
        "rspamd",
        "squid",
        "sshdconfig",
      }, "#%s")
    end,
  },

  {
    "junegunn/vim-easy-align",
    keys = {
      { "<Leader>ga", mode = { "n", "x" }, "<Plug>(EasyAlign)", desc = "Easy align" },
      { "<Leader>gA", mode = { "n", "x" }, "<Plug>(LiveEasyAlign)", desc = "Live easy align" },
    },
    opts = {},
  },

  {
    "vim-scripts/eraseSubword",
    keys = {
      { "<C-B>", mode = "i", desc = "Erase subword" },
    },
    init = function()
      vim.g.EraseSubword_insertMap = "<C-B>"
    end,
  },

  -- Substitute & Exchange
  {
    "gbprod/substitute.nvim",
    keys = {
      -- Substitute
      { "ss",                 mode = { "n" }, "<Cmd>lua require('substitute').operator()<CR>" },
      { "ss",                 mode = { "x" }, "<Cmd>lua require('substitute').visual()<CR>" },
      { "sS",                 mode = { "n" }, "<Cmd>lua require('substitute').line()<CR>" },
      { "sl",                 mode = { "n" }, "<Cmd>lua require('substitute').eol()<CR>" },

      -- Substitute using system clipboard
      { "=ss",                mode = { "n" }, "<Cmd>lua require('substitute').operator({ register = '+' })<CR>" },
      { "=ss",                mode = { "x" }, "<Cmd>lua require('substitute').visual({ register = '+' })<CR>" },
      { "=sS",                mode = { "n" }, "<Cmd>lua require('substitute').line({ register = '+' })<CR>" },
      { "=sl",                mode = { "n" }, "<Cmd>lua require('substitute').eol({ register = '+' })<CR>" },

      -- Substitute over range
      { "<Leader>s",          mode = { "n" }, "<Cmd>lua require('substitute.range').operator()<CR>" },
      { "<Leader>s",          mode = { "x" }, "<Cmd>lua require('substitute.range').visual()<CR>" },
      { "<Leader>ss",         mode = { "n" }, "<Cmd>lua require('substitute.range').word()<CR>" },

      -- Substitute over range confirm
      { "scr",                mode = { "n" }, "<Cmd>lua require('substitute.range').operator({ confirm = true })<CR>" },
      { "scr",                mode = { "x" }, "<Cmd>lua require('substitute.range').visual({ confirm = true })<CR>" },
      { "scrr",               mode = { "n" }, "<Cmd>lua require('substitute.range').word({ confirm = true })<CR>" },

      -- Substitute over range Subvert (depends on vim-abolish)
      { "<Leader><Leader>s",  mode = { "n" }, "<Cmd>lua require('substitute.range').operator({ prefix = 'S' })<CR>" },
      { "<Leader><Leader>s",  mode = { "x" }, "<Cmd>lua require('substitute.range').visual({ prefix = 'S' })<CR>" },
      { "<Leader><Leader>ss", mode = { "n" }, "<Cmd>lua require('substitute.range').word({ prefix = 'S' })<CR>" },

      -- Exchange
      { "cx",                 mode = { "n" }, "<Cmd>lua require('substitute.exchange').operator()<CR>" },
      { "cxx",                mode = { "n" }, "<Cmd>lua require('substitute.exchange').line()<CR>" },
      { "X",                  mode = { "x" }, "<Cmd>lua require('substitute.exchange').visual()<CR>" },
      { "cxc",                mode = { "n" }, "<Cmd>lua require('substitute.exchange').cancel()<CR>" },
    },
    config = function()
      require("substitute").setup({
        preserve_cursor_position = true,
        range = {
          complete_word = false,
        },
      })
    end,
  },
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<Leader>sr",
        mode = { "n", "x" },
        "<Leader>sr",
        function()
          require("ssr").open()
        end,
        desc = "ssr.nvim - open",
      },
    },
    config = function()
      require("ssr").setup()
    end,
  },
  {
    "AckslD/muren.nvim",
    cmd = { "MurenToggle", "MurenOpen", "MurenUnique", "MurenUniqueVisual" },
    keys = {
      { "<Leader>mr", [[<Cmd>MurenToggle<CR>]], desc = "muren.nvim - toggle" },
      { "<Leader>mu", [[<Cmd>MurenUnique<CR>]], desc = "muren.nvim - prefill with unique matches" },
      {
        "<Leader>mk",
        function()
          require("vimrc.plugins.muren").open_unique_ui(vim.fn.expand("<cword>"))
        end,
        desc = "muren.nvim - search cursor word and prefill with unique matches",
      },
      {
        "<Leader>mk",
        mode = "x",
        [[:MurenUniqueVisual<CR>]],
        desc = "muren.nvim - search visual selection and prefill with unique matches",
      },
    },
    config = function()
      local muren = require("vimrc.plugins.muren")

      require("muren").setup()

      vim.api.nvim_create_user_command("MurenUniqueVisual", function()
        muren.open_unique_ui(utils.get_visual_selection())
      end, { range = true })
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    cond = choose.is_enabled_plugin("nvim-surround"),
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
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
    cond = not utils.is_light_vim_mode(),
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
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
  {
    "Wansmer/treesj",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    cmd = { "TSJToggle" },
    keys = {
      { "<Space>J", [[<Cmd>TSJToggle<CR>]], desc = "Treesj toggle" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      -- Setup comment for all languages
      -- Ref: https://github.com/Wansmer/treesj/issues/116#issuecomment-1666911090
      local langs = require("treesj.langs").presets
      for _, nodes in pairs(langs) do
        nodes.comment = {
          both = {
            fallback = function(tsn)
              vim.cmd("normal! gww")
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
        max_join_length = 150,

        -- hold|start|end:
        -- hold - cursor follows the node/place on which it was called
        -- start - cursor jumps to the first symbol of the node being formatted
        -- end - cursor jumps to the last symbol of the node being formatted
        cursor_behavior = "hold",

        -- Notify about possible problems or not
        notify = true,
        langs = langs,
      })
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

  -- Case
  -- TODO: Lazy load on keys
  {
    "arthurxavierx/vim-caser",
    cond = not utils.is_light_vim_mode(),
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<Leader>tc", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "TextCase using telescope.nvim" },
    },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
  },

  "tpope/vim-repeat",
}

return text_manipulation
