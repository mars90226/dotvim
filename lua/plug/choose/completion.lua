local choose = require("vimrc.choose")

local completion = {}

completion.setup = function()
  -- Choose autocompletion plugin
  -- nvim-cmp

  -- nvim-lsp for builtin neovim lsp
  -- builtin neovim lsp should be fast enough to be used in light vim mode

  -- Choose auto pairs plugin
  -- nvim-autopairs

  -- Context in winbar
  choose.disable_plugin("nvim-navic")
  if vim.fn.has("nvim-0.8") == 1 and choose.is_enabled_plugin("nvim-lsp") then
    choose.enable_plugin("nvim-navic")
  end

  -- Context in statusbar
  if not choose.is_enabled_plugin("nvim-lsp") or choose.is_enabled_plugin("nvim-navic") then
    choose.disable_plugin("lsp-status")
  end
end

return completion
