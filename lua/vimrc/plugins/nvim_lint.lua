local lint = require("lint")

local nvim_lint = {}

nvim_lint.config = {
  enable = true,
}

nvim_lint.toggle_enable = function()
  nvim_lint.config.enable = not nvim_lint.config.enable
  vim.notify("nvim-lint is " .. (nvim_lint.config.enable and "enabled" or "disabled"))
end

nvim_lint.try_lint = function()
  if nvim_lint.config.enable then
    require('lint').try_lint()
  end
end

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
    markdown = { "markdownlint" },
    python = { "mypy", "pylint" },
    sh = { "shellcheck" },
  }

  nnoremap("<Space>ll", "<Cmd>lua require('lint').try_lint()<CR>", "silent")
  nnoremap("col", "<Cmd>lua require('vimrc.plugins.nvim_lint').toggle_enable()<CR>", "silent")

  -- Add errorformat for 'markdownlint'
  -- FIXME: Cannot use vim.opt, it will break 'errorformat'.
  -- vim.opt.errorformat:append('%f:%l %m')
  vim.cmd([[set errorformat+=%f:%l\ %m]])

  vim.cmd([[augroup nvim_lint_settings]])
  vim.cmd([[  autocmd!]])
  vim.cmd([[  autocmd BufWritePost * lua require('vimrc.plugins.nvim_lint').try_lint()]])
  vim.cmd([[augroup END]])
end

return nvim_lint
