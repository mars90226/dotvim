local my_copilot = {}

my_copilot.attach_filters = {}

-- TODO: Better naming


-- TODO: Try "claude-sonnet-4.5"
-- TODO: codecompanion.nvim & CopilotChat.nvim uses chat/completions endpoint that's not supported by "gpt-5-codex"
-- Ref: https://github.com/CopilotC-Nvim/CopilotChat.nvim/issues/1442
my_copilot.default_model = "gpt-5"
my_copilot.default_github_model = "gpt-5"

-- NOTE: Use the model info from Copilot using CopilotChat.nvim
my_copilot.models = {
  ["gpt-5-codex"] = {
    model = "gpt-5-codex",
    max_tokens = 128000,
    reasoning_effort = "medium",
  },
  ["gpt-5-codex-high"] = {
    model = "gpt-5-codex",
    max_tokens = 128000,
    reasoning_effort = "high",
  },
  ["gpt-5"] = {
    model = "gpt-5",
    max_tokens = 128000,
    reasoning_effort = "medium",
  },
  ["gpt-5-high"] = {
    model = "gpt-5",
    max_tokens = 128000,
    reasoning_effort = "high",
  },
  ["gpt-5-mini"] = {
    model = "gpt-5-mini",
    max_tokens = 128000,
  },
  ["gpt-4.1"] = {
    model = "gpt-4.1",
    max_tokens = 128000,
  },
  ["gemini-2.5-pro"] = {
    model = "gemini-2.5-pro",
    max_tokens = 128000,
  },
  ["claude-sonnet-4"] = {
    model = "claude-sonnet-4",
    max_tokens = 128000,
  },
  ["claude-sonnet-4.5"] = {
    model = "claude-sonnet-4.5",
    max_tokens = 128000,
  },
}
my_copilot.github_models = vim.tbl_extend("force", my_copilot.models, {})

my_copilot.attach = function()
  -- Make buffer valid for copilot
  vim.opt.buflisted = true
  vim.opt.buftype = ""
  vim.cmd("Copilot! attach")
end

my_copilot.detach = function()
  -- Make buffer not valid for copilot
  vim.opt.buflisted = false
  vim.opt.buftype = "nofile"
  -- Do not call ":Copilot! detach" to avoid restarting LSP server
end

-- TODO: Replace this with copilot.lua's new `should_attach` function
-- Ref: [feat add should_attach function · zbirenbaumcopilot.lua@4a557e7](https://github.com/zbirenbaum/copilot.lua/commit/4a557e74514fd5918e8aabb55b8cfd10535a9a33)
my_copilot.add_attach_filter = function(filter)
  table.insert(my_copilot.attach_filters, filter)
end

my_copilot.setup_command = function()
  -- Force enable Copilot on non-'buflisted' special buffers like copilot-chat, codecompanion etc.
  vim.api.nvim_create_user_command("CopilotForceEnable", function()
    my_copilot.attach()
  end, {})
end

my_copilot.setup_autocmd = function()
  local augroup_id = vim.api.nvim_create_augroup("copilot_settings", {})
  vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      for _, filter in ipairs(my_copilot.attach_filters) do
        if filter() then
          my_copilot.attach()
          return
        end
      end
    end,
  })
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      for _, filter in ipairs(my_copilot.attach_filters) do
        if filter() then
          my_copilot.detach()
          return
        end
      end
    end,
  })
end

my_copilot.get_model = function(model_name)
  local model = my_copilot.models[model_name or my_copilot.default_model]
  if model == nil then
    vim.notify("Invalid Copilot model: " .. model_name, vim.log.levels.ERROR)
    model = my_copilot.models[my_copilot.default_model]
  end
  return model
end

my_copilot.setup = function()
  my_copilot.setup_command()
  my_copilot.setup_autocmd()
end

return my_copilot
