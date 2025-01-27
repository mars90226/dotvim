local diagnostic = {}

diagnostic.config = {
  enable = true,
  enable_virtual_lines = true,
  -- NOTE: neovim built-in virtual_lines implementation in neovim nightly 0.11.0
  -- Ref: https://github.com/neovim/neovim/pull/31959
  virtual_lines = {
    -- TODO: Still have 2 issues:
    -- 1. Doesn't update when the file is first loaded.
    -- 2. After reload by `:edit`, if there's diagnostic on the current line, that virtual lines
    -- will not be hidden when cursor is moved to another line.
    -- These issues seems to related to the LSP. And the first seems to happen when LSP finishes
    -- loading.
    current_line = true,
  },
}

diagnostic.toggle = function()
  diagnostic.config.enable = not diagnostic.config.enable
  vim.diagnostic.enable(diagnostic.config.enable)
end

diagnostic.toggle_virtual_lines = function()
  diagnostic.config.enable_virtual_lines = not diagnostic.config.enable_virtual_lines
  vim.diagnostic.config({
    virtual_lines = diagnostic.config.enable_virtual_lines and diagnostic.config.virtual_lines or false,
  })
end

diagnostic.setup = function()
  vim.diagnostic.config({
    virtual_text = {
      source = "if_many",
    },
    virtual_lines = diagnostic.config.virtual_lines,
    float = {
      source = "if_many",
    },
    signs = {
      text = {
        -- icons / text used for a diagnostic
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
  })

  vim.keymap.set("n", "]d", [[<Cmd>lua vim.diagnostic.goto_next()<CR>]], { silent = true })
  vim.keymap.set("n", "[d", [[<Cmd>lua vim.diagnostic.goto_prev()<CR>]], { silent = true })
  vim.keymap.set("n", "go", [[<Cmd>lua vim.diagnostic.open_float()<CR>]], { silent = true })
  vim.keymap.set("n", "yoo", diagnostic.toggle, { desc = "Diagnostic - Toggle" })
  vim.keymap.set("n", "yoO", diagnostic.toggle_virtual_lines, { desc = "Diagnostic - Toggle virtual_lines" })
end

return diagnostic
