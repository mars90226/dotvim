local lsp_lines = require("lsp_lines")

local my_lsp_lines = {}

my_lsp_lines.config = {
  virtual_lines = { only_current_line = true },
}

-- FIXME: When setup `only_current_line` to true, the `CursorMoved` event for `LspLines` augroup is
-- not triggered or not working.
-- TODO: Wait for [feat(lsp) add a virtual_lines diagnostic handler by MariaSolOs · Pull Request 31959 · neovimneovim](https://github.com/neovim/neovim/pull/31959)
my_lsp_lines.toggle = function()
  -- NOTE: Use lsp_lines.toggle() to toggle lsp_lines
  lsp_lines.toggle()

  -- vim.print("lsp lines config:", vim.diagnostic.config().virtual_lines)
  -- And if enabled, set the virtual_lines config
  -- if vim.diagnostic.config().virtual_lines then
  --   vim.diagnostic.config({
  --     virtual_lines = my_lsp_lines.config.virtual_lines,
  --   })
  -- end
end

my_lsp_lines.setup_config = function()
  vim.diagnostic.config({
    virtual_lines = my_lsp_lines.config.virtual_lines,
  })
end

my_lsp_lines.setup_mapping = function()
  vim.keymap.set("n", "yoO", my_lsp_lines.toggle, { desc = "Toggle lsp_lines" })
end

my_lsp_lines.setup = function()
  lsp_lines.setup()
  -- my_lsp_lines.setup_config()
  my_lsp_lines.setup_mapping()

  my_lsp_lines.toggle() -- disable by default
end

return my_lsp_lines
