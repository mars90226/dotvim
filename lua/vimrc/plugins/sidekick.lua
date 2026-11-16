local sidekick = {}

local review_unique_instructions = [[請用繁體中文回答，忽略 agent plan。

請先用 `glab mr view --comments`（不指定編號，使用目前 branch 對應的 MR）讀取討論。
若 MR 討論或本對話中有本次指定範圍內的既有 review 意見，逐項依目前程式與 MR 討論重新確認：
- 已修正或 MR 明確決定不修：排除。
- 仍成立、尚未修正且未決定不修：保留在本次報告，標示「既有未解決」。
- 無法確認：列出待確認原因，不得默認已解決。

若沒有既有 review 意見，直接進行本次 review，不必尋找或要求提供前次結果。

曾出現在本對話、前次 AI review 或其他 reviewer 報告中，不是排除理由。
這項要求優先於 review skill 排除 already-known findings 的預設。
同根因問題只合併一次；報告須涵蓋新增問題及既有未解決問題。

若 MR 已 merged 或 closed，請先跟我確認。]]

sidekick.prompts = {
  git_branch = "{git_branch}",
  git_branch_selected = "{git_branch_selected}",
  review_from_base = "/review review base `tmp-review-base`, 請用繁體中文回答",
  review_unique = "/review review `tmp-review-base..@`。\n\n" .. review_unique_instructions,
  review_unique_instructions = review_unique_instructions,
  rebase_from_base = "OK，沒有更多 review 意見了，我們可以 rebase 了，請將 `tmp-review-base..@` 的 commit 重新 rebase",
  chinese = "請用繁體中文回答",
}

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
