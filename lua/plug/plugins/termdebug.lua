local termdebug = {
  -- builtin Termdebug plugin
  {
    dir = "",
    name = "termdebug",
    cmd = { "Termdebug", "TermdebugCommand" },
    config = function()
      vim.cmd([[packadd termdebug]])

      -- Mappings
      nnoremap("<Leader>dd", [[:Termdebug<Space>]])
      nnoremap("<Leader>dD", [[:TermdebugCommand<Space>]])

      nnoremap("<Leader>dr", [[:Run<Space>]])
      nnoremap("<Leader>da", [[:Arguments<Space>]])

      nnoremap("<Leader>db", [[<Cmd>Break<CR>]])
      nnoremap("<Leader>dC", [[<Cmd>Clear<CR>]])

      nnoremap("<Leader>ds", [[<Cmd>Step<CR>]])
      nnoremap("<Leader>do", [[<Cmd>Over<CR>]])
      nnoremap("<Leader>df", [[<Cmd>Finish<CR>]])
      nnoremap("<Leader>dc", [[<Cmd>Continue<CR>]])
      nnoremap("<Leader>dS", [[<Cmd>Stop<CR>]])

      -- `:Evaluate` evaluate cursor variable and show result in floating window
      -- which may not be large enough to contain all result
      nnoremap("<Leader>de", [[:Evaluate<Space>]])
      xnoremap("<Leader>de", [[<Cmd>Evaluate]])
      -- `:Evaluate variable` show result in echo
      nnoremap("<Leader>dk", [[<Cmd>execute 'Evaluate '.expand('<cword>')<CR>]])
      nnoremap("<Leader>dK", [[<Cmd>execute 'Evaluate '.expand('<cWORD>')<CR>]])

      nnoremap("<Leader>dg", [[<Cmd>Gdb<CR>]])
      nnoremap("<Leader>dp", [[<Cmd>Program<CR>]])
      nnoremap("<Leader>dO", [[<Cmd>Source<CR>]])

      nnoremap("<Leader>d,", [[<Cmd>call TermDebugSendCommand(input('Gdb command> '))<CR>]])
    end,
  },
}

return termdebug
