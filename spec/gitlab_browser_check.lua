local plugins = vim.env.NVIM_TEST_PLUGIN_DIR or vim.fn.stdpath("data") .. "/lazy"
local temp = vim.fn.tempname()
vim.opt.runtimepath:prepend(".")
vim.opt.runtimepath:prepend(plugins .. "/lazy.nvim")
vim.o.loadplugins = true

local spec
for _, plugin in ipairs(require("plug.plugins.git")) do
  if plugin[1] == "mars90226/gitlab.nvim" then
    spec = plugin
    break
  end
end
assert(spec, "gitlab.nvim spec missing")
spec.dir = plugins .. "/gitlab.nvim"
for index, dependency in ipairs(spec.dependencies) do
  spec.dependencies[index] = { dependency, dir = plugins .. "/" .. vim.fs.basename(dependency) }
end
local configure = spec.config
spec.config = function()
  require("gitlab.server").build = function() end
  require("gitlab.health").check = function()
    return true
  end
  local state = require("gitlab.state")
  state.initialized = true
  state.go_server_running = true
  state.INFO = { web_url = "https://gitlab.example.invalid/project/-/merge_requests/42" }
  configure()
end

require("lazy").setup({ spec }, {
  root = temp .. "/lazy",
  lockfile = temp .. "/lazy-lock.json",
  install = { missing = false },
  change_detection = { enabled = false },
  performance = { rtp = { reset = false } },
})

local job
vim.fn.jobstart = function(args)
  job = args
  return 1
end
local function check_client_url(url)
  assert(job, "Expected an SSH browser job")
  assert(vim.deep_equal({ job[1], job[2], job[3] }, { "ssh", "--", "client.example.invalid" }), vim.inspect(job))
  local command = 'firefox() { [ "$#" -eq 1 ] && printf \'%s\' "$1"; }; ' .. job[4]
  local result = vim.system({ "sh", "-c", command }):wait()
  assert(result.code == 0 and result.stdout == url, vim.inspect(result))
end

vim.env.SSH_CLIENT_HOST = "client.example.invalid"
vim.env.OPEN_URL_FORCE_LOCAL = nil
assert(not package.loaded.gitlab, "gitlab.nvim loaded before glo")
vim.api.nvim_feedkeys("glo", "xt", false)
assert(job, "glo did not load gitlab.nvim and open the MR")
local mr_url = require("gitlab.state").INFO.web_url
check_client_url(mr_url)

local discussion_url = mr_url .. "?q=a'b&view=all#note_7"
job = nil
require("gitlab.actions.common").open_in_browser({
  get_node = function()
    return { type = "note", url = discussion_url }
  end,
})
check_client_url(discussion_url)

vim.env.OPEN_URL_FORCE_LOCAL = "1"
job = nil
vim.api.nvim_feedkeys("glo", "xt", false)
assert(job and job[1] ~= "ssh" and job[#job] == mr_url, "Local override did not use the system browser")
local local_job = job

vim.env.OPEN_URL_FORCE_LOCAL = nil
vim.env.SSH_CLIENT_HOST = nil
job = nil
vim.api.nvim_feedkeys("glo", "xt", false)
assert(vim.deep_equal(job, local_job), "Missing SSH client did not use the system browser")

print("PASS: GitLab opens MR and discussion URLs on the SSH client and supports local fallback")
