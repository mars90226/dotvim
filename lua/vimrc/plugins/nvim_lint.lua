local lint = require("lint")

local nvim_lint = {}

nvim_lint.setup = function()
  -- Custom linters
  lint.linters.gitlint = {
    cmd = "gitlint",
    stdin = true,
    args = { "--msg-filename", "-" },
    stream = "stderr",
    ignore_exitcode = true,
    env = nil,
    parser = require("lint.parser").from_pattern([[(%d+): (%w+) (.+)]], { "lnum", "code", "message" }),
  }

  -- Customize built-in linter parameters
  require("lint.linters.shellcheck").args = {
    "-x",
    "--format",
    "json",
    "-",
  }

  -- Setup linter
  -- TODO: Check for executable
  lint.linters_by_ft = {
    gitcommit = { "gitlint" },
    javascript = { "jshint" },
    python = { "mypy", "pylint" },
    sh = { "shellcheck" },
  }

  nnoremap("<Space>ll", "<Cmd>lua require('lint').try_lint()<CR>", "silent")

  vim.cmd([[augroup nvim_lint_settings]])
  vim.cmd([[  autocmd!]])
  vim.cmd([[  autocmd BufWritePost * lua require('lint').try_lint()]])
  vim.cmd([[augroup END]])
end

return nvim_lint
