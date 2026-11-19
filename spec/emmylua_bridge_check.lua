vim.opt.runtimepath:prepend(".")

local root = "/repo"
local paths = {
  root .. "/lua",
  "/plugins/lazy.nvim/lua",
  "/plugins/plenary.nvim/lua",
  "/plugins/which-key.nvim/lua",
}
local workspace = {
  root = root,
  enabled = function()
    return true
  end,
  settings = { Lua = { workspace = { library = paths } } },
}
package.loaded["lazydev.workspace"] = {
  get = function()
    return workspace
  end,
}
local lazydev_lsp = {}
---@type fun(err: any, params: table, ctx: table): any[]
lazydev_lsp.on_workspace_configuration = function(_err, _params, _ctx)
  return { "original handler" }
end
package.loaded["lazydev.lsp"] = lazydev_lsp
local client = { name = "emmylua_ls", settings = { emmylua = { runtime = { version = "LuaJIT" } } } }
vim.lsp.get_client_by_id = function()
  return client
end

require("vimrc.plugins.lazydev").setup_emmylua_bridge()
local params = { items = { { section = "emmylua", scopeUri = "file:///repo" } } }
local ctx = { client_id = 1 }
local result = lazydev_lsp.on_workspace_configuration(nil, params, ctx)[1]
assert(vim.deep_equal(result, {
  runtime = { version = "LuaJIT" },
  workspace = {
    library = {
      { path = paths[2], ignoreGlobs = { "**/lazy/minit.lua" } },
      { path = paths[3], ignoreGlobs = { "**/plenary/busted.lua" } },
      paths[4],
    },
  },
}))
assert(#paths == 4 and workspace.settings.Lua.workspace.library[2] == paths[2])

client.name = "lua_ls"
assert(vim.deep_equal(lazydev_lsp.on_workspace_configuration(nil, params, ctx), { "original handler" }))
print("PASS: EmmyLua library exclusions preserve completion paths and LuaLS routing")
