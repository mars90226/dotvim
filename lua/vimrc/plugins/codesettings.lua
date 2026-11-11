local codesettings = {}

codesettings.loader_extensions = function(root)
  return {
    function()
      return require("codesettings.extensions.vscode")({ root = root })
    end,
    "codesettings.extensions.neoconf",
    {
      object = function(node, context)
        if #context.path == 0 and type(node.harper) == "table" then
          node["harper-ls"] = vim.tbl_deep_extend("force", node.harper, node["harper-ls"] or {})
          node.harper = nil
        end
        return require("codesettings.extensions").Control.CONTINUE
      end,
    },
  }
end

codesettings.before_init = function(params, config)
  local root = config.root_dir
  if type(root) == "string" then
    root = vim.fs.root(root, { { ".vscode", ".neoconf.json", "codesettings.json", "lspsettings.json", ".git", ".jj" } })
      or root
  end

  local eslint_settings = config.name == "eslint" and vim.deepcopy(config.settings or {})
  require("codesettings").with_local_settings(config.name, config, {
    root_dir = root,
    loader_extensions = codesettings.loader_extensions(root),
    merge_lists = "replace",
  })

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
    if type(settings.rules) == "table" and type(settings.rules.customizations) == "table" then
      settings.rulesCustomizations = settings.rules.customizations
      settings.rules.customizations = nil
      if next(settings.rules) == nil then
        settings.rules = nil
      end
    end
    if type(settings.workingDirectories) == "table" then
      local directories = settings.workingDirectories
      if #directories == 1 and type(directories[1]) == "table" and directories[1].mode then
        settings.workingDirectory = { mode = directories[1].mode }
      else
        vim.notify_once(
          "codesettings: ESLint workingDirectories supports only a single mode entry",
          vim.log.levels.WARN
        )
      end
      settings.workingDirectories = nil
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
