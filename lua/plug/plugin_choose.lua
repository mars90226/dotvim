local choose = require("vimrc.choose")

local plugin_choose = {}

plugin_choose.setup = function()
  -- plugin management
  vim.api.nvim_create_user_command("ListDisabledPlugins", function()
    choose.print_disabled_plugins()
  end, {})

  -- Start choosing
  choose.clear_disabled_plugins()

  require("plug.choose.appearance").setup()
  require("plug.choose.completion").setup()
  require("plug.choose.file_explorer").setup()
  require("plug.choose.finder").setup()
  require("plug.choose.text_navigation").setup()
  require("plug.choose.language").setup()
  require("plug.choose.git").setup()
  require("plug.choose.terminal").setup()
  require("plug.choose.misc").setup()
end

return plugin_choose
