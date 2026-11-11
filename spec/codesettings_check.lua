vim.opt.runtimepath:remove(vim.fn.stdpath("config"))
vim.opt.runtimepath:remove(vim.fn.stdpath("config") .. "/after")
vim.opt.runtimepath:prepend(vim.fn.getcwd())
vim.opt.runtimepath:append(vim.fn.getcwd() .. "/after")

local temp = vim.fn.tempname()
local project = temp .. "/project"
local nested = project .. "/src"
local other = project .. "/other"
local unrelated = temp .. "/unrelated"
vim.fn.mkdir(nested, "p")
vim.fn.mkdir(other .. "/.git", "p")
vim.fn.mkdir(unrelated .. "/.git", "p")
vim.fn.mkdir(project .. "/.vscode", "p")
vim.fn.mkdir(nested .. "/.vscode", "p")
vim.fn.writefile({ "{}" }, project .. "/.vscode/settings.json")
vim.fn.writefile({ "{}" }, nested .. "/.vscode/launch.json")

local observed
local load_error
package.loaded["codesettings.config"] = {
  config_file_paths = { ".vscode/settings.json", "codesettings.json", "lspsettings.json", ".neoconf.json" },
}
package.loaded.codesettings = {
  with_local_settings = function(name, config, opts)
    if load_error then
      error("settings load failed")
    end
    observed = opts.root_dir
    config.settings = config.settings or {}
    if name == "rust-analyzer" then
      config.settings["rust-analyzer"] = { procMacro = { enable = false } }
    elseif name == "eslint" then
      config.settings.validate = { "javascript", "typescript" }
      config.settings.format = { enable = false }
      config.settings.codeActionsOnSave = { mode = "problems" }
    elseif name == "yamlls" then
      config.settings.yaml = { format = { enable = true } }
    end
  end,
}

local adapter = require("vimrc.plugins.codesettings")
local rust_settings = adapter.rust_settings(nested, { ["rust-analyzer"] = { procMacro = { enable = true } } })
assert(observed == project, "settings should resolve at the nearest project marker")
assert(rust_settings["rust-analyzer"].procMacro.enable == false, "Rust project options should reach the client")

adapter.before_init({}, { name = "harper_ls", root_dir = other })
assert(observed == other, "a nested repository should not inherit the parent project's settings")

local eslint = { name = "eslint", root_dir = nested, settings = { validate = "on", format = true } }
adapter.before_init({}, eslint)
assert(eslint.settings.validate == "on", "VS Code's language list should not replace the server's validate mode")
assert(eslint.settings.format == false, "VS Code's formatter setting should map to the server's boolean")
assert(eslint.settings.codeActionOnSave.mode == "problems", "ESLint's save mode should use the server key")

package.loaded["blink.cmp"] = {
  get_lsp_capabilities = function()
    return {}
  end,
}
local lsp = require("vimrc.lsp")
vim.lsp.config("*", lsp.servers["*"])
local original_called = false
vim.lsp.config("codesettings_fixture", {
  before_init = function(_, config)
    original_called = config.settings ~= nil
  end,
})
lsp.setup_server("codesettings_fixture", {})
vim.lsp.config.codesettings_fixture.before_init({}, { name = "codesettings_fixture", root_dir = nested })
assert(original_called and observed == project, "the server's before_init and project settings should both run")
original_called = false
load_error = true
local ok, err = pcall(vim.lsp.config.codesettings_fixture.before_init, {}, { root_dir = nested, settings = {} })
assert(not ok and err:find("settings load failed", 1, true), "settings errors should still be reported")
assert(original_called, "the server's before_init should run even when loading settings fails")
load_error = false

local captured = {}
local client_config = vim.deepcopy(vim.lsp.config.codesettings_fixture)
client_config.name = "yamlls"
client_config.root_dir = project
client_config.cmd = function(dispatchers)
  return {
    request = function(method, _, callback)
      if method == "initialize" then
        vim.schedule(function()
          callback(nil, { capabilities = {} })
        end)
      end
      return true, 1
    end,
    notify = function(method, params)
      if method == "workspace/didChangeConfiguration" then
        captured.settings = params.settings
      elseif method == "exit" then
        dispatchers.on_exit(0, 15)
      end
      return true
    end,
    is_closing = function()
      return false
    end,
    terminate = function() end,
  }
end
local client_id = vim.lsp.start(client_config, { attach = false })
assert(client_id, "the fake language server should start")
assert(
  vim.wait(1000, function()
    return captured.settings ~= nil
  end),
  "project settings should reach a server with no explicit settings"
)
assert(captured.settings.yaml.format.enable, "the client should notify the server of project settings")
vim.lsp.get_client_by_id(client_id):stop(true)

