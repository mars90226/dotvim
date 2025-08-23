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

      -- -- Detect pyenv
      -- -- TODO: Add function to change python host program
      -- if plugin_utils.file_readable(vim.env.HOME .. "/.pyenv/shims/python") then
      --   vim.g.python_host_prog = vim.env.HOME .. "/.pyenv/shims/python"
      -- end
      -- if plugin_utils.file_readable(vim.env.HOME .. "/.pyenv/shims/python3") then
      --   vim.g.python3_host_prog = vim.env.HOME .. "/.pyenv/shims/python3"
      -- end

      -- Detect uv
      -- NOTE: Need to monitor if this breaks
      -- This Neovim PR add detection for pynvim-python added in pynvim 0.6.0 and recommend using uv
      -- for python virtual environment.
      -- Ref: https://github.com/neovim/neovim/pull/35273
      if plugin_utils.is_executable("uv") then
        local result = vim.system({"uv", "python", "find", "python"}):wait()
        if result and result.code == 0 then
          vim.g.python_host_prog = vim.trim(result.stdout)
        end
      end
      if plugin_utils.is_executable("uv") then
        local result = vim.system({"uv", "python", "find", "python3"}):wait()
        if result and result.code == 0 then
          vim.g.python3_host_prog = vim.trim(result.stdout)
        end
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
  require("vimrc.secret").setup()
end

basic.setup_local = function()
  require("vimrc.localconfig").setup()
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
