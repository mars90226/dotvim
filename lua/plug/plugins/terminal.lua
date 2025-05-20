local terminal = {
  -- vim-floaterm
  {
    "voldikss/vim-floaterm",
    cmd = {
      "FloatermNew",
      "FloatermPrev",
      "FloatermNext",
      "FloatermFirst",
      "FloatermLast",
      "FloatermUpdate",
      "FloatermToggle",
      "FloatermShow",
      "FloatermHide",
      "FloatermKill",
      "FloatermSend",
    },
    keys = {
      { "<M-2>", mode = { "n" }, [[:FloatermToggle<CR>]], silent = true, desc = "Floaterm - toggle" },
      { "<M-3>", mode = { "n" }, [[:FloatermPrev<CR>]], silent = true, desc = "Floaterm - previous terminal" },
      { "<M-4>", mode = { "n" }, [[:FloatermNext<CR>]], silent = true, desc = "Floaterm - next terminal" },
      { "<M-5>", mode = { "n" }, [[:FloatermNew!<CR>]], silent = true, desc = "Floaterm - new terminal" },

      { "<Leader>xh", mode = { "n" }, [[:FloatermHide<CR>]], silent = true, desc = "Floaterm - hide terminal" },
      {
        "<Leader>xs",
        mode = { "n" },
        [[:execute 'FloatermSend '.input('Command: ', '', 'shellcmd')<CR>]],
        desc = "Floaterm - send command",
      },
      {
        "<Leader>xc",
        mode = { "n" },
        [[:execute 'FloatermNew '.input('Command: ', '', 'shellcmd')<CR>]],
        desc = "Floaterm - execute command in new terminal",
      },
      {
        "<Leader>xc",
        mode = { "x" },
        [[:<C-U>execute 'FloatermNew '.input('Command: ', '', 'shellcmd')<CR>]],
        desc = "Floaterm - execute command in new terminal",
      },
      -- For inserting selection in input() using cmap
      {
        "<Leader>xC",
        mode = { "n" },
        [[:execute 'FloatermNew! '.input('Command: ', '', 'shellcmd')<CR>]],
        desc = "Floaterm - execute command in new shell",
      },
      -- For inserting selection in input() using cmap
      {
        "<Leader>xC",
        mode = { "x" },
        [[:<C-U>execute 'FloatermNew! '.input('Command: ', '', 'shellcmd')<CR>]],
        desc = "Floaterm - execute command in new shell",
      },
      {
        "<Leader>xw",
        mode = { "n" },
        [[:execute 'FloatermNew! cd '.shellescape(getcwd())<CR>]],
        desc = "Floaterm - new terminal in current working directory",
      },

      -- For terminal
      { "<M-2>", mode = { "t" }, [[<C-\><C-N>:FloatermToggle<CR>]], desc = "Floaterm - toggle" },
      { "<M-3>", mode = { "t" }, [[<C-\><C-N>:FloatermPrev<CR>]], desc = "Floaterm - previous terminal" },
      { "<M-4>", mode = { "t" }, [[<C-\><C-N>:FloatermNext<CR>]], desc = "Floaterm - next terminal" },
      { "<M-5>", mode = { "t" }, [[<C-\><C-N>:FloatermNew<CR>]], desc = "Floaterm - new terminal" },

      -- For nested neovim
      {
        "<M-q><M-2>",
        mode = { "t" },
        [[<C-\><C-\><C-N>:FloatermToggle<CR>]],
        desc = "Floaterm - toggle in nested neovim",
      },
      {
        "<M-q><M-3>",
        mode = { "t" },
        [[<C-\><C-\><C-N>:FloatermPrev<CR>]],
        desc = "Floaterm - previous terminal in nested neovim",
      },
      {
        "<M-q><M-4>",
        mode = { "t" },
        [[<C-\><C-\><C-N>:FloatermNext<CR>]],
        desc = "Floaterm - next terminal in nested neovim",
      },
      {
        "<M-q><M-5>",
        mode = { "t" },
        [[<C-\><C-\><C-N>:FloatermNew!<CR>]],
        desc = "Floaterm - new terminal in nested neovim",
      },
    },
    config = function()
      require("vimrc.plugins.floaterm").setup()
    end,
  },
  {
    "voldikss/fzf-floaterm",
    cmd = { "Floaterms" },
    keys = { "<Space><M-2>" },
  },

  {
    "hkupty/iron.nvim",
    cmd = { "IronRepl", "IronReplHere", "IronSend" },
    keys = {
      { "<Leader>ic", mode = { "n" }, desc = "iron.nvim - send motion" },
      { "<Leader>ic", mode = { "v" }, desc = "iron.nvim - visual send" },
      { "<Leader>if", mode = { "n" }, desc = "iron.nvim - send file" },
      { "<Leader>il", mode = { "n" }, desc = "iron.nvim - send line" },
      { "<Leader>im", mode = { "n" }, desc = "iron.nvim - send mark" },
      { "<Leader>mc", mode = { "n" }, desc = "iron.nvim - mark motion" },
      { "<Leader>mc", mode = { "v" }, desc = "iron.nvim - visual mark" },
      { "<Leader>md", mode = { "n" }, desc = "iron.nvim - remove mark" },
      { "<Leader>i<CR>", mode = { "n" }, desc = "iron.nvim - send current line" },
      { "<Leader>i,", mode = { "n" }, desc = "iron.nvim - interrupt" },
      { "<Leader>iq", mode = { "n" }, desc = "iron.nvim - exit" },
      { "<Leader>i<C-L>", mode = { "n" }, desc = "iron.nvim - clear" },
      { "<Leader>io", mode = { "n" }, "<Cmd>IronFocus<CR>", desc = "iron.nvim - focus" },
      { "<Leader>iO", mode = { "n" }, "<Cmd>IronHide<CR>", desc = "iron.nvim - hide" },
    },
    config = function()
      require("iron.core").setup({
        config = {
          -- If iron should expose `<plug>(...)` mappings for the plugins
          should_map_plug = false,
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            python = vim.tbl_extend("force", require("iron.fts.python").python, {
              block_dividers = { "# %%", "#%%" },
            }),
          },
          repl_open_cmd = require("iron.view").bottom("40%"),
        },
        -- Iron doesn't set keymaps by default anymore. Set them here
        -- or use `should_map_plug = true` and map from you vim files
        keymaps = {
          send_motion = "<Leader>ic",
          visual_send = "<Leader>ic",
          send_file = "<Leader>if",
          send_line = "<Leader>il",
          send_mark = "<Leader>im",
          mark_motion = "<Leader>mc",
          mark_visual = "<Leader>mc",
          remove_mark = "<Leader>md",
          cr = "<Leader>i<CR>",
          interrupt = "<Leader>i,",
          exit = "<Leader>iq",
          clear = "<Leader>i<C-L>",
        },
      })
    end,
  },
}

return terminal
