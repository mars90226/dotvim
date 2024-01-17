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

      -- Disable 'cursorline' on diff mode
      -- NOTE: 'cursorline' cause redraw when cursor is on fold text and is very slow on large fold
      -- text. Because large fold text frequently appears in diff mode, disable 'cursorline' in diff
      -- mode.
      local disable_cursorline_on_diff_augroup_id = vim.api.nvim_create_augroup("disable_cursorline_on_diff_augroup_id", {})
      vim.api.nvim_create_autocmd({ "OptionSet" }, {
        group = disable_cursorline_on_diff_augroup_id,
        pattern = "diff",
        callback = function()
          if vim.api.nvim_get_option_value("diff", {}) then
            vim.opt.cursorline = false
          else
            vim.opt.cursorline = true
          end
        end,
      })
    end,
  })
end

return autocmd
