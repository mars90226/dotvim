local M = {}

--- Setup AnyJump settings.
--- Maps keys for split and vsplit actions in the current buffer,
--- then sets rounded borders for AnyJump windows,
--- then extends the UI for AnyJump.
function M.settings()
  vim.keymap.set(
    "n",
    "S",
    ":call g:AnyJumpHandleOpen('split')<CR><C-W>r",
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    "n",
    "V",
    ":call g:AnyJumpHandleOpen('vsplit')<CR><C-W>r",
    { noremap = true, silent = true, buffer = true }
  )

  -- Set rounded borders for AnyJump windows.
  vim.api.nvim_win_set_config(0, { border = "rounded" })

  -- Extend AnyJump's UI by wrapping its RenderUi function.
  -- Here, we assume that the tabpage-local variable 'any_jump' is stored in vim.t.any_jump.
  M.extend_ui(vim.t.any_jump)
end

--- Extend the AnyJump UI.
--- Wraps the current any_jump.RenderUi function with our custom renderer.
--- @param any_jump table The AnyJump object containing UI-related methods.
function M.extend_ui(any_jump)
  local original_render_ui = any_jump.RenderUi
  any_jump.RenderUi = function()
    M.render_ui_extend(any_jump, original_render_ui)
  end
end

--- Extended render UI function for AnyJump.
--- Calls the original RenderUi and then appends custom help lines.
--- @param any_jump table The AnyJump object.
--- @param original_render_ui function The original render UI function.
function M.render_ui_extend(any_jump, original_render_ui)
  -- Call the original render function.
  original_render_ui()

  -- Retrieve colors for help elements.
  local color = vim.fn["AnyJumpGetColor"]("help")
  local heading_color = vim.fn["AnyJumpGetColor"]("heading_text")

  -- Append custom help lines.
  any_jump.AddLine({ any_jump.CreateItem("help_text", "", color) })
  any_jump.AddLine({ any_jump.CreateItem("help_link", "> Custom Help", heading_color) })
  any_jump.AddLine({ any_jump.CreateItem("help_text", "", color) })
  any_jump.AddLine({
    any_jump.CreateItem("help_text", "[S] open in rightbelow split  [V] open in rightbelow vsplit", color),
  })
end

return M
