local my_copilot = {}

my_copilot.attach_filters = {}

-- TODO: Better naming

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
  -- Do not call Copilot! detach to avoid restarting LSP server
end

my_copilot.add_attach_filter = function(filter)
  table.insert(my_copilot.attach_filters, filter)
end

my_copilot.setup_command = function()
  -- Force enable Copilot on non-'buflisted' special buffers like AvanteInput, copilot-chat, codecompanion etc.
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

my_copilot.setup = function()
  my_copilot.setup_command()
  my_copilot.setup_autocmd()
end

return my_copilot
