local my_copilot = require("vimrc.plugins.copilot")

local codecompanion = {}

codecompanion.default_copilot_model = my_copilot.default_model
codecompanion.copilot_models = {}

for model_name, model in pairs(my_copilot.models) do
  codecompanion.copilot_models[model_name] = {
    schema = {
    },
  }

  for key, value in pairs(model) do
    codecompanion.copilot_models[model_name].schema[key] = {
      default = value,
    }
  end
end

-- Ref: [Snippet to add the ability to saveload CodeCompanion chats in neovim](https://gist.github.com/itsfrank/942780f88472a14c9cbb3169012a3328)
codecompanion.setup_save_load = function()
  -- add 2 commands:
  --    CodeCompanionSave [space delimited args]
  --    CodeCompanionLoad
  -- Save will save current chat in a md file named 'space-delimited-args.md'
  -- Load will use a telescope filepicker to open a previously saved chat

  -- create a folder to store our chats
  local Path = require("plenary.path")
  local data_path = vim.fn.stdpath("data")
  local save_folder = Path:new(data_path, "cc_saves")
  if not save_folder:exists() then
    save_folder:mkdir({ parents = true })
  end

  -- telescope picker for our saved chats
  vim.api.nvim_create_user_command("CodeCompanionLoad", function()
    -- TODO: Use fzf-lua
    local t_builtin = require("telescope.builtin")
    local t_actions = require("telescope.actions")
    local t_action_state = require("telescope.actions.state")

    local function start_picker()
      t_builtin.find_files({
        prompt_title = "Saved CodeCompanion Chats | <c-d>: delete",
        cwd = save_folder:absolute(),
        attach_mappings = function(_, map)
          map("i", "<c-d>", function(prompt_bufnr)
            local selection = t_action_state.get_selected_entry()
            local filepath = selection.path or selection.filename
            os.remove(filepath)
            t_actions.close(prompt_bufnr)
            start_picker()
          end)
          return true
        end,
      })
    end
    start_picker()
  end, {})

  -- save current chat, `CodeCompanionSave foo bar baz` will save as 'foo-bar-baz.md'
  vim.api.nvim_create_user_command("CodeCompanionSave", function(opts)
    local codecompanion = require("codecompanion")
    local success, chat = pcall(function()
      return codecompanion.buf_get_chat(0)
    end)
    if not success or chat == nil then
      vim.notify("CodeCompanionSave should only be called from CodeCompanion chat buffers", vim.log.levels.ERROR)
      return
    end
    if #opts.fargs == 0 then
      vim.notify("CodeCompanionSave requires at least 1 arg to make a file name", vim.log.levels.ERROR)
    end
    local save_name = table.concat(opts.fargs, "-") .. ".md"
    local save_path = Path:new(save_folder, save_name)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    save_path:write(table.concat(lines, "\n"), "w")
  end, { nargs = "*" })
end

codecompanion.get_copilot_model = function(name)
  local copilot_model = codecompanion.copilot_models[name or codecompanion.default_copilot_model]
  if copilot_model == nil then
    vim.notify("Invalid Copilot model: " .. name, vim.log.levels.ERROR)
    copilot_model = codecompanion.copilot_models[codecompanion.default_copilot_model]
  end

  return copilot_model
end

codecompanion.set_default_copilot_model = function(name)
  local copilot_model = codecompanion.copilot_models[name]
  if copilot_model == nil then
    vim.notify("Invalid Copilot model: " .. name, vim.log.levels.ERROR)
    return
  end

  codecompanion.default_copilot_model = name
end

codecompanion.choose_copilot_models = function()
  vim.ui.select(vim.tbl_keys(codecompanion.copilot_models), {
    prompt = "Choose a Copilot model",
  }, function(name)
    codecompanion.set_default_copilot_model(name)
  end)
end

codecompanion.setup_command = function()
  vim.api.nvim_create_user_command("CodeCompanionChooseCopilotModels", codecompanion.choose_copilot_models, {})
end

codecompanion.setup_autocmd = function()
  -- Trick to make copilot.lua work with CodeCompanion
  my_copilot.add_attach_filter(function()
    return vim.bo.filetype == "codecompanion"
  end)
end

codecompanion.setup = function()
  codecompanion.setup_save_load()
  codecompanion.setup_command()
  codecompanion.setup_autocmd()
end

return codecompanion
