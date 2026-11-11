local codesettings = {}
local rust_bases = {}

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

codesettings.apply = function(config)
  local root = config.root_dir
  if type(root) == "string" then
    local paths = require("codesettings.config").config_file_paths
    root = vim.fs.root(root, function(name, path)
      if name == ".git" or name == ".jj" then
        return true
      end
      for _, relative in ipairs(paths) do
        if name == relative:match("^[^/]+") then
          local stat = vim.uv.fs_stat(vim.fs.joinpath(path, relative))
          if stat and stat.type == "file" then
            return true
          end
        end
      end
      return false
    end) or root
  end

  config.settings = config.settings or {}
  if config._codesettings_base_settings then
    -- Restarts reuse the merged config, while client.settings retains this table.
    for key in pairs(config.settings) do
      config.settings[key] = nil
    end
    for key, value in pairs(vim.deepcopy(config._codesettings_base_settings)) do
      config.settings[key] = value
    end
  else
    config._codesettings_base_settings = vim.deepcopy(config.settings)
  end
  local eslint_settings = config.name == "eslint" and vim.deepcopy(config.settings or {})
  local json_schemas = config.name == "jsonls" and vim.deepcopy(vim.tbl_get(config.settings, "json", "schemas") or {})
  require("codesettings").with_local_settings(config.name, config, {
    root_dir = root,
    loader_extensions = codesettings.loader_extensions(root),
    merge_lists = "replace",
  })

  if eslint_settings then
    -- VS Code's ESLint extension uses different types and names than the server.
    local settings = config.settings
    if type(settings.validate) == "table" then
      vim.notify_once(
        "codesettings: ESLint validate language list is ignored in " .. (root or "unknown root"),
        vim.log.levels.WARN
      )
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
          "codesettings: ESLint workingDirectories is ignored in "
            .. (root or "unknown root")
            .. "; only a single mode entry is supported",
          vim.log.levels.WARN
        )
      end
      settings.workingDirectories = nil
    end
  end

  local project_schemas = config.name == "jsonls" and vim.tbl_get(config.settings, "json", "schemas")
  if project_schemas and not vim.deep_equal(project_schemas, json_schemas) then
    for _, schema in ipairs(project_schemas) do
      if
        not vim.iter(json_schemas):any(function(existing)
          return vim.deep_equal(existing, schema)
        end)
      then
        table.insert(json_schemas, schema)
      end
    end
    config.settings.json.schemas = json_schemas
  end
end

local function remove_settings(target, settings)
  for key, value in pairs(settings) do
    if type(value) == "table" and not vim.islist(value) and type(target[key]) == "table" then
      remove_settings(target[key], value)
      if next(target[key]) == nil then
        target[key] = nil
      end
    else
      target[key] = nil
    end
  end
end

codesettings.before_init = function(params, config)
  if config.name == "rust-analyzer" then
    local previous = vim.deepcopy(vim.tbl_get(config.settings or {}, "rust-analyzer") or {})
    if rust_bases[config.root_dir] then
      config._codesettings_base_settings = vim.deepcopy(rust_bases[config.root_dir])
    end
    codesettings.apply(config)
    -- Rustaceanvim restarts reuse initialization options from the previous client.
    local options = vim.deepcopy(params.initializationOptions or {})
    remove_settings(options, previous)
    params.initializationOptions =
      vim.tbl_deep_extend("force", options, vim.tbl_get(config.settings, "rust-analyzer") or {})
  else
    codesettings.apply(config)
  end
end

codesettings.rust_settings = function(root, defaults, overrides)
  local config = {
    name = "rust-analyzer",
    root_dir = root,
    settings = vim.tbl_deep_extend("force", vim.deepcopy(defaults or {}), vim.deepcopy(overrides or {})),
  }
  codesettings.apply(config)
  if root then
    rust_bases[root] = vim.deepcopy(config._codesettings_base_settings)
  end
  return config.settings
end

return codesettings
