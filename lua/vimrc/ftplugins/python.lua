local utils = require("vimrc.utils")

local M = {}

local pylsp_linter_enable = true

M.pylsp_default_settings = {
  pylsp = {
    plugins = {
      flake8 = {
        config = ".flake8",
        enabled = false,
      },
      pyflakes = {
        enabled = false,
      },
      pylint = {
        enabled = false,
      },
      ruff = {
        enabled = true, -- Enable the plugin
        formatEnabled = true, -- Enable formatting using ruffs formatter
        extendSelect = { "I" }, -- Rules that are additionally used by ruff
        extendIgnore = { "C90" }, -- Rules that are additionally ignored by ruff
        format = { "I" }, -- Rules that are marked as fixable by ruff that should be fixed when running textDocument/formatting
        severities = { ["D212"] = "I" }, -- Optional table of rules where a custom severity is desired
        unsafeFixes = false, -- Whether or not to offer unsafe fixes as code actions. Ignored with the "Fix All" action

        -- Rules that are ignored when a pyproject.toml or ruff.toml is present:
        lineLength = 88, -- Line length to pass to ruff checking and formatting
        exclude = { "__about__.py" }, -- Files to be excluded by ruff checking
        select = { "F" }, -- Rules to be enabled by ruff
        ignore = { "D210" }, -- Rules to be ignored by ruff
        perFileIgnores = { ["__init__.py"] = "CPY001" }, -- Rules that should be ignored for specific files
        preview = false, -- Whether to enable the preview style linting and formatting.
        targetVersion = "py310", -- The minimum python version to target (applies for both linting and formatting).
      },
    },
  },
}

M.enable_pylsp_linter = function(enable)
  pylsp_linter_enable = enable
  require("vimrc.lsp").notify_settings("pylsp", {
    pylsp = {
      plugins = {
        ruff = {
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
  -- TODO: May raise it as we only use ruff which is fast.
  local pylsp_lint_max_filesize = 2 * 1024 * 1024 -- 2 MB
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
  vim.keymap.set("n", "yoL", function()
    M.toggle_pylsp_linter()
  end, { silent = true, buffer = true })
end

return M
