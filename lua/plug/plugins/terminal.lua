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
      { "<M-2>", mode = { "n", "t" } },
      { "<M-3>", mode = { "n", "t" } },
      { "<M-4>", mode = { "n", "t" } },
      { "<M-5>", mode = { "n", "t" } },
      { "<Leader>xh", mode = "n" },
      { "<Leader>xs", mode = "n" },
      { "<Leader>xc", mode = { "n", "x" } },
      { "<Leader>xC", mode = { "n", "x" } },
      { "<Leader>xw", mode = "n" },
      { "<M-q><M-2>", mode = "t" },
      { "<M-q><M-3>", mode = "t" },
      { "<M-q><M-4>", mode = "t" },
      { "<M-q><M-5>", mode = "t" },
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

  -- TODO: Add other terminal plugin

  {
    "hkupty/iron.nvim",
    cmd = { "IronRepl", "IronReplHere", "IronSend" },
    keys = { "<Leader>ic", "<Leader>if", "<Leader>il", "<Leader>mc" },
    config = function()
      require("iron.core").setup({
        config = {
          -- If iron should expose `<plug>(...)` mappings for the plugins
          should_map_plug = false,
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {},
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
