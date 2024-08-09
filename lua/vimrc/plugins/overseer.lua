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

  require("vimrc.terminal").add_startinsert_ignore_condition(function()
    return vim.b.overseer_task == 1
  end)
end

return overseer
