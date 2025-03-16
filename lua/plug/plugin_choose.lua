local check = require("vimrc.check")
local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local plugin_choose = {}

plugin_choose.setup_appearance = function()
  -- Statusline
  -- lualine.nvim

  -- Tabline
  -- lualine.nvim

  -- Winbar
  -- dropbar.nvim-winbar, lualine.nvim
  choose.disable_plugins({ "dropbar.nvim-winbar", "lualine.nvim-winbar" })
  choose.enable_plugin("dropbar.nvim-winbar")

  -- Statuscolumn
  -- snacks.nvim-statuscolumn

  -- Devicons
  -- nvim-web-devicons, vim-devicons

  -- UI (vim.ui.input, vim.ui.select)
  -- snacks.nvim
end

plugin_choose.setup_completion = function()
  -- Choose auto-completion plugin
  -- nvim-cmp

  -- nvim-lsp for builtin neovim lsp
  -- builtin neovim lsp should be fast enough to be used in light vim mode

  -- Choose LSP capabilities
  -- LSP `workspace/didChangeWatchedFiles` capability
  if utils.is_light_vim_mode() or (check.os_is("Linux") and not plugin_utils.is_executable("fswatch")) then
    choose.disable_plugin("nvim-lsp-workspace-didChangeWatchedFiles")
  end

  -- Choose specific lsp plugin
  -- rustaceanvim
  choose.disable_plugin("rustaceanvim")
  if check.has_linux_build_env() then
    choose.enable_plugin("rustaceanvim")
  end
  
  -- Choose nvim-cmp source plugin
  -- cmp-dictionary
  -- TODO: Monitor the performance
  if not plugin_utils.get_dictionary() then
    choose.disable_plugin("cmp-dictionary")
  end
  -- cmp-tmux
  if not utils.is_main_vim_mode() then
    choose.disable_plugin("cmp-tmux")
  end
  -- cmp-calc
  if not utils.is_main_vim_mode() then
    choose.disable_plugin("cmp-calc")
  end
  -- cmp-treesitter
  if not utils.is_main_vim_mode() then
    choose.disable_plugin("cmp-treesitter")
  end
  -- cmp-git
  if not utils.is_main_vim_mode() then
    choose.disable_plugin("cmp-git")
  end
  -- cmp-rg
  -- TODO: Monitor the performance
  if not plugin_utils.is_executable("rg") then
    choose.disable_plugin("cmp-rg")
  end
  -- tailwindcss-colorizer-cmp.nvim
  if not utils.is_main_vim_mode() then
    choose.disable_plugin("tailwindcss-colorizer-cmp.nvim")
  end

  -- Choose snippet plugin
  -- LuaSnip

  -- Enable placeholder transformations
  if choose.is_disabled_plugin("LuaSnip") or not check.has_linux_build_env() then
    choose.disable_plugin("LuaSnip-transform")
  end

  -- Choose linter integration plugin
  -- nvim-lint

  -- Choose formatter integration plugin
  -- conform.nvim

  -- Choose auto pairs plugin
  -- nvim-autopairs
end

plugin_choose.setup_ai = function()
  -- Choose copilot
  -- copilot.lua, CopilotChat.nvim
  if not check.has_linux_build_env() then
    choose.disable_plugin("copilot.lua")
    choose.disable_plugin("copilot-cmp")
    choose.disable_plugin("CopilotChat.nvim")
  end

  -- Choose AI
  -- avante.nvim, codecompanion.nvim
  if choose.is_disabled_plugin("copilot.lua") then
    choose.disable_plugin("avante.nvim")
    choose.disable_plugin("codecompanion.nvim")
  end

  -- Choose MCP
  -- mcphub.nvim
  if choose.is_disabled_plugin("copilot.lua") then
    choose.disable_plugin("mcphub.nvim")
  end
end

plugin_choose.setup_file_explorer = function()
  -- Choose file explorer
  -- oil.nvim, defx.nvim
  choose.disable_plugins({ "defx.nvim" })

  local python_version = check.python_version()
  if not utils.is_light_vim_mode() and python_version ~= "" and vim.version.cmp(python_version, "3.6.1") >= 0 then
    choose.enable_plugin("defx.nvim")
  end
  -- Always use oil.nvim
end

plugin_choose.setup_finder = function()
  -- Choose finder plugin
  -- telescope.nvim

  if not check.has_linux_build_env() then
    choose.disable_plugin("telescope-fzf-native.nvim")
  end
end

