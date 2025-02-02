local gitlab = require("gitlab")
local gitlab_server = require("gitlab.server")

local my_copilot = require("vimrc.plugins.copilot")

local my_gitlab = {}

my_gitlab.panel_height = 12

my_gitlab.is_comment_popup = function(buf)
  local comment_popup = require("gitlab.actions.comment").comment_popup
  return comment_popup and comment_popup.bufnr == buf
end

my_gitlab.minimize_discussion = function()
  vim.cmd([[resize 1]])
end

my_gitlab.reset_discussion = function()
  vim.cmd([[resize ]] .. my_gitlab.panel_height)
end

my_gitlab.setup_config = function()
  gitlab.setup({
    debug = { go_request = false, go_response = false },
  })
end

my_gitlab.setup_mapping = function()
  vim.keymap.set("n", "glb", function()
    gitlab_server.restart(function()
      vim.cmd.tabclose()
      gitlab.review() -- Reopen the reviewer after the server restarts
    end)
  end, { desc = "Restart gitlab.nvim server & review" })
  vim.keymap.set("n", "glk", function()
    gitlab_server.restart(function()
      vim.notifiy("GitLab server restarted")
    end)
  end, { desc = "Restart gitlab.nvim server" })
  vim.keymap.set("n", "glrc", function()
    gitlab.choose_merge_request({ state = "all" })
  end, { desc = "GitLab choose merge request" })
end

my_gitlab.setup_autocmd = function()
  -- Trick to make copilot.lua & nvim-cmp work with gitlab.nvim's comment popup & note popup
  my_copilot.add_attach_filter(function()
    return my_gitlab.is_comment_popup(vim.api.nvim_get_current_buf())
  end)
end

my_gitlab.setup = function()
  my_gitlab.setup_config()
  my_gitlab.setup_mapping()
  my_gitlab.setup_autocmd()
end

return my_gitlab
