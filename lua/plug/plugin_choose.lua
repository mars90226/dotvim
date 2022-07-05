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

plugin_choose.setup = function()
  plugin_choose.setup_python_host()

  -- plugin management
  vim.cmd([[command! ListDisabledPlugins call vimrc#plugin#get_disabled_plugins()]])

  -- disable builtin plugin
  vim.fn["vimrc#source"]("plug/disable_builtin.vim")

  -- plugin secret
  vim.fn["vimrc#source"]("plug/secret.vim")

  -- plugin local
  vim.fn["vimrc#source"]("plug/local.vim")

  -- Start choosing
  vim.fn["vimrc#plugin#clear_disabled_plugins"]()

  vim.fn["vimrc#source"]("plug/choose/appearance.vim")
  vim.fn["vimrc#source"]("plug/choose/completion.vim")
  vim.fn["vimrc#source"]("plug/choose/file_explorer.vim")
  vim.fn["vimrc#source"]("plug/choose/finder.vim")
  vim.fn["vimrc#source"]("plug/choose/text_navigation.vim")
  vim.fn["vimrc#source"]("plug/choose/language.vim")
  vim.fn["vimrc#source"]("plug/choose/git.vim")
  vim.fn["vimrc#source"]("plug/choose/terminal.vim")
  vim.fn["vimrc#source"]("plug/choose/misc.vim")
end

return plugin_choose
