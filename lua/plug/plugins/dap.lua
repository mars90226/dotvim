local choose = require("vimrc.choose")

local dap = {
  -- Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
          "williamboman/mason.nvim",
          "mfussenegger/nvim-dap",
        },
        config = function()
          require("mason-nvim-dap").setup({
            ensure_installed = require("vimrc.dap").get_dap_adapters(),
            handlers = {},
          })
        end,
      },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "mfussenegger/nvim-dap",
          "nvim-neotest/nvim-nio",
        },
        config = function()
          require("dapui").setup()

          nnoremap("<Leader>du", "<Cmd>lua require('dapui').toggle()<CR>", { desc = "Toggle Debugger UI" })
          nnoremap("<Leader>dh", "<Cmd>lua require('dap.ui.widgets').hover()<CR>", { desc = "Debugger Hover" })
          nnoremap("<Leader>dE", "<Cmd>lua require('dapui').eval()<CR>", { desc = "Debugger evaluate input" })
        end,
      },
    },
    config = function()
      nnoremap("<Leader>dc", "<Cmd>lua require('dap').continue()<CR>", { desc = "Debugger: start/continue" })
      nnoremap("<Leader>dt", "<Cmd>lua require('dap').terminate()<CR>", { desc = "Debugger: stop" })
      nnoremap("<Leader>dp", "<Cmd>lua require('dap').pause()<CR>", { desc = "Debugger: pause" })
      nnoremap("<Leader>dr", "<Cmd>lua require('dap').restart_frame()<CR>", { desc = "Debugger: restart" })
      nnoremap("<Leader>ds", "<Cmd>lua require('dap').step_over()<CR>", { desc = "Debugger: step over" })
      nnoremap("<Leader>di", "<Cmd>lua require('dap').step_into()<CR>", { desc = "Debugger: step into" })
      nnoremap("<Leader>do", "<Cmd>lua require('dap').step_out()<CR>", { desc = "Debugger: step out" })
      nnoremap("<Leader>db", "<Cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "Debugger: toggle breakpoint" })
      nnoremap("<Leader>dB", "<Cmd>lua require('dap').clear_breakpoint()<CR>", { desc = "Debugger: clear breakpoint" })
      nnoremap("<Leader>dC", function()
        vim.ui.input({ prompt = "Condition: " }, function(condition)
          if condition then require("dap").set_breakpoint(condition) end
        end)
      end, { desc = "Debugger: conditional breakpoint" })
      nnoremap("<Leader>dR", "<Cmd>lua require('dap').repl.toggle()<CR>", { desc = "Debugger: toggle REPL" })
      nnoremap("<Leader>dS", "<Cmd>lua require('dap').run_to_cursor()<CR>", { desc = "Debugger: run to cursor" })
    end,
  },
}

return dap
