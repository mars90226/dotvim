local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local language = {}

language.setup = function()
  -- Highlight {{{
  -- nvim-treesitter for builtin neovim treesitter
  choose.disable_plugin("nvim-treesitter")
  if not utils.is_light_vim_mode() and plugin_utils.has_linux_build_env() then
    choose.enable_plugin("nvim-treesitter")
  end

  -- Enable lsp-based highlighting
  -- vim-lsp-cxx-highlight for highlighting using lsp
  -- Do not vim-lsp-cxx-highlight when nvim-treesitter as nvim-treesitter cannot
  -- recognize C/C++ macro semantics.
  -- }}}

  -- Lint {{{
  -- Choose Lint plugin
  -- null-ls.nvim
  -- Always enable nvim-lint

  -- Choose markdown-preview plugin
  -- vim-markdown-composer, markdown-preview.nvim
  -- TODO: Check if which plugin works
  -- TODO: Remove vim-markdown-composer
  choose.disable_plugins({ "vim-markdown-composer", "markdown-preview.nvim" })
  if vim.fn["vimrc#plugin#check#has_cargo"]() then
    choose.enable_plugin("vim-markdown-composer")
  else
    choose.enable_plugin("markdown-preview.nvim")
  end

  -- Enable language documentation generation
  -- vim-doge for generating documentation
  choose.disable_plugin("vim-doge")
  if plugin_utils.is_executable("node") and plugin_utils.is_executable("npm") then
    choose.enable_plugin("vim-doge")
  end

  -- Choose context plugin
  -- nvim-treesitter-context
  choose.disable_plugins({ "nvim-treesitter-context" })
  if choose.is_enabled_plugin("nvim-treesitter") then
    choose.enable_plugin("nvim-treesitter-context")
  end

  -- Context in statusline
  if not choose.is_enabled_plugin("nvim-treesitter") or choose.is_enabled_plugin("nvim-navic") then
    choose.disable_plugin("nvim-gps")
  end
end

return language
