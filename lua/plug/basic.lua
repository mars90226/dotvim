local check = require("vimrc.check")
local plugin_utils = require("vimrc.plugin_utils")

local basic = {}

basic.setup_python_host = function(defer_discovery)
  if vim.g.loaded_python3_provider == 0 then
    vim.g.python_provider_unavailable = true
    return
  end
  if vim.g.python3_host_prog ~= nil then
    require("vimrc.python_provider").use_explicit_host(vim.g.python3_host_prog)
  end
  -- Explicit/local hosts win. Other Linux hosts use a validated cache with expiry;
  -- discovery is independent of the current project directory.
  if check.os_is("Linux") and check.os_is("synology") then
    -- Preserve the legacy DSM defaults without overriding an explicit host.
    if vim.g.python_host_prog == nil then
      vim.g.python_host_prog = "/bin/python"
    end
    if vim.g.python3_host_prog == nil then
      local kernel_version = plugin_utils.get_kernel_version()
      if kernel_version > plugin_utils.KERNEL_VERSIONS.SYNOLOGY_DSM_7 then
        vim.g.python3_host_prog = "/bin/python3"
      else
        vim.g.python3_host_prog = "/usr/local/bin/python3"
      end
    end
  elseif not defer_discovery and check.os_is("Linux") and vim.g.python3_host_prog == nil then
    local host, version = require("vimrc.python_provider").resolve_python_host()
    vim.g.python_provider_unavailable = host == nil
    if not host then
      -- Do not let builtin detection bypass the failed, bounded discovery.
      -- A configured host or another attempt takes effect in a new session.
      vim.g.loaded_python3_provider = 0
    end
    if host then
      vim.g.python3_host_prog = host
      vim.g.python_version = version
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
  basic.setup_python_host(true)

  -- disable builtin plugin
  basic.disable_builtin_plugin()

  -- plugin secret
  basic.setup_secret()

  -- plugin local
  basic.setup_local()

  -- Machine-local/explicit settings take precedence over automatic discovery.
  basic.setup_python_host()
end

return basic
