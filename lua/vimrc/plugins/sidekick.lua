local sidekick = {}

sidekick.create_new_tools = function(name, ...)
  local sidekick_config = require("sidekick.config")
  local tool = { cmd = { ... } }
  sidekick_config.cli.tools[name] = tool
end

return sidekick
