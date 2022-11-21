local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local plugin_choose = {}

plugin_choose.setup_appearance = function()
  -- Statusline
  -- lualine.nvim

  -- Tabline
  -- tabby.nvim, luatab.nvim, tabline.nvim, barbar.nvim, or tabline bundled in statusline

  -- Winbar
  -- custom winbar, lualine.nvim, lspsaga.nvim
  choose.disable_plugins({ "winbar", "lualine.nvim-winbar", "lspsaga.nvim-winbar" })
  if vim.fn.has("nvim-0.8") == 1 then
    -- choose.enable_plugin("winbar")
    choose.enable_plugin("lualine.nvim-winbar")
    -- choose.enable_plugin("lspsaga-nvim-winbar")
  end

  -- Choose tabline bundled in statusline
  -- TODO: Disable tabline.nvim due to lack of normal tabline
  -- TODO: Disable barbar.nvim due to slowness
  -- TODO: Is fast in LunarVim, need to study why
  -- TODO: Disable tabby.nvim due to relative large CPU usage in background

  -- Devicons
  -- nvim-web-devicons, vim-devicons
end

plugin_choose.setup_completion = function()
  -- Choose autocompletion plugin
  -- nvim-cmp

  -- nvim-lsp for builtin neovim lsp
  -- builtin neovim lsp should be fast enough to be used in light vim mode

  -- Choose auto pairs plugin
  -- nvim-autopairs
end

plugin_choose.setup_file_explorer = function()
  -- Choose file explorer
  -- defx.nvim
  choose.disable_plugins({ "defx.nvim" })
  if vim.fn["vimrc#plugin#check#python_version"]() >= "3.6.1" then
    choose.enable_plugin("defx.nvim")
  end

  -- NOTE: Always use neo-tree.nvim
  -- TODO: Remove others
end

plugin_choose.setup_finder = function()
  -- Choose finder plugin
  -- telescope.nvim

  if not plugin_utils.has_linux_build_env() then
    choose.disable_plugin("telescope-fzf-native.nvim")
  end
end

plugin_choose.setup_git = function()
  -- Choose between git-gutter plugin
  -- gitsigns.nvim
  -- TODO: Check for git version >= 2.13.0

  -- Choose git-blame plugin
  -- gitsigns.nvim
  -- TODO: Check for git version >= 2.13.0
end

plugin_choose.setup_language = function()
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

  -- Choose context component (statusline, winbar) plugin
  -- glepnir/lspsaga.nvim, nvim-navic, nvim-gps
  local context_component_plugins = { "lspsaga.nvim-context", "nvim-navic", "nvim-gps" }
  choose.disable_plugins(context_component_plugins)
  if vim.fn.has("nvim-0.8") == 1 and choose.is_enabled_plugin("nvim-lsp") then
    -- NOTE: Disable lspsaga.nvim as it request lsp symbols on every CursorMoved which is too slow
    -- choose.enable_plugin("lspsaga.nvim-context")
    choose.enable_plugin("nvim-navic")
  elseif choose.is_enabled_plugin("nvim-treesitter") then
    choose.enable_plugin("nvim-gps")
  end

  -- Choose context plugin
  -- nvim-treesitter-context
  -- NOTE: Only for default enable/disable
  if choose.is_disabled_plugin("nvim-treesitter") then
    choose.disable_plugin("nvim-treesitter-context")
  end
  for _, context_component_plugin in ipairs(context_component_plugins) do
    if choose.is_enabled_plugin(context_component_plugin) then
      choose.disable_plugin("nvim-treesitter-context")
      break
    end
  end
end

plugin_choose.setup_misc = function()
  if vim.fn.has("python") == 0 and vim.fn.has("python3") == 0 then
    choose.disable_plugin("vim-mundo")
  end

  -- Choose highlight plugin
  -- builtin vim.highlight

  -- Disable vim-gutentags when in nested neovim
  if vim.fn["vimrc#plugin#check#nvim_terminal"]() == "yes" then
    choose.disable_plugin("vim-gutentags")
  end

  if vim.fn["vimrc#plugin#check#has_browser"]() == 0 then
    choose.disable_plugin("open-browser.vim")
  end

  -- Choose indent line plugin
  -- indent-blankline.nvim

  -- Choose window switching plugin
  -- nvim-window

  -- Choose colorizer plugin
  -- nvim-colorizer.lua
end

plugin_choose.setup_terminal = function()
  -- Choose terminal plugin
  -- vim-floaterm, neoterm
  -- Currently, always enable neoterm plugin
end

plugin_choose.setup_text_navigation = function()
  -- Choose quick navigation plugin
  -- hop.nvim, lightspeed.nvim

  -- Choose search utility plugin
  -- nvim-hlslens
end

plugin_choose.setup = function()
  -- plugin management
  vim.api.nvim_create_user_command("ListDisabledPlugins", function()
    choose.print_disabled_plugins()
  end, {})

  -- Start choosing
  choose.clear_disabled_plugins()

  plugin_choose.setup_appearance()
  plugin_choose.setup_completion()
  plugin_choose.setup_file_explorer()
  plugin_choose.setup_finder()
  plugin_choose.setup_text_navigation()
  plugin_choose.setup_language()
  plugin_choose.setup_git()
  plugin_choose.setup_terminal()
  plugin_choose.setup_misc()
end

return plugin_choose
