vim.opt.runtimepath:prepend(vim.fn.getcwd())

package.loaded["blink.cmp"] = {
  get_lsp_capabilities = function()
    return {}
  end,
}

local refresh_callback, refresh_count = nil, 0
local refresh_error
local mappings = { bashls = "bash-language-server" }
local mapping_reads = 0
local current_specs = {}
local mapping_error
local installer_opts = {}
local active, installed, versions = {}, {}, {}
local broken_receipts = {}
local events, notifications = {}, {}
vim.notify = function(message, level)
  table.insert(notifications, { message = message, level = level })
end

vim.api.nvim_create_autocmd("User", {
  pattern = { "MasonToolsStartingInstall", "MasonToolsUpdateCompleted" },
  callback = function(event)
    table.insert(events, { pattern = event.match, data = event.data })
  end,
})

package.loaded["mason-registry"] = {
  refresh = function(callback)
    assert(not refresh_callback, "only one registry refresh should run at a time")
    refresh_count = refresh_count + 1
    if refresh_error then
      error(refresh_error)
    end
    refresh_callback = callback
  end,
  get_all_package_specs = function()
    mapping_reads = mapping_reads + 1
    if mapping_error then
      error(mapping_error)
    end
    local specs = {}
    for server, name in pairs(mappings) do
      local spec = { name = name, neovim = { lspconfig = server }, source = { id = versions[name] or "1" } }
      current_specs[name] = spec
      table.insert(specs, spec)
    end
    return specs
  end,
  has_package = function(name)
    return name == "bash-language-server" or name == "harper-ls"
  end,
  get_package = function(name)
    return {
      name = name,
      spec = assert(current_specs[name]),
      is_installed = function()
        return installed[name] ~= nil
      end,
      is_installing = function()
        return active[name] ~= nil
      end,
      is_uninstalling = function()
        return false
      end,
      get_latest_version = function()
        return versions[name] or "1"
      end,
      get_installed_version = function()
        if broken_receipts[name] then
          return vim.json.decode("{")
        end
        return installed[name]
      end,
      install = function(_, opts, callback)
        assert(not active[name], "do not install the same package twice")
        active[name] = function(success)
          active[name] = nil
          if success then
            installed[name] = opts.version or "1"
          end
          callback(success)
        end
      end,
    }
  end,
}
package.loaded["mason-tool-installer"] = {
  setup = function(opts)
    installer_opts = vim.tbl_extend("force", installer_opts, opts)
  end,
}

local lsp = require("vimrc.lsp")
lsp.servers = {
  bashls = {},
  harper_ls = {},
  unmapped = {},
  excluded = { condition = false },
  external = { mason = false },
}
local servers_set_up = false
lsp.setup_servers = function()
  servers_set_up = true
end

local function flush_scheduled()
  local done = false
  vim.schedule(function()
    done = true
  end)
  assert(
    vim.wait(1000, function()
      return done
    end),
    "scheduled callbacks did not finish"
  )
end

local function finish_refresh(success, updated_registries)
  local callback = assert(refresh_callback, "there should be a registry refresh to finish")
  refresh_callback = nil
  callback(success, updated_registries)
  flush_scheduled()
end

local function assert_completion(index, names)
  local event = assert(events[index], "expected a completion event")
  assert(event.pattern == "MasonToolsUpdateCompleted")
  table.sort(event.data)
  assert(vim.deep_equal(event.data, names), vim.inspect(event.data))
end

local takeover = vim.env.MASON_INSTALL_CASE == "takeover"
if takeover then
  mappings = {}
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      vim.defer_fn(function()
        finish_refresh(true, {})
        assert(active["harper-ls"], "the manual command should install the newly mapped package")
        active["harper-ls"](true)
      end, 20)
      vim.cmd.MasonToolsInstallSync()
    end,
  })
end

lsp.setup({})
assert(servers_set_up, "LSP setup must finish while the registry is pending")
assert(not installer_opts.run_on_start)
assert(mapping_reads == 1 and not next(active))
assert(vim.deep_equal(installer_opts.ensure_installed, takeover and {} or { "bash-language-server" }))

