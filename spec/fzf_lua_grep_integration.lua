vim.opt.runtimepath:prepend(vim.fn.getcwd())

local plugin_dir = vim.fn.stdpath("data") .. "/lazy/fzf-lua"
if vim.fn.isdirectory(plugin_dir) == 0 or vim.fn.executable("rg") == 0 or vim.fn.executable("fzf") == 0 then
  print("SKIP: fzf-lua grep integration requires installed fzf-lua, fzf, and ripgrep")
  return
end

local lockfile = vim.json.decode(table.concat(vim.fn.readfile("lazy-lock.json"), "\n"))
local revision = vim.system({ "git", "-C", plugin_dir, "rev-parse", "HEAD" }, { text = true }):wait()
if revision.code ~= 0 or vim.trim(revision.stdout) ~= lockfile["fzf-lua"].commit then
  print("SKIP: fzf-lua grep integration requires the lockfile revision")
  return
end

vim.opt.runtimepath:prepend(plugin_dir)
local fzf = require("vimrc.plugins.fzf_lua")
fzf.setup_config()
fzf.setup_mapping()

local dir = vim.fn.stdpath("state") .. "/grep fixture"
local parent = vim.fs.dirname(dir)
vim.fn.mkdir(dir, "p")
local current = dir .. "/current file.lua"
vim.fn.writefile({ "", "", "你好  needle", "--with-filename", "NEEDLE" }, current)
vim.fn.writefile({ "needle" }, dir .. "/other.lua")
vim.api.nvim_set_current_dir(dir)
vim.cmd.edit(vim.fn.fnameescape(current))

local grep_flags
vim.fn.input = function(prompt)
  if prompt == "Grep in directory: " then
    return dir
  end
  assert(prompt == "Grep options: ", prompt)
  if grep_flags == "" then
    return ""
  end
  return "--color=never --case-sensitive " .. grep_flags
end

local utils = require("fzf-lua.utils")
utils.input = function()
  return "needle"
end
utils.get_visual_selection = utils.input

local core = require("fzf-lua.core")
local result
vim.env.RIPGREP_CONFIG_PATH = nil
core.fzf_exec = function(cmd, opts)
  local output = vim.system({ "sh", "-c", cmd }, { cwd = opts.cwd, text = true }):wait()
  assert(output.code == 0, ("%s\n%s"):format(cmd, output.stderr))
  result = { rows = vim.split(vim.trim(output.stdout), "\n", { plain = true }), opts = opts }
end

local function search(mode, key, flags)
  grep_flags = flags
  result = nil
  vim.fn.maparg("<Space>f" .. key, mode, false, true).callback()
  return assert(result)
end

local function assert_jump(row, opts)
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  require("fzf-lua.actions").file_edit({ row }, opts)
  assert(vim.api.nvim_buf_get_name(0) == current)
  assert(vim.deep_equal(vim.api.nvim_win_get_cursor(0), { 3, 8 }))
end

vim.api.nvim_set_current_dir(parent)
for _, case in ipairs({
  { "--replace --", "--" },
  { "--replace -e", "-e" },
  { "--replace --regexp --", "--regexp" },
  { "-Fr --", "--" },
}) do
  local replacement = search("n", "e", case[1])
  table.sort(replacement.rows)
  assert(
    vim.deep_equal(replacement.rows, { "current file.lua:3:9:你好  " .. case[2], "other.lua:1:1:" .. case[2] }),
    vim.inspect(replacement.rows)
  )
end

for _, suffix in ipairs({ "--", "-e" }) do
  local replacement = search("n", "e", [[--replace foo\ ]] .. suffix)
  table.sort(replacement.rows)
  assert(
    vim.deep_equal(replacement.rows, { "current file.lua:3:9:你好  foo " .. suffix, "other.lua:1:1:foo " .. suffix }),
    vim.inspect(replacement.rows)
  )
end

for _, args in ipairs({ "-F --", "-F -e", "-F --regexp", "-Fe", "-F '--'", '-F "-e"', "-F'e'", "-.e" }) do
  vim.api.nvim_set_current_dir(parent)
  local directory = search("n", "e", args)
  assert(directory.opts.cwd == dir)
  table.sort(directory.rows)
  assert(
    vim.deep_equal(directory.rows, { "current file.lua:3:9:你好  needle", "other.lua:1:1:needle" }),
    vim.inspect(directory.rows)
  )
  assert_jump(directory.rows[1], directory.opts)

  vim.api.nvim_set_current_dir(dir)
  local buffer = search("n", "3", args)
  assert(#buffer.rows == 5, vim.inspect(buffer.rows))
  for line, row in ipairs(buffer.rows) do
    assert(vim.startswith(row, ("current file.lua:%d:"):format(line)), row)
  end

  local visual = search("x", "3", args)
  assert(vim.deep_equal(visual.rows, { "current file.lua:3:9:你好  needle" }), vim.inspect(visual.rows))
  assert_jump(visual.rows[1], visual.opts)
end

for _, case in ipairs({
  { "--replace -e --", "-e" },
  { [['--replace' -e "--"]], "-e" },
  { [[--replace "foo -e bar" --]], "foo -e bar" },
  { [[--replace='foo -e bar' --]], "foo -e bar" },
  { [[--replace foo\ -e --]], "foo -e" },
  { [[--replace "\$0 -e bar" --]], "needle -e bar" },
}) do
  local visual = search("x", "3", case[1])
  assert(vim.deep_equal(visual.rows, { "current file.lua:3:9:你好  " .. case[2] }), vim.inspect(visual.rows))
end

local long_line = ("x"):rep(4200) .. " unique-long-line-match"
vim.fn.writefile({ long_line }, current, "a")
local buffer = search("n", "3", "")
local row = utils.strip_ansi_coloring(buffer.rows[6])
assert(row == "current file.lua:6:" .. long_line, vim.inspect(row))
buffer = search("n", "3", "--max-columns=4096")
assert(not buffer.rows[6]:find("unique-long-line-match", 1, true), vim.inspect(buffer.rows[6]))

print("PASS: pinned fzf-lua grep preserves separators, buffer scope, and selection position")