local schema = vim.json.decode(table.concat(vim.fn.readfile("after/codesettings-schemas/harper_ls.json"), "\n"))
assert(schema.properties["harper-ls"].type == "object", "Harper project settings should be selectable")
local schema_paths = vim.api.nvim_get_runtime_file("after/codesettings-schemas/harper_ls.json", true)
assert(#schema_paths == 1 and schema_paths[1] == vim.fn.getcwd() .. "/after/codesettings-schemas/harper_ls.json")

local plugin_dir = vim.fn.stdpath("data") .. "/lazy/codesettings.nvim"
if vim.fn.isdirectory(plugin_dir) == 1 then
  vim.opt.runtimepath:append(plugin_dir)
  package.loaded.codesettings = nil
  package.loaded["codesettings.config"] = nil
  local specs = require("plug.plugins.lsp")
  local opts
  for _, dependency in ipairs(specs[1].dependencies) do
    if type(dependency) == "table" and dependency[1] == "mrjones2014/codesettings.nvim" then
      opts = dependency.opts
    end
  end
  assert(opts, "codesettings plugin options should be available")
  require("codesettings").setup(opts)
  vim.fn.writefile({
    vim.json.encode({
      lspconfig = {
        harper_ls = { ["harper-ls.userDictPath"] = "/tmp/dictionary" },
        rust_analyzer = { ["rust-analyzer.cargo.extraArgs"] = { "--offline" } },
      },
    }),
  }, project .. "/.neoconf.json")
  local vscode_settings = {
    ["eslint.format.enable"] = false,
    ["eslint.rules.customizations"] = { { rule = "example", severity = "warn" } },
    ["eslint.workingDirectories"] = { { mode = "location" } },
    ["harper.userDictPath"] = "/tmp/vscode-dictionary",
    ["harper.workspaceDictPath"] = "${workspaceFolder}/workspace-dictionary",
    ["harper.dialect"] = "British",
    ["rust-analyzer.procMacro.enable"] = false,
    ["rust-analyzer.cargo.extraArgs"] = { "--locked" },
    ["yaml.format.enable"] = true,
    ["json.schemas"] = { { fileMatch = { "project.json" }, url = "project-schema" } },
  }
  vim.fn.writefile({ vim.json.encode(vscode_settings) }, project .. "/.vscode/settings.json")

  local harper = { name = "harper_ls", root_dir = nested, settings = {} }
  vim.api.nvim_buf_set_name(0, unrelated .. "/file.md")
  adapter.before_init({}, harper)
  assert(harper.settings["harper-ls"].userDictPath == "/tmp/dictionary", "neoconf should take precedence over VS Code")
  assert(harper.settings["harper-ls"].dialect == "British", "VS Code Harper settings should reach the client")
  assert(
    harper.settings["harper-ls"].workspaceDictPath == project .. "/workspace-dictionary",
    "VS Code variables should use the client's project, not the current buffer"
  )
  vscode_settings["harper-ls"] = true
  vim.fn.writefile({ vim.json.encode(vscode_settings) }, project .. "/.vscode/settings.json")
  local invalid_harper = { name = "yamlls", root_dir = nested, settings = {} }
  adapter.before_init({}, invalid_harper)
  assert(invalid_harper.settings.yaml.format.enable, "an invalid Harper value should not block other servers")
  vscode_settings["harper-ls"] = nil
  vim.fn.writefile({ vim.json.encode(vscode_settings) }, project .. "/.vscode/settings.json")
  local real_eslint = { name = "eslint", root_dir = nested, settings = { format = true } }
  adapter.before_init({}, real_eslint)
  assert(real_eslint.settings.format == false, "ESLint's VS Code setting should reach the client")
  assert(
    real_eslint.settings.rulesCustomizations[1].rule == "example",
    "ESLint rule customizations should reach the server"
  )
  assert(
    real_eslint.settings.workingDirectory.mode == "location",
    "ESLint working directory mode should reach the server"
  )
  vscode_settings["eslint.workingDirectories"] = { "one", "two" }
  vim.fn.writefile({ vim.json.encode(vscode_settings) }, project .. "/.vscode/settings.json")
  local original_notify_once = vim.notify_once
  local warned = false
  vim.notify_once = function()
    warned = true
  end
  local multiple_directories =
    { name = "eslint", root_dir = nested, settings = { workingDirectory = { mode = "auto" } } }
  adapter.before_init({}, multiple_directories)
  vim.notify_once = original_notify_once
  assert(warned, "unsupported working directories should be reported")
  assert(
    multiple_directories.settings.workingDirectory.mode == "auto",
    "unsupported directories should not change the mode"
  )
  vscode_settings["eslint.workingDirectories"] = { { mode = "location" } }
  vim.fn.writefile({ vim.json.encode(vscode_settings) }, project .. "/.vscode/settings.json")
  local first_rust = adapter.rust_settings(nested, { ["rust-analyzer"] = { procMacro = { enable = true } } })
  assert(first_rust["rust-analyzer"].procMacro.enable == false, "Rust project options should reach the client")
  assert(
    vim.deep_equal(first_rust["rust-analyzer"].cargo.extraArgs, { "--offline" }),
    "later project files should replace earlier lists"
  )
  local rust_config = { name = "rust-analyzer", root_dir = nested, settings = vim.deepcopy(first_rust) }
  rust_config.settings["rust-analyzer"].files = { watcher = "server" }
  rust_config.init_options = vim.tbl_deep_extend(
    "force",
    { detachedFiles = { "untitled.rs" } },
    vim.deepcopy(rust_config.settings["rust-analyzer"])
  )
  local held_settings = rust_config.settings
  local rust_params = { initializationOptions = vim.deepcopy(rust_config.init_options) }
  adapter.before_init(rust_params, rust_config)
  assert(rust_config.settings == held_settings, "Rust initialization should preserve the settings table")
  assert(rust_params.initializationOptions.files.watcher == "server", "Rust should retain the file watcher")
  rust_config.settings["rust-analyzer"].cargo.target = "wasm32-unknown-unknown"
  vscode_settings["rust-analyzer.procMacro.enable"] = nil
  vscode_settings["rust-analyzer.cargo.extraArgs"] = nil
  vim.fn.writefile(
    { vim.json.encode({ lspconfig = { harper_ls = { ["harper-ls.userDictPath"] = "/tmp/dictionary" } } }) },
    project .. "/.neoconf.json"
  )
  vscode_settings["eslint.format.enable"] = nil
  vim.fn.writefile({ vim.json.encode(vscode_settings) }, project .. "/.vscode/settings.json")
  local reloaded_rust = adapter.rust_settings(nested, { ["rust-analyzer"] = { procMacro = { enable = true } } })
  assert(reloaded_rust["rust-analyzer"].procMacro.enable, "Rust reload should restore removed project settings")
  rust_params = { initializationOptions = vim.deepcopy(rust_config.init_options) }
  adapter.before_init(rust_params, rust_config)
  assert(rust_params.initializationOptions.procMacro.enable, "Rust restart should restore removed project settings")
  assert(rust_params.initializationOptions.cargo.extraArgs == nil, "Rust restart should remove old project options")
  assert(
    rust_params.initializationOptions.cargo.target == "wasm32-unknown-unknown",
    "Rust target should survive restart"
  )
  assert(
    rust_params.initializationOptions.detachedFiles[1] == "untitled.rs",
    "Rust restart should preserve other options"
  )
  rust_params = { initializationOptions = vim.deepcopy(rust_config.init_options) }
  adapter.before_init(rust_params, rust_config)
  assert(
    rust_params.initializationOptions.cargo.extraArgs == nil,
    "Rust options should stay removed after a second restart"
  )
  assert(rust_params.initializationOptions.cargo.target == "wasm32-unknown-unknown", "Rust target should persist")
  local rust_plugin_dir = vim.fn.stdpath("data") .. "/lazy/rustaceanvim"
  if vim.fn.isdirectory(rust_plugin_dir) == 1 then
    vim.opt.runtimepath:append(rust_plugin_dir)
    for _, spec in ipairs(specs) do
      if spec[1] == "mrcjkb/rustaceanvim" then
        spec.config()
      end
    end
    local original_rust_settings = adapter.rust_settings
    local original_notify = vim.notify
    local settings_warning
    adapter.rust_settings = function()
      error("settings fixture failure")
    end
    vim.notify = function(message)
      settings_warning = message
    end
    local fallback = vim.g.rustaceanvim.server.settings(nested, { ["rust-analyzer"] = { fixture = true } })
    adapter.rust_settings = original_rust_settings
    vim.notify = original_notify
    assert(fallback["rust-analyzer"].fixture, "Rust should retain defaults when loading settings fails")
    assert(settings_warning:find("settings fixture failure", 1, true), "Rust settings failure should be reported")
    local rust_analyzer = require("rustaceanvim.rust_analyzer")
    local original_clients = rust_analyzer.get_active_rustaceanvim_clients
    local client = { config = { root_dir = nested }, notify = function() end }
    rust_analyzer.get_active_rustaceanvim_clients = function()
      return { client }
    end
    vscode_settings["rust-analyzer.procMacro.enable"] = false
    vim.fn.writefile({ vim.json.encode(vscode_settings) }, project .. "/.vscode/settings.json")
    require("rustaceanvim.lsp").reload_settings(0)
    assert(client.settings["rust-analyzer"].procMacro.enable == false, "Rust reload should load project settings")
    vscode_settings["rust-analyzer.procMacro.enable"] = nil
    vim.fn.writefile({ vim.json.encode(vscode_settings) }, project .. "/.vscode/settings.json")
    require("rustaceanvim.lsp").reload_settings(0)
    assert(client.settings["rust-analyzer"].procMacro.enable, "Rust reload should restore the default")
    rust_analyzer.get_active_rustaceanvim_clients = original_clients
  else
    print("rustaceanvim integration skipped: plugin is not installed")
  end
  adapter.before_init({}, real_eslint)
  assert(real_eslint.settings.format, "restart should restore removed project settings")
  local json = { name = "jsonls", root_dir = nested, settings = { json = { schemas = { { url = "base-schema" } } } } }
  adapter.before_init({}, json)
  adapter.before_init({}, json)
  assert(#json.settings.json.schemas == 2, "project schemas should extend defaults without duplicating on restart")
  print("codesettings plugin and Harper schema integration checks passed")
else
  print("codesettings plugin integration skipped: plugin is not installed")
end
print("codesettings root, initialization, callback and schema checks passed")
