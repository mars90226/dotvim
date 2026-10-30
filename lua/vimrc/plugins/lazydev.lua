-- Workarounds for lazydev.nvim.
-- NOTE: These wrap internal modules of lazydev.nvim, recheck after updating it.

local lazydev = {}

-- NOTE: emmylua_ls only requests the `emmylua` configuration section, but lazydev only injects its
-- dynamic library into the `Lua` section. Answer `emmylua` with lazydev's library.
-- Remove after https://github.com/folke/lazydev.nvim/pull/141 is merged.
-- Must run before lazydev attaches to a client, as it copies the handler into `client.handlers`.
lazydev.setup_emmylua_bridge = function()
  local lazydev_lsp = require("lazydev.lsp")
  local Workspace = require("lazydev.workspace")
  if lazydev_lsp._vimrc_emmylua_bridge then
    return
  end
  lazydev_lsp._vimrc_emmylua_bridge = true

  local on_workspace_configuration = lazydev_lsp.on_workspace_configuration
  lazydev_lsp.on_workspace_configuration = function(err, params, ctx, cfg)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not (client and client.name == "emmylua_ls") then
      return on_workspace_configuration(err, params, ctx, cfg)
    end

    local response = {}
    for _, item in ipairs(params.items or {}) do
      local value = vim.tbl_get(client.settings or {}, unpack(vim.split(item.section or "", ".", { plain = true })))
      if item.section == "emmylua" then
        local ws = item.scopeUri and Workspace.get(client, vim.uri_to_fname(item.scopeUri)) or Workspace.single(client)
        if ws:enabled() then
          -- emmylua_ls doesn't report diagnostics for library files, and lazydev adds the
          -- workspace's own `lua/` (e.g. this config) to the library, so exclude the workspace.
          local library = vim.tbl_filter(function(path)
            return path ~= ws.root and not vim.startswith(path, ws.root .. "/")
          end, vim.tbl_get(ws.settings, "Lua", "workspace", "library") or {})
          value = vim.tbl_deep_extend("force", vim.deepcopy(value or {}), { workspace = { library = library } })
        end
      end
      table.insert(response, value == nil and vim.NIL or value)
    end
    return response
  end
end

return lazydev
