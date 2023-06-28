local plugin_utils = require("vimrc.plugin_utils")

local formatter = {}

formatter.setup = function()
  local formatter_config = {
    filetype = {
      lua = {
        plugin_utils.check_executable(require("formatter.filetypes.lua").stylua, "stylua"),
      },
      ruby = {
        plugin_utils.check_executable(require("formatter.filetypes.ruby").standardrb, "standardrb"),
      },
      rust = {
        plugin_utils.check_executable(require("formatter.filetypes.rust").rustfmt, "rustfmt"),
      },
      sh = {
        plugin_utils.check_executable(require("formatter.filetypes.sh").shfmt, "shfmt"),
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
    formatter_config.filetype[filetype] = formatter_config.filetype[filetype] or {}
    table.insert(
      formatter_config.filetype[filetype],
      plugin_utils.check_executable(require("formatter.defaults.prettierd"), "prettierd")
    )
  end

  require("formatter").setup(formatter_config)

  nnoremap("<Leader>ff", "<Cmd>Format<CR>", "silent")
end

return formatter
