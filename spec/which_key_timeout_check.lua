vim.opt.runtimepath:prepend(".")
package.loaded["which-key"] = {
  setup = function(opts)
    assert(vim.tbl_contains(opts.disable.bt, "nowrite"))
  end,
}

local spec
for _, plugin in ipairs(require("plug.plugins.appearance")) do
  if plugin[1] == "folke/which-key.nvim" then
    spec = plugin
    break
  end
end
assert(spec, "which-key spec missing")

local function finish_option_events()
  local done = false
  vim.schedule(function()
    done = true
  end)
  assert(vim.wait(1000, function()
    return done
  end))
end

local api = vim.api
local normal = api.nvim_get_current_buf()
local revision = api.nvim_create_buf(true, false)
local other_revision = api.nvim_create_buf(true, false)
vim.go.timeoutlen = 300
spec.config(spec, spec.opts)

vim.bo[revision].buftype = "nowrite"
vim.bo[other_revision].buftype = "nowrite"
finish_option_events()
assert(vim.go.timeoutlen == 300, "hidden buffers changed the timeout")

api.nvim_set_current_buf(revision)
assert(vim.go.timeoutlen == 600, "entering nowrite did not extend the timeout")
api.nvim_set_current_buf(other_revision)
assert(vim.go.timeoutlen == 600, "switching between nowrite buffers lost the extended timeout")
api.nvim_set_current_buf(normal)
assert(vim.go.timeoutlen == 300, "leaving nowrite did not restore the timeout")

vim.go.timeoutlen = 450
vim.cmd("setlocal buftype=nowrite")
finish_option_events()
assert(vim.go.timeoutlen == 600, "setting buftype on the current buffer did not extend the timeout")
vim.cmd("setlocal buftype=")
finish_option_events()
assert(vim.go.timeoutlen == 450, "clearing buftype did not restore the previous timeout")

print("PASS: which-key mapping timeout follows the current buffer type")
