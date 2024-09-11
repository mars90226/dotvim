local dropbar = {}

local actions = {
  quit = "<C-W>c",
  goto_parent = "<C-W>c",
  click_component = function()
    local menu = require("dropbar.api").get_current_dropbar_menu()
    if not menu then
      return
    end
    local cursor = vim.api.nvim_win_get_cursor(menu.win)
    local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
    if component then
      menu:click_on(component, nil, 1, "l")
    end
  end
}

dropbar.setup = function()
  require("dropbar").setup({
    general = {
      update_interval = 200,
    },
    menu = {
      keymaps = {
        ["<Left>"] = actions.goto_parent,
        ["<Right>"] = actions.click_component,
        ["p"] = actions.goto_parent,
        ["o"] = actions.click_component,
        ["q"] = actions.quit,
      },
    },
  })

  vim.keymap.set("n", "<Space>dp", function()
    require("dropbar.api").pick()
  end, { desc = "Pick dropbar component" })
end

return dropbar