plugin_choose.setup_git = function()
  -- Choose between git-gutter plugin
  -- gitsigns.nvim

  -- Choose git-blame plugin
  -- gitsigns.nvim
end

plugin_choose.setup_language = function()
  -- Highlight {{{
  -- nvim-treesitter for builtin neovim treesitter
  choose.disable_plugin("nvim-treesitter")
  if check.has_linux_build_env() then
    choose.enable_plugin("nvim-treesitter")
  end

  -- Lint {{{
  -- Choose Lint plugin
  -- nvim-lint

  -- Choose Markdown render plugin
  -- markview.nvim, render-markdown.nvim
  choose.disable_plugins({ "markview.nvim", "render-markdown.nvim" })
  choose.enable_plugin("markview.nvim")
  -- choose.enable_plugin("render-markdown.nvim")

  -- Choose markdown-preview plugin
  -- markdown-preview.nvim

  -- Enable language documentation generation
  -- neogen for generating documentation

  -- Choose context component (statusline, winbar) plugin
  -- dropbar.nvim, nvim-navic
  local context_component_plugins = { "dropbar.nvim", "nvim-navic" }
  choose.disable_plugins(context_component_plugins)
  choose.enable_plugin("dropbar.nvim")
  -- nvim-navic is required by nvim-navbuddy
  choose.enable_plugin("nvim-navic")

  -- Choose breadcrumbs plugin
  -- nvim-navbuddy
  choose.disable_plugin("nvim-navbuddy")
  if choose.is_enabled_plugin("nvim-navic") then
    choose.enable_plugin("nvim-navbuddy")
  end

  -- Choose context plugin
  -- nvim-treesitter-context
  -- NOTE: Only for default enable/disable
  if choose.is_disabled_plugin("nvim-treesitter") then
    choose.disable_plugin("nvim-treesitter-context")
  end

  -- Choose spell check plugin
  -- neovim 0.8

  -- Choose documentation plugin
  -- devdocs.nvim
  choose.disable_plugin("devdocs.nvim")
  if plugin_utils.is_executable("jq") and plugin_utils.is_executable("curl") and plugin_utils.is_executable("pandoc") then
    choose.enable_plugin("devdocs.nvim")
  end
end

plugin_choose.setup_misc = function()
  if utils.is_light_vim_mode() or (vim.fn.has("python") == 0 and vim.fn.has("python3") == 0) then
    choose.disable_plugin("vim-mundo")
  end

  -- Choose highlight plugin
  -- builtin vim.highlight

  -- Disable vim-gutentags when in nested neovim
  if utils.is_light_vim_mode() or check.in_nvim_terminal() then
    choose.disable_plugin("vim-gutentags")
  end

  if not check.has_browser() then
    choose.disable_plugin("open-browser.vim")
  end

  -- Choose indent line plugin
  -- snacks.nvim-indent

  -- Choose window switching plugin
  -- nvim-window-picker

  -- Choose colorizer plugin
  -- nvim-colorizer.lua
end

plugin_choose.setup_terminal = function()
  -- Choose terminal plugin
  -- vim-floaterm
end

plugin_choose.setup_text_manipulation = function()
  -- Choose surround plugin
  -- nvim-surround
end

plugin_choose.setup_text_navigation = function()
  -- Choose quick navigation plugin
  -- hop.nvim, lightspeed.nvim, flash.nvim

  -- Choose search utility plugin
  -- nvim-hlslens
end

plugin_choose.setup_luarocks_plugin = function()
  local is_luarocks_available = plugin_utils.is_executable("luarocks")

  -- Choose neorg
  if not is_luarocks_available then
    choose.disable_plugin("neorg")
  end

  -- Choose image
  if not is_luarocks_available then
    choose.disable_plugin("image.nvim")
  end
end

plugin_choose.setup = function()
  -- plugin management
  vim.api.nvim_create_user_command("ListDisabledPlugins", function()
    choose.print_disabled_plugins()
  end, {})

  -- Start choosing
  choose.clear_disabled_plugins()

  -- TODO: Think of a better way to massively disable plugins in light mode that fit current architecture
  plugin_choose.setup_appearance()
  plugin_choose.setup_completion()
  plugin_choose.setup_ai()
  plugin_choose.setup_file_explorer()
  plugin_choose.setup_finder()
  plugin_choose.setup_text_manipulation()
  plugin_choose.setup_text_navigation()
  plugin_choose.setup_language()
  plugin_choose.setup_git()
  plugin_choose.setup_terminal()
  plugin_choose.setup_misc()
  plugin_choose.setup_luarocks_plugin()
end

return plugin_choose
