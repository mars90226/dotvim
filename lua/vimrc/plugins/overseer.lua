local overseer = {}

overseer.setup = function()
  require("overseer").setup({
    -- Aliases for bundles of components. Redefine the builtins, or create your own.
    component_aliases = {
      -- Most tasks are initialized with the default components
      default = {
        { "display_duration", detail_level = 2 },
        "on_output_summarize",
        "on_exit_set_status",
        "on_complete_notify",
        -- "on_complete_dispose", -- NOTE: Do not dispose to preserve the tasks with parameters
      },
    },
  })

  -- NOTE: Workaround entering insert mode due to terminal buffer autocmd in OverseerList
  -- FIXME: Check if this works
  local augroup_id = vim.api.nvim_create_augroup("overseer_settings", {})
  vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      if vim.bo.filetype == "OverseerList" and vim.api.nvim_get_mode().mode == "i" then
        vim.cmd([[stopinsert]])
      end
    end,
  })
end

return overseer
