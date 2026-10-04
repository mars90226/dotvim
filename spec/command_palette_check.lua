vim.opt.runtimepath:prepend(".")
local palette = require("vimrc.plugins.command_palette")
package.loaded.command_palette = { CpMenu = vim.deepcopy(palette.config) }
local category = 'category"\\\n'
local name = 'command"\\\n'
local received
palette.custom_commands[category] = {
  [name] = function()
    return "value"
  end,
}
palette.custom_command_handlers[category] = function(result)
  received = result
end
vim.cmd(palette.create_custom_command(category, name))
assert(received == "value", "escaped name did not dispatch")
local function count()
  local n = 0
  for _, group in ipairs(package.loaded.command_palette.CpMenu) do
    n = n + #group
  end
  return n
end
palette.setup()
local first = count()
palette.setup()
assert(count() == first, "repeated setup duplicated entries")
palette.insert_commands("test", { { "entry", "let g:palette_test = 1" } })
palette.setup_menu()
palette.insert_commands("test", { { "entry", "let g:palette_test = 2" } })
palette.setup_menu()
for _, group in ipairs(package.loaded.command_palette.CpMenu) do
  if group[1] == "test" then
    assert(#group == 2 and group[2][2] == "let g:palette_test = 2", "registration must update in place")
  end
end
-- Drive real cmdline input, rather than mocking getcmdline/setcmdline.
local cases = {
  { keys = ":<F6>", text = "SELECT", pos = 7 },
  { keys = ":abcXYZ<Left><Left><Left><F6>", text = "abcSELECTXYZ", pos = 10 },
  { keys = "i<C-O>:abc<F6>", text = "abcSELECT", pos = 10 },
  { keys = "/abc<F6>", text = "abcSELECT", pos = 10, type = "/" },
  { keys = "?abc<F6>", text = "abcSELECT", pos = 10, type = "?" },
  { keys = "i<C-R>=1+<F6>", text = "1+", pos = 3, type = "=", no_open = true },
  { keys = ":STALE<F6>", text = "SELECT", pos = 7, cancel = true },
  { keys = ":STALE<F8>", text = "SELECT", pos = 7, telescope_cancel = true },
}
local stage = 1
local opens = 0
local prior_opens = 0
local initial_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
vim.keymap.set("c", "<F8>", function()
  return palette.open_from_cmdline("telescope")
end, { expr = true })
vim.api.nvim_create_user_command("Telescope", function()
  opens = opens + 1
  vim.cmd("enew")
  vim.bo.filetype = "TelescopePrompt"
  local prompt = vim.api.nvim_get_current_buf()
  vim.defer_fn(function()
    vim.api.nvim_buf_delete(prompt, { force = true })
    vim.defer_fn(function()
      palette.custom_command_handlers.cmdline("SELECT")
    end, 20)
  end, 20)
end, { nargs = "*" })
vim.keymap.set("c", "<F6>", function()
  return palette.open_from_cmdline("fzf")
end, { expr = true })
vim.api.nvim_create_user_command("CommandPalette", function()
  opens = opens + 1
  if cases[stage].cancel then
    local original = vim.fn["vimrc#fzf#choices_in_commandline"]
    vim.fn["vimrc#fzf#choices_in_commandline"] = function()
      return ""
    end
    palette.open_with_fzf()
    vim.fn["vimrc#fzf#choices_in_commandline"] = original
    vim.schedule(function()
      palette.custom_command_handlers.cmdline("SELECT")
    end)
  else
    palette.custom_command_handlers.cmdline("SELECT")
  end
end, {})
vim.fn.timer_start(10, function()
  local text = vim.fn.getcmdline()
  local expected = cases[stage]
  if expected and text == expected.text then
    if
      vim.fn.getcmdpos() ~= expected.pos
      or vim.fn.getcmdtype() ~= (expected.type or ":")
      or opens ~= prior_opens + (expected.no_open and 0 or 1)
      or not vim.deep_equal(initial_lines, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    then
      print("unexpected cmdline: " .. vim.inspect({ text, vim.fn.getcmdpos() }))
      vim.cmd("cquit")
      return
    end
    prior_opens = opens
    stage = stage + 1
    vim.schedule(function()
      vim.api.nvim_input("<C-C>")
      vim.defer_fn(function()
        vim.api.nvim_input("<Esc>")
      end, 5)
      vim.defer_fn(function()
        if cases[stage] then
          vim.api.nvim_input(cases[stage].keys)
        else
          print("command palette: escaping, idempotence, registration update, cmdline text/cursor passed")
          vim.cmd("qa!")
        end
      end, 20)
    end)
  end
end, { ["repeat"] = -1 })
vim.defer_fn(function()
  print(
    "command palette test timed out: "
      .. vim.inspect({ stage, vim.fn.getcmdline(), vim.fn.getcmdpos(), vim.fn.getcmdtype(), opens, prior_opens })
  )
  vim.cmd("cquit")
end, 3000)
vim.schedule(function()
  vim.api.nvim_input(cases[stage].keys)
end)
