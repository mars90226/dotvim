vim.opt.runtimepath:prepend(vim.fn.getcwd())

local temp = vim.fn.tempname()
local project = temp .. "/project"
local nested = project .. "/src"
local other = project .. "/other"
vim.fn.mkdir(nested, "p")
vim.fn.mkdir(other .. "/.git", "p")
vim.fn.mkdir(project .. "/.vscode", "p")

local observed
package.loaded.codesettings = {
  with_local_settings = function(name, config, opts)
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
  vim.fn.writefile({ vim.json.encode({ ["harper-ls.userDictPath"] = "/tmp/dictionary" }) }, project .. "/.neoconf.json")
  vim.fn.writefile({ vim.json.encode({ ["eslint.format.enable"] = false }) }, project .. "/.vscode/settings.json")

  local harper = { name = "harper_ls", root_dir = nested, settings = {} }
  adapter.before_init({}, harper)
  assert(harper.settings["harper-ls"].userDictPath == "/tmp/dictionary", "Harper settings should reach the client")
  local real_eslint = { name = "eslint", root_dir = nested, settings = { format = true } }
  adapter.before_init({}, real_eslint)
  assert(real_eslint.settings.format == false, "ESLint's VS Code setting should reach the client")
  print("codesettings plugin and Harper schema integration checks passed")
else
  print("codesettings plugin integration skipped: plugin is not installed")
end
print("codesettings root, initialization, callback and schema checks passed")
