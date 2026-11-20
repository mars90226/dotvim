vim.opt.runtimepath:prepend(vim.fn.getcwd())

local defaults = "--color=always --smart-case"
local max_columns = " --max-columns=4096"
local location = " --with-filename --no-heading --line-number --column"
local location_opts = location .. " -e"
local captured
local function grep(opts)
  captured = opts
end

package.loaded["fzf-lua"] = { grep = grep, grep_curbuf = grep, grep_visual = grep, setup = grep }
package.loaded["fzf-lua.actions"] = {}
package.loaded["fzf-lua.utils"] = {
  get_visual_selection = function()
    return "needle"
  end,
}

local fzf = require("vimrc.plugins.fzf_lua")
fzf.setup_config()
assert(captured.grep.rg_opts == defaults .. max_columns .. location_opts)
assert(captured.grep.no_esc)
fzf.setup_mapping()
local extra_rg_opts
vim.fn.input = function(prompt)
  if prompt == "Grep in directory: " then
    return "search dir"
  end
  assert(prompt == "Grep options: ", prompt)
  return extra_rg_opts
end

local function mapping(mode, key, args)
  captured = nil
  extra_rg_opts = args
  vim.fn.maparg("<Space>f" .. key, mode, false, true).callback()
  return assert(captured)
end

local filters = [[--heading --glob "*.lua" --case-sensitive --color=never --max-columns=8192]]
local opts = mapping("n", "e", filters)
assert(opts.cwd == "search dir")
assert(opts.rg_opts == defaults .. " " .. filters .. location_opts)
assert(mapping("n", "e", " ").rg_opts == defaults .. location_opts)
assert(mapping("n", "R").rg_opts == defaults .. max_columns .. " --no-ignore --hidden" .. location_opts)
assert(mapping("n", "4", "--hidden").rg_opts == defaults .. " --hidden" .. location_opts)
assert(mapping("n", "e", "-F --").rg_opts == defaults .. " -F" .. location .. " --")
assert(mapping("n", "e", "-F -e").rg_opts == defaults .. " -F" .. location_opts)
assert(mapping("n", "e", "-F --regexp").rg_opts == defaults .. " -F" .. location_opts)
assert(mapping("n", "4", "--").rg_opts == defaults .. location .. " --")
local replacement = [[--replace foo\ --]]
assert(mapping("n", "4", replacement).rg_opts == defaults .. " " .. replacement .. location_opts)

opts = mapping("x", "3", "--fixed-strings")
assert(opts.search == "needle")
assert(opts.rg_opts == defaults .. " --fixed-strings" .. location_opts)

print("PASS: fzf-lua grep preserves custom search options and location fields")
