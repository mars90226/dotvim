local choose = require("vimrc.choose")

local dap = {
  -- Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    -- ft = require("vimrc.dap").get_filetypes(),
    -- NOTE: Only load when explicitly execute :Lazy load nvim-dap
    lazy = true,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
          "williamboman/mason.nvim",
          "mfussenegger/nvim-dap",
        },
        -- TODO: Check if this is causing issues
        -- NOTE: Not sure why nvim-lspconfig will load this module, so we need to set it to false.
        module = false,
        -- ft = require("vimrc.dap").get_filetypes(),
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

          vim.keymap.set("n", "<Leader>du", "<Cmd>lua require('dapui').toggle()<CR>", { desc = "Toggle Debugger UI" })
          vim.keymap.set("n", "<Leader>dh", "<Cmd>lua require('dap.ui.widgets').hover()<CR>", { desc = "Debugger Hover" })
          vim.keymap.set("n", "<Leader>dE", "<Cmd>lua require('dapui').eval()<CR>", { desc = "Debugger evaluate input" })
        end,
      },
      {
        "rcarriga/cmp-dap",
        dependencies = {
          -- TODO: Use 'iguanacucumber/magazine.nvim' instead of 'hrsh7th/nvim-cmp' for performance & bug
          -- fixes. Which also includes 'yioneko/nvim-cmp's performance improvements noteed in the following MR:
          -- Ref: https://github.com/hrsh7th/nvim-cmp/pull/1980
          "iguanacucumber/magazine.nvim",
          name = "nvim-cmp", -- Otherwise highlighting gets messed up
        },
        config = function()
          -- TODO: Move to nvim-cmp config?
          require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
            sources = {
              { name = "dap" },
            },
          })
        end,
      },
    },
    config = function()
      vim.keymap.set("n", "<Leader>dc", "<Cmd>lua require('dap').continue()<CR>", { desc = "Debugger: start/continue" })
      vim.keymap.set("n", "<Leader>dt", "<Cmd>lua require('dap').terminate()<CR>", { desc = "Debugger: stop" })
      vim.keymap.set("n", "<Leader>dp", "<Cmd>lua require('dap').pause()<CR>", { desc = "Debugger: pause" })
      vim.keymap.set("n", "<Leader>dr", "<Cmd>lua require('dap').restart_frame()<CR>", { desc = "Debugger: restart" })
      vim.keymap.set("n", "<Leader>ds", "<Cmd>lua require('dap').step_over()<CR>", { desc = "Debugger: step over" })
      vim.keymap.set("n", "<Leader>di", "<Cmd>lua require('dap').step_into()<CR>", { desc = "Debugger: step into" })
      vim.keymap.set("n", "<Leader>do", "<Cmd>lua require('dap').step_out()<CR>", { desc = "Debugger: step out" })
      vim.keymap.set("n", "<Leader>db", "<Cmd>lua require('dap').toggle_breakpoint()<CR>",
        { desc = "Debugger: toggle breakpoint" })
      vim.keymap.set("n", "<Leader>dB", "<Cmd>lua require('dap').clear_breakpoint()<CR>",
        { desc = "Debugger: clear breakpoint" })
      vim.keymap.set("n", "<Leader>dC", function()
        vim.ui.input({ prompt = "Condition: " }, function(condition)
          if condition then require("dap").set_breakpoint(condition) end
        end)
      end, { desc = "Debugger: conditional breakpoint" })
      vim.keymap.set("n", "<Leader>dR", "<Cmd>lua require('dap').repl.toggle()<CR>", { desc = "Debugger: toggle REPL" })
      vim.keymap.set("n", "<Leader>dS", "<Cmd>lua require('dap').run_to_cursor()<CR>",
        { desc = "Debugger: run to cursor" })
    end,
  },
}

return dap
