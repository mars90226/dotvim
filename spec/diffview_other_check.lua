-- From the configuration root, run with temporary XDG_STATE_HOME and XDG_CACHE_HOME:
-- nvim --headless -u NONE -i NONE -n -l spec/diffview_other_check.lua
local config = vim.fn.getcwd()
local plugins = vim.env.NVIM_TEST_PLUGIN_DIR or vim.fn.stdpath("data") .. "/lazy"
local temp = vim.fn.tempname()
vim.fn.mkdir(temp, "p")
vim.opt.runtimepath:prepend(config)
vim.opt.runtimepath:prepend(plugins .. "/lazy.nvim")
vim.o.loadplugins = true
vim.g.mapleader = ","
vim.g.left_sidebar_width = 36

local function plugin_spec(module, name)
  for _, spec in ipairs(require(module)) do
    if type(spec) == "table" and spec[1]:match("/" .. vim.pesc(name) .. "$") then
      spec.dir = plugins .. "/" .. name
      assert(vim.fn.isdirectory(spec.dir) == 1, "Missing installed plugin: " .. spec.dir)
      return spec
    end
  end
  error("Missing plugin spec: " .. name)
end

require("lazy").setup({
  plugin_spec("plug.plugins.git", "diffview.nvim"),
  plugin_spec("plug.plugins.file_navigation", "other.nvim"),
}, {
  root = temp .. "/lazy",
  lockfile = temp .. "/lazy-lock.json",
  install = { missing = false },
  change_detection = { enabled = false },
  performance = { rtp = { reset = false } },
})

local function git(...)
  local result = vim.system({ "git", "-C", temp, ... }, { text = true }):wait()
  assert(result.code == 0, result.stderr)
end

local function write(path, content)
  local filename = temp .. "/" .. path
  vim.fn.mkdir(vim.fs.dirname(filename), "p")
  vim.fn.writefile({ content }, filename)
end

local source = "ui/src/Example.vue"
local test = "ui/test/Example.test.ts"
local implementation = "lib/widget.cpp"
local deleted_header = "include/widget/widget.h"
local generated_root = "packages/chat [test]/src/"
local generated_impl = generated_root .. "lib-net/widget+.cpp"
local generated_deleted = generated_root .. "include/build/net/widget+.h"
local generated_present = generated_root .. "include/live/net/widget+.h"
local generated_nested = generated_root .. "include/build/sub/net/widget+.h"
local generated_hidden = generated_root .. "include/.cache/net/widget+.h"
git("init", "-q")
git("config", "user.name", "Test")
git("config", "user.email", "test@example.invalid")
git("config", "commit.gpgsign", "false")
for _, path in ipairs({
  source,
  test,
  "sample.c",
  "sample.cpp",
  "sample.h",
  "solo.cpp",
  "solo.h",
  implementation,
  deleted_header,
  "include/widget/nested/widget.h",
  generated_impl,
  generated_deleted,
  generated_present,
  generated_nested,
  generated_hidden,
}) do
  write(path, "before")
end
git("add", "--", ".")
git("commit", "-qm", "before")
for _, path in ipairs({
  source,
  test,
  "sample.cpp",
  "sample.h",
  "solo.cpp",
  implementation,
  "include/widget/nested/widget.h",
  generated_impl,
  generated_present,
  generated_nested,
  generated_hidden,
}) do
  write(path, "after")
end
git("rm", "-q", "--", "sample.c", deleted_header, generated_deleted)
git("add", "-u")
git("commit", "-qm", "after")
vim.cmd.cd(temp)
vim.cmd.DiffviewOpen({ args = { "HEAD~1..HEAD", "--selected-file=" .. temp .. "/" .. source } })

local lib = require("diffview.lib")
local view = assert(lib.get_current_view())
local tab = vim.api.nvim_get_current_tabpage()
local function wait_for_diff(path)
  assert(
    vim.wait(3000, function()
      return view.panel.cur_file
        and view.panel.cur_file.path == path
        and vim.iter(vim.api.nvim_tabpage_list_wins(tab)):any(function(win)
          local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
          return name:match("^diffview://.*" .. vim.pesc(path) .. "$") ~= nil
        end)
    end),
    "Expected to see diff for " .. path
  )
  assert(vim.api.nvim_get_current_tabpage() == tab, "Jump changed tabs")
end

local function press_other()
  vim.api.nvim_feedkeys(",oo", "xt", false)
end

wait_for_diff(source)
vim.api.nvim_set_current_win(view.cur_layout:get_main_win().id)
assert(not package.loaded["other-nvim"], "other.nvim loaded before the first jump")
press_other()
wait_for_diff(test)

vim.api.nvim_set_current_win(view.cur_layout.a.id)
press_other()
wait_for_diff(source)

vim.api.nvim_set_current_win(view.panel.winid)
local function highlight(path)
  for _, entry in view.files:iter() do
    if entry.path == path then
      view.panel:highlight_file(entry)
      assert(view:infer_cur_file() == entry)
      return
    end
  end
  error("Missing diff entry: " .. path)
end

highlight("sample.h")
local select = vim.ui.select
vim.ui.select = function(entries, opts, on_choice)
  assert(#entries == 2)
  for _, entry in ipairs(entries) do
    if entry.path == "sample.c" then
      assert(opts.format_item(entry):find("sample.c", 1, true))
      on_choice(entry)
      return
    end
  end
  error("Deleted alternate missing from picker")
end
press_other()
wait_for_diff("sample.c")
assert(not view.panel:is_focused(), "Jump did not focus the diff")
vim.ui.select = select

vim.api.nvim_set_current_win(view.panel.winid)
highlight("solo.cpp")
local notices = {}
local notify = vim.notify
vim.notify = function(message)
  notices[#notices + 1] = message
end
press_other()
vim.notify = notify
assert(vim.tbl_contains(notices, "No paired file in this Diffview"))
assert(view.panel.cur_file.path == "sample.c", "Missing alternate changed the open diff")

highlight(implementation)
assert(vim.fn.filereadable(deleted_header) == 0, "Deleted header must be absent from the working tree")
press_other()
wait_for_diff(deleted_header)

vim.api.nvim_set_current_win(view.panel.winid)
highlight(generated_impl)
assert(vim.fn.filereadable(generated_deleted) == 0 and vim.fn.filereadable(generated_present) == 1)
vim.ui.select = function(entries, _, on_choice)
  local paths = vim.tbl_map(function(entry)
    return entry.path
  end, entries)
  table.sort(paths)
  assert(
    vim.deep_equal(paths, { generated_deleted, generated_present }),
    "Unexpected candidates: " .. vim.inspect(paths)
  )
  for _, entry in ipairs(entries) do
    if entry.path == generated_deleted then
      assert(entry.status == "D", "Expected a deletion diff")
      on_choice(entry)
      return
    end
  end
end
press_other()
vim.ui.select = select
wait_for_diff(generated_deleted)

vim.cmd.DiffviewClose()
vim.cmd.edit(source)
press_other()
assert(vim.api.nvim_buf_get_name(0) == temp .. "/" .. test, "Ordinary :Other mapping did not open the test")
print(
  "PASS: paired diffs from diff windows and file panel, deleted literal and wildcard alternates (including src/lib-*), missing diff, and ordinary :Other"
)
