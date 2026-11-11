local codesettings = {}

codesettings.before_init = function(params, config)
  local root = config.root_dir
  if type(root) == "string" then
    root = vim.fs.root(root, { { ".vscode", ".neoconf.json", "codesettings.json", "lspsettings.json", ".git", ".jj" } })
      or root
  end

  local eslint_settings = config.name == "eslint" and vim.deepcopy(config.settings or {})
  require("codesettings").with_local_settings(config.name, config, { root_dir = root })

  if eslint_settings then
    -- VS Code's ESLint extension uses different types and names than the server.
    local settings = config.settings
    if type(settings.validate) == "table" then
      settings.validate = eslint_settings.validate or "on"
    end
    if type(settings.format) == "table" then
      local enable = settings.format.enable
      if type(enable) == "boolean" then
        settings.format = enable
      else
        settings.format = eslint_settings.format
      end
    end
    if type(settings.codeActionsOnSave) == "table" then
      settings.codeActionOnSave =
        vim.tbl_deep_extend("force", settings.codeActionOnSave or {}, settings.codeActionsOnSave)
      settings.codeActionsOnSave = nil
    end
  end

  if config.name == "rust-analyzer" then
    params.initializationOptions = vim.tbl_deep_extend(
      "force",
      params.initializationOptions or {},
      vim.tbl_get(config.settings, "rust-analyzer") or {}
    )
  end
end

return codesettings
