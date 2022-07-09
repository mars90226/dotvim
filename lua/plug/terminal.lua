local utils = require("vimrc.utils")

local terminal = {}

terminal.startup = function(use)
  -- vim-floaterm
  use({
    "voldikss/vim-floaterm",
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/floaterm.vim")
    end,
  })
  use("voldikss/fzf-floaterm")

  use({
    "kassio/neoterm",
    cmd = { "T", "Ttoggle", "Texec" },
    keys = { "<Space>`", "<Leader>`" },
    config = function()
      vim.g.neoterm_default_mod = "botright"
      vim.g.neoterm_automap_keys = "<Leader>T"
      vim.g.neoterm_size = vim.go.lines / 2

      nnoremap("<Space>`", [[:execute 'T ' . input('Terminal: ', '', 'shellcmd')<CR>]], "<silent>")
      nnoremap("<Leader>`", [[:Ttoggle<CR>]], "<silent>")
      nnoremap("<Space><F3>", [[:TREPLSendFile<CR>]], "<silent>")
      nnoremap("<F3>", [[:TREPLSendLine<CR>]], "<silent>")
      xnoremap("<F3>", [[:TREPLSendSelection<CR>]], "<silent>")

      -- Useful maps
      -- hide/close terminal
      nnoremap("<Leader>th", [[:Tclose<CR>]], "<silent>")
      -- clear terminal
      nnoremap("<Leader>tl", [[:Tclear<CR>]], "<silent>")
      -- kills the current job (send a <c-c>)
      nnoremap("<Leader>tc", [[:Tkill<CR>]], "<silent>")
    end,
  })

  use({
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
  })
end

return terminal
