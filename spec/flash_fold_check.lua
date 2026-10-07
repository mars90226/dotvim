vim.opt.runtimepath:prepend(".")
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/flash.nvim")
local Flash = require("flash")
Flash.setup({ labels = "asdfghjklqwertyuiopzxcvbnm" })
local State = require("flash.state")
local states = {}
Flash.jump = function(opts)
  local state = State.new(opts)
  states[#states + 1] = state
  return state
end
local helper = require("vimrc.plugins.flash")
local lines = {}
for i = 1, 40 do
  lines[i] = "alpha beta gamma delta"
end
vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
vim.cmd("vsplit")
vim.cmd("enew")
vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
vim.cmd("windo diffthis")
vim.cmd("windo setlocal foldenable foldlevel=0")
vim.cmd("redraw")
local win = vim.api.nvim_get_current_win()
assert(vim.fn.foldclosed(10) ~= -1, "diff fold fixture failed")
helper.jump_word()
local folded = states[#states]
local count = 0
for _, match in ipairs(folded.results) do
  if match.fold then
    count = count + 1
    assert(match.label == false and match.label1 == nil and match.label2 == nil)
  end
end
assert(count > 0, "no folded matches exercised")
folded:hide()
vim.cmd("windo diffoff")
vim.cmd("windo setlocal foldmethod=manual")
vim.cmd("windo normal! zE")
vim.cmd("windo 5,15fold")
vim.cmd("windo setlocal foldenable foldlevel=0")
vim.api.nvim_win_set_cursor(win, { 1, 0 })
vim.cmd("redraw")
helper.jump_word()
local first = states[#states]
local fold_before = vim.api.nvim_win_call(win, function()
  return vim.fn.foldclosed(10)
end)
assert(fold_before ~= -1, "manual fold missing")
local target
local n = 0
local labels = first:labels()
for _, match in ipairs(first.results) do
  if match.fold then
    assert(match.label == false)
  else
    n = n + 1
    assert(match.label1 == labels[math.floor((n - 1) / #labels) + 1])
    assert(match.label2 == labels[(n - 1) % #labels + 1])
    if match.win == win and match.pos[1] == 16 then
      target = match
    end
  end
end
assert(target, "visible target after fold missing")
local pos = { target.pos[1], target.pos[2] }
local second_label = target.label2
first:jump(target.label1)
local second = states[#states]
assert(second ~= first)
for _, match in ipairs(second.results) do
  assert(not match.fold)
end
second:jump(second_label)
assert(vim.deep_equal(vim.api.nvim_win_get_cursor(win), pos), "second-stage jump failed")
assert(vim.api.nvim_win_call(win, function()
  return vim.fn.foldclosed(10)
end) == fold_before, "jump opened excluded fold")
second:hide()
print("PASS: diff folds, manual folds, contiguous labels, two-stage jump")
vim.cmd("qa!")
