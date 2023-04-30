local plugin_utils = require("vimrc.plugin_utils")

local autocmd = {}

autocmd.setup = function()
  local use_config = function(plugin_spec)
    plugin_spec.config()
  end

  use_config({
    "mars90226/autocmd",
    config = function()
      -- Input Method autocmd
      local input_method_augroup_id = vim.api.nvim_create_augroup("input_method_settings", {})
      vim.api.nvim_create_autocmd({ "InsertEnter" }, {
        group = input_method_augroup_id,
        pattern = "*",
        callback = function()
          vim.bo.iminsert = 1
        end,
      })
      vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        group = input_method_augroup_id,
        pattern = "*",
        callback = function()
          vim.bo.iminsert = 0
        end,
      })

      -- Prompt buffer settings
      -- FIXME: not work
      -- local prompt_buffer_augroup_id = vim.api.nvim_create_augroup("prompt_buffer_settings", {})
      -- vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
      --   group = prompt_buffer_augroup_id,
      --   pattern = "*",
      --   callback = function()
      --     if vim.bo.buftype == 'prompt' then
      --       inoremap("<C-W>", "<C-S-W>", "<buffer>")
      --       inoremap("<A-w>", "<C-W>", "<buffer>")
      --     end
      --   end,
      -- })

      -- Command-line window settings
      local cmdline_window_augroup_id = vim.api.nvim_create_augroup("cmdline_window_settings", {})
      vim.api.nvim_create_autocmd({ "CmdwinEnter" }, {
        group = cmdline_window_augroup_id,
        pattern = "*",
        callback = function()
          require("vimrc.cmdwin").setup()
        end,
      })

      -- Highlight yank
      local highlight_yank_augroup_id = vim.api.nvim_create_augroup("highlight_yank", {})
      vim.api.nvim_create_autocmd({ "TextYankPost" }, {
        group = highlight_yank_augroup_id,
        pattern = "*",
        callback = function()
          vim.highlight.on_yank({ timeout = 200 })
        end,
      })

      -- Secret project local settings
      if vim.fn.exists("*VimSecretProjectLocalSettings") ~= 0 then
        vim.fn["VimSecretProjectLocalSettings"]()
      end

      -- Machine-local project local settings
      if vim.fn.exists("*VimLocalProjectLocalSettings") ~= 0 then
        vim.fn["VimLocalProjectLocalSettings"]()
      end
    end,
  })
end

return autocmd