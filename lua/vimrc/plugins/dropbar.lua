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
  end,
}

dropbar.setup = function()
  require("dropbar").setup({
    bar = {
      update_debounce = 200,
      -- Ref: dropbar/config.lua
      enable = function(buf, win, _)
        buf = vim._resolve_bufnr(buf)
        if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
          return false
        end

        if
          not vim.api.nvim_buf_is_valid(buf)
          or not vim.api.nvim_win_is_valid(win)
          or vim.fn.win_gettype(win) ~= ""
          or vim.wo[win].winbar ~= ""
          or vim.bo[buf].ft == "help"
        then
          return false
        end

        local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
        if stat and stat.size > 1024 * 1024 then
          return false
        end

        -- NOTE: Don't attach sidekick.nvim terminal, but attach other terminal buffers.
        -- sidekick.nvim terminal use tmux for backend and it will close 'winbar' anyway.
        return (vim.bo[buf].bt == "terminal" and vim.bo[buf].ft ~= "sidekick_terminal")
          or vim.bo[buf].ft == "markdown"
          or (function()
            local ok, parser = pcall(vim.treesitter.get_parser, buf)
            return ok and parser ~= nil
          end)()
          or not vim.tbl_isempty(vim.lsp.get_clients({
            bufnr = buf,
            method = "textDocument/documentSymbol",
          }))
      end,
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
