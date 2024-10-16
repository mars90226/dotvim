local gitlab = require("gitlab")
local gitlab_server = require("gitlab.server")

local my_gitlab = {}

my_gitlab.minimize_discussion = function()
  vim.cmd([[wincmd t]]) -- Navigate to discussion panel
  vim.cmd([[vertical resize 1]])

  vim.cmd([[wincmd b]]) -- Navigate to the current version file of the git diff
  vim.cmd([[vertical resize ]]..math.floor((vim.o.columns - 3 - 1 - vim.g.left_sidebar_width) / 2))
end

my_gitlab.reset_discussion = function()
  vim.cmd([[wincmd t]]) -- Navigate to discussion panel
  vim.cmd([[vertical resize ]]..vim.g.left_sidebar_width)
end

my_gitlab.setup_config = function()
  gitlab.setup({
    debug = { go_request = false, go_response = false },
  })
end

my_gitlab.setup_mapping = function()
  vim.keymap.set("n", "glrr", gitlab.review, { desc = "GitLab review" })
  vim.keymap.set("n", "gls", gitlab.summary, { desc = "GitLab summary" })
  vim.keymap.set("n", "glA", gitlab.approve, { desc = "GitLab approve" })
  vim.keymap.set("n", "glR", gitlab.revoke, { desc = "GitLab revoke" })
  vim.keymap.set("n", "glc", gitlab.create_comment, { desc = "GitLab create comment" })
  vim.keymap.set("v", "glc", gitlab.create_multiline_comment, { desc = "GitLab create multiline comment" })
  vim.keymap.set("v", "glC", gitlab.create_comment_suggestion, { desc = "GitLab create comment suggestion" })
  vim.keymap.set("n", "glO", gitlab.create_mr, { desc = "GitLab create MR" })
  vim.keymap.set("n", "glm", gitlab.move_to_discussion_tree_from_diagnostic, { desc = "GitLab move to discussion tree from diagnostic" })
  vim.keymap.set("n", "gln", gitlab.create_note, { desc = "GitLab create note" })
  vim.keymap.set("n", "gld", gitlab.toggle_discussions, { desc = "GitLab toggle discussions" })
  vim.keymap.set("n", "glaa", gitlab.add_assignee, { desc = "GitLab add assignee" })
  vim.keymap.set("n", "glad", gitlab.delete_assignee, { desc = "GitLab delete assignee" })
  vim.keymap.set("n", "glra", gitlab.add_reviewer, { desc = "GitLab add reviewer" })
  vim.keymap.set("n", "glrd", gitlab.delete_reviewer, { desc = "GitLab delete reviewer" })
  vim.keymap.set("n", "glp", gitlab.pipeline, { desc = "GitLab pipeline" })
  vim.keymap.set("n", "glo", gitlab.open_in_browser, { desc = "GitLab open in browser" })
  vim.keymap.set("n", "glM", gitlab.merge, { desc = "GitLab merge MR" })
  vim.keymap.set("n", "glb", function ()
    gitlab_server.restart(function ()
      vim.cmd.tabclose()
      gitlab.review() -- Reopen the reviewer after the server restarts
    end)
  end, { desc = "Restart gitlab.nvim server & review" })
  vim.keymap.set("n", "glk", function ()
    gitlab_server.restart(function ()
      vim.notifiy("GitLab server restarted")
    end)
  end, { desc = "Restart gitlab.nvim server" })
end

my_gitlab.setup = function()
  my_gitlab.setup_config()
  my_gitlab.setup_mapping()
end

return my_gitlab
