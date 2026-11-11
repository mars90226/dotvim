vim.opt.runtimepath:prepend(vim.fn.getcwd())

local temp = vim.fn.tempname()
local project = temp .. "/project"
local nested = project .. "/src"
local other = project .. "/other"
vim.fn.mkdir(nested, "p")
vim.fn.mkdir(other .. "/.git", "p")
vim.fn.mkdir(project .. "/.vscode", "p")

local observed
local load_error
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
    end
  end,
}

local adapter = require("vimrc.plugins.codesettings")
local params = { initializationOptions = { retained = true, procMacro = { enable = true } } }
adapter.before_init(params, { name = "rust-analyzer", root_dir = nested })
assert(observed == project, "settings should resolve at the nearest project marker")
assert(params.initializationOptions.retained, "existing initialization options should survive")
assert(params.initializationOptions.procMacro.enable == false, "Rust project options should reach initialization")

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

local schema = vim.json.decode(table.concat(vim.fn.readfile("after/codesettings-schemas/harper_ls.json"), "\n"))
assert(schema.properties["harper-ls"].type == "object", "Harper project settings should be selectable")

local plugin_dir = vim.fn.stdpath("data") .. "/lazy/codesettings.nvim"
if vim.fn.isdirectory(plugin_dir) == 1 then
  vim.opt.runtimepath:append(plugin_dir)
  package.loaded.codesettings = nil
  local specs = require("plug.plugins.lsp")
  local opts
  for _, dependency in ipairs(specs[1].dependencies) do
    if type(dependency) == "table" and dependency[1] == "mrjones2014/codesettings.nvim" then
      opts = dependency.opts
    end
  end
  assert(opts, "codesettings plugin options should be available")
  require("codesettings").setup(opts)
  vim.fn.writefile(
    { vim.json.encode({ lspconfig = { harper_ls = { ["harper-ls.userDictPath"] = "/tmp/dictionary" } } }) },
    project .. "/.neoconf.json"
  )
  local vscode_settings = {
    ["eslint.format.enable"] = false,
    ["eslint.rules.customizations"] = { { rule = "example", severity = "warn" } },
    ["eslint.workingDirectories"] = { { mode = "location" } },
    ["rust-analyzer.procMacro.enable"] = false,
    ["yaml.format.enable"] = true,
  }
  vim.fn.writefile({ vim.json.encode(vscode_settings) }, project .. "/.vscode/settings.json")

  local harper = { name = "harper_ls", root_dir = nested, settings = {} }
  adapter.before_init({}, harper)
  assert(harper.settings["harper-ls"].userDictPath == "/tmp/dictionary", "Harper settings should reach the client")
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
  local rust_params = {}
  adapter.before_init(rust_params, { name = "rust-analyzer", root_dir = nested, settings = {} })
  assert(
    rust_params.initializationOptions.procMacro.enable == false,
    "Rust project options should reach initialization"
  )

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
  print("codesettings plugin and Harper schema integration checks passed")
else
  print("codesettings plugin integration skipped: plugin is not installed")
end
print("codesettings root, initialization, callback and schema checks passed")
