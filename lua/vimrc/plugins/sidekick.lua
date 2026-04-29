local sidekick = {}

sidekick.selected_git_branch = nil

sidekick.create_new_tools = function(name, ...)
  local sidekick_config = require("sidekick.config")
  local tool = { cmd = { ... } }
  sidekick_config.cli.tools[name] = tool
end

local function git(cwd, args)
  local result = vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
  if result.code ~= 0 then
    return nil
  end
  return vim.trim(result.stdout)
end

sidekick.current_git_branch = function(ctx)
  local cwd = ctx and ctx.cwd or vim.fn.getcwd(0)
  local branch = git(cwd, { "branch", "--show-current" })
  if branch and branch ~= "" then
    return branch
  end

  local commit = git(cwd, { "rev-parse", "--short", "HEAD" })
  if commit and commit ~= "" then
    return "detached HEAD @ " .. commit
  end

  return false
end

sidekick.get_selected_git_branch = function()
  return sidekick.selected_git_branch or false
end

local function branch_from_item(item)
  if not item then
    return nil
  end
  if item.branch and item.branch ~= "" then
    return item.branch
  end
  if item.commit and item.commit ~= "" then
    return item.commit
  end
  return item.text and vim.trim(item.text) or nil
end

sidekick.git_branch_from_snacks_item = branch_from_item

sidekick.send_git_branch_from_picker = function(picker)
  local item = picker:selected({ fallback = true })[1]
  local branch = branch_from_item(item)
  picker:close()

  if not branch or branch == "" then
    return
  end

  sidekick.selected_git_branch = branch
  require("sidekick.cli").send({ msg = branch })
end

sidekick.select_git_branch = function(opts)
  opts = opts or {}
  local context = require("sidekick.cli.context").ctx()

  Snacks.picker.git_branches({
    all = opts.all ~= false,
    cwd = context.cwd,
    confirm = function(picker)
      sidekick.send_git_branch_from_picker(picker)
    end,
  })
end

return sidekick
