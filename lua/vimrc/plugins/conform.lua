local origin_conform = require("conform")

local plugin_utils = require("vimrc.plugin_utils")

local conform = {}

conform.setup_config = function()
  local conform_config = {
    formatters_by_ft = {
      lua = {
        "stylua",
      },
      proto = {
        "buf",
      },
      python = {
        "ruff_format",
        "ruff_organize_imports",
      },
      ruby = {
        "standardrb",
      },
      rust = {
        "rustfmt",
      },
      sh = {
        "shfmt",
      },
      sql = {
        "sqlfluff",
      },
    },
  }

  -- Ref: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/formatting/prettierd.lua
  local prettierd_filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "css",
    "scss",
    "less",
    "html",
    "json",
    "jsonc",
    "yaml",
    "markdown",
    "markdown.mdx",
    "graphql",
    "handlebars",
  }
  for _, filetype in ipairs(prettierd_filetypes) do
    conform_config.formatters_by_ft[filetype] = conform_config.formatters_by_ft[filetype] or {}
    table.insert(conform_config.formatters_by_ft[filetype], "prettierd")
  end

  require("conform").setup(conform_config)
end

conform.setup_command = function()
  -- Ref: https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#format-command
  vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ["end"] = { args.line2, end_line:len() },
      }
    end
    require("conform").format({ async = true, lsp_fallback = true, range = range })
  end, { range = true })
end

conform.setup_mapping = function()
  vim.keymap.set("n", "<Space>lF", "<Cmd>Format<CR>", { silent = true,  desc = "Format by conform" })
  vim.keymap.set("x", "<Space>lF", "<Cmd>Format<CR>", { silent = true,  desc = "Format by conform" })
end

conform.setup = function()
  conform.setup_config()
  conform.setup_command()
  conform.setup_mapping()
end

return conform
