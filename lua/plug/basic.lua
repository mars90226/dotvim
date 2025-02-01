local check = require("vimrc.check")
local plugin_utils = require("vimrc.plugin_utils")

local basic = {}

basic.setup_python_host = function()
  -- Python & Python3 setting for Windows & Synology should be in local vim
  -- config
  if check.os_is("Linux") then
    if check.os_is("synology") then
      local kernel_version = plugin_utils.get_kernel_version()

      if kernel_version > plugin_utils.KERNEL_VERSIONS.SYNOLOGY_DSM_7 then
        vim.g.python_host_prog = "/bin/python"
        vim.g.python3_host_prog = "/bin/python3"
      else
        vim.g.python_host_prog = "/bin/python"
        vim.g.python3_host_prog = "/usr/local/bin/python3"
      end
    else
      -- Detect asdf
      -- TODO: asdf is disabled
      -- if plugin_utils.file_readable(vim.env.HOME .. "/.asdf/shims/python") then
      --   vim.g.python_host_prog = vim.env.HOME .. "/.asdf/shims/python"
      -- end
      -- if plugin_utils.file_readable(vim.env.HOME .. "/.asdf/shims/python3") then
      --   vim.g.python3_host_prog = vim.env.HOME .. "/.asdf/shims/python3"
      -- end

      -- Detect pyenv
      -- TODO: Add function to change python host program
      if plugin_utils.file_readable(vim.env.HOME .. "/.pyenv/shims/python") then
        vim.g.python_host_prog = vim.env.HOME .. "/.pyenv/shims/python"
      end
      if plugin_utils.file_readable(vim.env.HOME .. "/.pyenv/shims/python3") then
        vim.g.python3_host_prog = vim.env.HOME .. "/.pyenv/shims/python3"
      end

      -- Use default Python & Python3
      if vim.g.python_host_prog == nil then
        vim.g.python_host_prog = "/usr/bin/python"
      end
      if vim.g.python3_host_prog == nil then
        vim.g.python3_host_prog = "/usr/bin/python3"
      end
    end
  end
end

basic.disable_builtin_plugin = function()
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
end

basic.setup_secret = function()
  local secret_config_vim = vim.env.HOME .. "/.vim_secret.vim"
  local secret_config_lua = vim.env.HOME .. "/.vim_secret.lua"
  local secret_config_dir = vim.env.HOME .. "/.vim_secret"

  vim.opt.runtimepath:append(secret_config_dir)

  if plugin_utils.file_readable(secret_config_vim) then
    plugin_utils.source(secret_config_vim)
  end
  if plugin_utils.file_readable(secret_config_lua) then
    plugin_utils.source(secret_config_lua)
  end
end

basic.setup_local = function()
  local local_config_vim = vim.env.HOME .. "/.vim_local.vim"
  local local_config_lua = vim.env.HOME .. "/.vim_local.lua"

  if plugin_utils.file_readable(local_config_vim) then
    plugin_utils.source(local_config_vim)
  end
  if plugin_utils.file_readable(local_config_lua) then
    plugin_utils.source(local_config_lua)
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
