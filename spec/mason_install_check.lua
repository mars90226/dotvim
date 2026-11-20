vim.opt.runtimepath:prepend(vim.fn.getcwd())

package.loaded["blink.cmp"] = {
  get_lsp_capabilities = function()
    return {}
  end,
}

local registry_ready
local mappings = { yamlls = "yaml-language-server" }
local mapping_reads = 0
local installer_opts = { run_on_start = true }
local install_checks = 0
local cached_installs = {}

package.loaded["mason-registry"] = {
  refresh = function(callback)
    assert(type(callback) == "function", "registry refresh must be asynchronous")
    registry_ready = callback
  end,
  has_package = function(name)
    return name == "yaml-language-server"
  end,
  get_package = function(name)
    return {
      name = name,
      is_installed = function()
        return false
      end,
      is_installing = function()
        return false
      end,
    }
  end,
}
package.loaded["mason-lspconfig"] = {
  get_mappings = function()
    mapping_reads = mapping_reads + 1
    return { lspconfig_to_package = mappings }
  end,
}
package.loaded["mason-lspconfig.install"] = {
  install = function(pkg)
    table.insert(cached_installs, pkg.name)
  end,
}
package.loaded["mason-tool-installer"] = {
  setup = function(opts)
    installer_opts = vim.tbl_extend("force", installer_opts, opts)
  end,
  check_install = function()
    install_checks = install_checks + 1
  end,
}

local lsp = require("vimrc.lsp")
lsp.servers = {
  harper_ls = {},
  yamlls = {},
  unmapped = {},
  excluded = { condition = false },
  external = { mason = false },
}
local servers_set_up = false
lsp.setup_servers = function()
  servers_set_up = true
end

local function finish_refresh(success, updated_registries)
  registry_ready(success, updated_registries)
  local done = false
  vim.schedule(function()
    done = true
  end)
  assert(
    vim.wait(1000, function()
      return done
    end),
    "refresh callback did not finish"
  )
end

lsp.setup({})
assert(servers_set_up, "LSP setup must finish while the registry is pending")
assert(not installer_opts.run_on_start, "the installer's VimEnter check must be disabled before registry readiness")
assert(mapping_reads == 1 and install_checks == 0, "do not start installing before refresh")
assert(vim.deep_equal(installer_opts.ensure_installed, { "yaml-language-server" }), "seed the cached list")
finish_refresh(false)
assert(#cached_installs == 0, "cached installation must also wait for VimEnter")

lsp.setup_lsp_install()
mappings = { harper_ls = "harper-ls", yamlls = "yaml-language-server", excluded = "excluded", external = "external" }
finish_refresh(true, { "registry" })
assert(install_checks == 0, "do not auto-install before VimEnter even when the registry is ready")
table.sort(installer_opts.ensure_installed)
assert(
  vim.deep_equal(installer_opts.ensure_installed, { "harper-ls", "yaml-language-server" }),
  "include newly mapped eligible servers after refreshing a partial list"
)

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    assert(vim.v.vim_did_enter == 1)
    assert(
      vim.wait(1000, function()
        return install_checks == 1
      end),
      "VimEnter should trigger startup installation"
    )
    assert(vim.deep_equal(cached_installs, { "yaml-language-server" }), "failed refresh uses the cached package")

    mappings = { harper_ls = "harper-ls" }
    lsp.setup_lsp_install()
    assert(
      vim.deep_equal(installer_opts.ensure_installed, { "harper-ls" }),
      "manual commands need the cached list while a refresh is pending"
    )
    finish_refresh(false)
    assert(
      vim.deep_equal(installer_opts.ensure_installed, { "harper-ls" }),
      "keep cached mappings after refresh failure"
    )

    lsp.setup_lsp_install()
    local cached_reads = mapping_reads
    finish_refresh(true, {})
    assert(mapping_reads == cached_reads, "reuse cached mappings if no registry changed")

    mappings = {}
    lsp.setup_lsp_install()
    finish_refresh(false)
    assert(#installer_opts.ensure_installed == 0, "skip installation without package mappings")

    lsp.setup_lsp_install()
    mappings = { harper_ls = "harper-ls" }
    finish_refresh(true, { "registry" })
    assert(vim.deep_equal(installer_opts.ensure_installed, { "harper-ls" }), "late setup populates the manual list")
    assert(install_checks == 1, "do not start automatic installation when setup begins after VimEnter")
    print("PASS: Mason LSP installs follow registry readiness and the VimEnter boundary")
    vim.cmd("qa!")
  end,
})
