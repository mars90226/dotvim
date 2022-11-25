local plugin_utils = require("vimrc.plugin_utils")

local basic = {}

basic.setup_python_host = function()
  -- Python & Python3 setting for Windows & Synology should be in local vim
  -- config
  if not plugin_utils.os_is("windows") and not plugin_utils.os_is("synology") then
    -- Detect asdf
    -- TODO: asdf is disabled
    -- if plugin_utils.file_readable(vim.env.HOME .. "/.asdf/shims/python") then
    --   vim.g.python_host_prog = vim.env.HOME .. "/.asdf/shims/python"
    -- end
    -- if plugin_utils.file_readable(vim.env.HOME .. "/.asdf/shims/python3") then
    --   vim.g.python3_host_prog = vim.env.HOME .. "/.asdf/shims/python3"
    -- end

    -- Use default Python & Python3
    if not vim.g.python_host_prog then
      vim.g.python_host_prog = "/usr/bin/python"
    end
    if not vim.g.python3_host_prog then
      vim.g.python3_host_prog = "/usr/bin/python3"
    end
  end
end

basic.disable_builtin_plugin = function()
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
end

basic.setup_secret = function()
  local secret_config = vim.env.HOME .. "/.vim_secret.vim"
  local secret_config_dir = vim.env.HOME .. "/.vim_secret"

  vim.opt.runtimepath:append(secret_config_dir)

  if plugin_utils.file_readable(secret_config) then
    plugin_utils.source(secret_config)
  end
end

basic.setup_local = function()
  local local_config = vim.env.HOME .. "/.vim_local.vim"

  if plugin_utils.file_readable(local_config) then
    plugin_utils.source(local_config)
  end
end

basic.setup = function()
  basic.setup_python_host()

  -- disable builtin plugin
  basic.disable_builtin_plugin()

  -- plugin secret
  basic.setup_secret()

  -- plugin local
  basic.setup_local()
end

return basic
