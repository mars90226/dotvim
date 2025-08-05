local copilot = require("vimrc.plugins.copilot")

local avante = {}

avante.get_copilot_model = function(model_name)
  local copilot_model = copilot.get_model(model_name)
  local avante_model = {
    model = copilot_model.model,
    extra_request_body = copilot_model,
  }

  return avante_model
end

return avante