mappings = vim.tbl_extend("force", mappings, {
  harper_ls = "harper-ls",
  excluded = "excluded",
  external = "external",
})
finish_refresh(true, { "registry" })
assert(not next(active) and #events == 0, "auto-install must wait for VimEnter")
table.sort(installer_opts.ensure_installed)
assert(
  vim.deep_equal(
    installer_opts.ensure_installed,
    takeover and { "harper-ls" } or { "bash-language-server", "harper-ls" }
  ),
  "only keep eligible mapped packages"
)

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local ok, err = xpcall(function()
      flush_scheduled()
      if takeover then
        assert(refresh_count == 2, "an idle explicit command requests fresh registry data")
        assert(installed["harper-ls"] == "1" and not next(active))
        assert(#events == 2, "only the manual batch ran")
        assert_completion(2, { "harper-ls" })
        return
      end

      local bash, harper = "bash-language-server", "harper-ls"
      assert(refresh_count == 1 and active[bash] and active[harper])
      assert(#events == 1 and events[1].pattern == "MasonToolsStartingInstall")
      active[bash](true)
      flush_scheduled()
      assert(#events == 1, "an unfinished batch must not complete")

      vim.defer_fn(function()
        active[harper](true)
      end, 20)
      vim.cmd.MasonToolsInstallSync()
      assert(refresh_count == 1, "an overlapping command uses the same registry data")
      assert(not next(active) and #events == 3)
      assert_completion(2, { bash, harper })
      assert_completion(3, {})

      -- Simulate an LSP configuration first loaded after VimEnter with a warm
      -- registry. The pending manual request must use the failed refresh.
      mappings = { harper_ls = harper }
      installed[harper] = nil
      lsp.setup_lsp_install()
      assert(vim.deep_equal(installer_opts.ensure_installed, { harper }))
      vim.cmd.MasonToolsInstall()
      assert(not next(active), "wait for pending registry data")
      local refreshes, reads = refresh_count, mapping_reads
      finish_refresh(false)
      assert(refresh_count == refreshes and mapping_reads == reads + 1, "use the cache after a single failed refresh")
      assert(active[harper], "the manual command must install from the cache")
      active[harper](true)
      flush_scheduled()
      assert_completion(5, { harper })

      -- A later explicit update must refresh again and update the installed version.
      versions[harper] = "2"
      vim.defer_fn(function()
        finish_refresh(true, {})
        assert(active[harper])
        active[harper](true)
      end, 20)
      vim.cmd.MasonToolsUpdateSync()
      assert(refresh_count == refreshes + 1 and mapping_reads == reads + 2)
      assert(installed[harper] == "2")
      assert_completion(7, { harper })

      lsp.setup_lsp_install()
      finish_refresh(false)
      assert(#events == 7 and not next(active), "late setup alone must not start a batch")

      mappings.bashls = bash
      lsp.setup_lsp_install()
      installed[bash] = nil
      versions[harper] = "3"
      broken_receipts[harper] = true
      vim.cmd.MasonToolsUpdate()
      finish_refresh(true, {})
      assert(active[bash] and not active[harper], "a damaged receipt should not abort the rest of the batch")
      active[bash](true)
      flush_scheduled()
      assert_completion(9, { bash })
      assert(
        vim.iter(notifications):any(function(notice)
          return notice.level == vim.log.levels.ERROR and notice.message:find(harper, 1, true)
        end),
        "report the damaged package"
      )

      broken_receipts[harper] = nil
      vim.defer_fn(function()
        finish_refresh(true, {})
        assert(active[harper])
        active[harper](true)
      end, 20)
      vim.cmd.MasonToolsUpdateSync()
      assert(installed[harper] == "3")
      assert_completion(11, { harper })

      -- A different registry caller (e.g. :MasonUpdate) can restore mappings
      -- while our own next refresh reports that its cache is already fresh.
      mappings = {}
      lsp.setup_lsp_install()
      finish_refresh(true, {})
      assert(#installer_opts.ensure_installed == 0)
      mappings = { harper_ls = harper }
      installed[harper] = nil
      vim.cmd.MasonToolsInstall()
      finish_refresh(true, {})
      assert(active[harper], "a refresh cache hit must use newly available mappings")
      active[harper](true)
      flush_scheduled()
      assert_completion(13, { harper })

      local real_wait = vim.wait
      vim.wait = function()
        return false, -1
      end
      local sync_ok, sync_error = pcall(vim.cmd.MasonToolsInstallSync)
      vim.wait = real_wait
      assert(not sync_ok and sync_error:find("before the Mason batch completed", 1, true))
      assert(#events == 13, "an unfinished sync command must not report completion")
      finish_refresh(true, {})
      assert_completion(14, {})

      refresh_error = "malformed registry timestamp"
      servers_set_up = false
      lsp.setup({})
      assert(servers_set_up, "a registry exception must not block LSP setup")
      vim.cmd.MasonToolsInstallSync()
      assert_completion(15, {})
      assert(notifications[#notifications].message:find(refresh_error, 1, true))

      refresh_error = nil
      vim.cmd.MasonToolsInstall()
      finish_refresh(true, {})
      flush_scheduled()
      assert_completion(16, {})

      mappings = {}
      lsp.setup_lsp_install()
      vim.cmd.MasonToolsInstall()
      finish_refresh(false)
      assert_completion(17, {})

      mappings = { harper_ls = harper }
      installed[harper] = nil
      vim.cmd.MasonToolsInstall()
      finish_refresh(false)
      assert(active[harper], "use new local mappings even if refresh fails")
      active[harper](true)
      flush_scheduled()
      assert_completion(19, { harper })

      vim.cmd.MasonToolsInstall()
      mapping_error = "cache read failed"
      finish_refresh(false)
      assert_completion(20, {})
      assert(vim.deep_equal(installer_opts.ensure_installed, { harper }))
      assert(notifications[#notifications].message:find(mapping_error, 1, true))
    end, debug.traceback)
    if not ok then
      vim.api.nvim_err_writeln(err)
      vim.cmd("cquit")
      return
    end
    print("PASS: Mason installs follow registry readiness and the VimEnter boundary")
    vim.cmd("qa!")
  end,
})
