local termdebug = {
  -- builtin Termdebug plugin
  {
    dir = "",
    name = "termdebug",
    cmd = { "Termdebug", "TermdebugCommand" },
    config = function()
      vim.cmd([[packadd termdebug]])

      -- Mappings
      vim.keymap.set("n", "<Leader>dd", [[:Termdebug<Space>]])
      vim.keymap.set("n", "<Leader>dD", [[:TermdebugCommand<Space>]])

      vim.keymap.set("n", "<Leader>dr", [[:Run<Space>]])
      vim.keymap.set("n", "<Leader>da", [[:Arguments<Space>]])

      vim.keymap.set("n", "<Leader>db", [[<Cmd>Break<CR>]])
      vim.keymap.set("n", "<Leader>dC", [[<Cmd>Clear<CR>]])

      vim.keymap.set("n", "<Leader>ds", [[<Cmd>Step<CR>]])
      vim.keymap.set("n", "<Leader>do", [[<Cmd>Over<CR>]])
      vim.keymap.set("n", "<Leader>df", [[<Cmd>Finish<CR>]])
      vim.keymap.set("n", "<Leader>dc", [[<Cmd>Continue<CR>]])
      vim.keymap.set("n", "<Leader>dS", [[<Cmd>Stop<CR>]])

      -- `:Evaluate` evaluate cursor variable and show result in floating window
      -- which may not be large enough to contain all result
      vim.keymap.set("n", "<Leader>de", [[:Evaluate<Space>]])
      vim.keymap.set("x", "<Leader>de", [[<Cmd>Evaluate]])
      -- `:Evaluate variable` show result in echo
      vim.keymap.set("n", "<Leader>dk", [[<Cmd>execute 'Evaluate '.expand('<cword>')<CR>]])
      vim.keymap.set("n", "<Leader>dK", [[<Cmd>execute 'Evaluate '.expand('<cWORD>')<CR>]])

      vim.keymap.set("n", "<Leader>dG", [[<Cmd>Gdb<CR>]])
      vim.keymap.set("n", "<Leader>dp", [[<Cmd>Program<CR>]])
      vim.keymap.set("n", "<Leader>dO", [[<Cmd>Source<CR>]])

      vim.keymap.set("n", "<Leader>d,", [[<Cmd>call TermDebugSendCommand(input('Gdb command> '))<CR>]])
    end,
  },
}

return termdebug
