local diagnostic = {}

diagnostic.config = {
  enable = true,
  enable_virtual_lines = true,
  virtual_text = {
    source = "if_many",
    current_line = false,
  },
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

  -- If virtual_lines is enabled, disable current_line for virtual_text.
  -- Otherwise, set it to nil to show diagnostic on all lines.
  if diagnostic.config.enable_virtual_lines then
    diagnostic.config.virtual_text.current_line = false
  else
    diagnostic.config.virtual_text.current_line = nil
  end

  vim.diagnostic.config({
    virtual_text = diagnostic.config.virtual_text,
    virtual_lines = diagnostic.config.enable_virtual_lines and diagnostic.config.virtual_lines or false,
  })
end

diagnostic.setup = function()
  vim.diagnostic.config({
    virtual_text = diagnostic.config.virtual_text,
    virtual_lines = diagnostic.config.virtual_lines,
    float = {
      source = "if_many",
      border = "rounded",
    },
    signs = {
      text = {
        -- icons / text used for a diagnostic
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticError",
        [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
        [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
        [vim.diagnostic.severity.HINT] = "DiagnosticHint",
      },
    },
  })

  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, { silent = true })
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, { silent = true })
  vim.keymap.set("n", "go", function() vim.diagnostic.open_float() end, { silent = true })
  vim.keymap.set("n", "yoo", diagnostic.toggle, { desc = "Diagnostic - Toggle" })
  vim.keymap.set("n", "yoO", diagnostic.toggle_virtual_lines, { desc = "Diagnostic - Toggle virtual_lines" })
end

return diagnostic
