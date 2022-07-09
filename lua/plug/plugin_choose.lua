local plugin_utils = require("vimrc.plugin_utils")

local plugin_choose = {}

plugin_choose.setup_python_host = function()
  -- Python & Python3 setting for Windows & Synology should be in local vim
  -- config
  local os = plugin_utils.get_os()
  if os ~= "windows" and os ~= "synology" then
    -- Detect asdf
    if plugin_utils.file_readable(vim.env.HOME .. "/.asdf/shims/python") then
      vim.g.python_host_prog = vim.env.HOME .. "/.asdf/shims/python"
    end
    if plugin_utils.file_readable(vim.env.HOME .. "/.asdf/shims/python3") then
      vim.g.python3_host_prog = vim.env.HOME .. "/.asdf/shims/python3"
    end

    -- Use default Python & Python3
    if not vim.g.python_host_prog then
      vim.g.python_host_prog = "/usr/bin/python"
    end
    if not vim.g.python3_host_prog then
      vim.g.python3_host_prog = "/usr/bin/python3"
    end
  end
end

plugin_choose.disable_builtin_plugin = function ()
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
end

plugin_choose.setup_secret = function()
  local secret_config = vim.env.HOME .. '/.vim_secret.vim'
  local secret_config_dir = vim.env.HOME .. '/.vim_secret'

  vim.opt.runtimepath:append(secret_config_dir)

  if plugin_utils.file_readable(secret_config) then
    plugin_utils.source(secret_config)
  end
end

plugin_choose.setup_local = function()
  local local_config = vim.env.HOME .. '/.vim_local.vim'

  if plugin_utils.file_readable(local_config) then
    plugin_utils.source(local_config)
  end
end

plugin_choose.setup = function()
  plugin_choose.setup_python_host()

  -- plugin management
  vim.cmd([[command! ListDisabledPlugins call vimrc#plugin#get_disabled_plugins()]])

  -- disable builtin plugin
  plugin_choose.disable_builtin_plugin()

  -- plugin secret
  plugin_choose.setup_secret()

  -- plugin local
  plugin_choose.setup_local()

  -- Start choosing
  vim.fn["vimrc#plugin#clear_disabled_plugins"]()

  require("plug.choose.appearance").setup()
  require("plug.choose.completion").setup()
  require("plug.choose.file_explorer").setup()
  require("plug.choose.finder").setup()
  require("plug.choose.text_navigation").setup()
  require("plug.choose.language").setup()
  require("plug.choose.git").setup()
  require("plug.choose.terminal").setup()
  require("plug.choose.misc").setup()
end

return plugin_choose
