local utils = require("vimrc.utils")

local M = {}

local pylsp_linter_enable = true

M.enable_pylsp_linter = function(enable)
  pylsp_linter_enable = enable
  require("vimrc.lsp").notify_settings("pylsp", {
    pylsp = {
      plugins = {
        flake8 = {
          config = ".flake8",
          enabled = enable,
        },
        pyflakes = {
          enabled = enable,
        },
      },
    },
  })
end

M.toggle_pylsp_linter = function()
  M.enable_pylsp_linter(not pylsp_linter_enable)
end

M.check_pylsp_linter_feasibility = function(bufnr)
  local pylsp_lint_max_filesize = 400 * 1024 -- 400 KB
  local filesize = utils.get_buf_size(bufnr) or 0

  if filesize >= pylsp_lint_max_filesize then
    local delay = 10000 -- HACK: Wait 10 seconds for pylsp to finish linting and then disable linters
    vim.defer_fn(function()
      -- Disable pylsp linters for big files
      M.enable_pylsp_linter(false)
    end, delay)
  end
end

M.setup_mappings = function()
  nnoremap("yoL", function()
    M.toggle_pylsp_linter()
  end, { silent = true, buffer = true })
end

return M
