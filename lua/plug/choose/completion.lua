local plugin_utils = require("vimrc.plugin_utils")

local completion = {}

completion.setup = function()
  -- Choose autocompletion plugin
  -- nvim-cmp

  -- nvim-lsp for builtin neovim lsp
  -- builtin neovim lsp should be fast enough to be used in light vim mode

  -- Choose auto pairs plugin
  -- nvim-autopairs

  -- Context in winbar
  vim.fn["vimrc#plugin#disable_plugin"]("nvim-navic")
  if vim.fn.has("nvim-0.8") == 1 and vim.fn["vimrc#plugin#is_enabled_plugin"]("nvim-lsp") then
    vim.fn["vimrc#plugin#enable_plugin"]("nvim-navic")
  end

  -- Context in statusbar
  if not plugin_utils.is_enabled_plugin("nvim-lsp") or plugin_utils.is_enabled_plugin("nvim-navic") then
    vim.fn["vimrc#plugin#disable_plugin"]("lsp-status")
  end
end

return completion
