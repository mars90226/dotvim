-- Clangd
nnoremap("<M-`>", [[<Cmd>ClangdSwitchSourceHeader<CR>]], "<silent>", "<buffer>")
-- TODO: Make it work in c/cpp
nnoremap("<M-]>", function()
  local go_to_tag = function()
    vim.cmd([[silent! tag ]]..vim.fn.expand("<cword>"))
  end
  local switch_back_and_go_to_tag = function(bufnr, pos)
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_win_set_cursor(0, pos)
    go_to_tag()
  end

  local start_bufnr = vim.api.nvim_get_current_buf()
  go_to_tag()
  local current_bufnr = vim.api.nvim_get_current_buf()

  if current_bufnr == start_bufnr then
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[ClangdSwitchSourceHeader]])

    vim.fn.timer_start(200, function()
      local switched_bufnr = vim.api.nvim_get_current_buf()
      if switched_bufnr == current_bufnr then
        -- NOTE: Clangd cannot find corresponding files, use other.nvim
        vim.api.nvim_exec([[Other]], false)

        -- FIXME: Not work...
        vim.fn.timer_start(200, function()
          switch_back_and_go_to_tag(current_bufnr, pos)
        end)
      else
        switch_back_and_go_to_tag(current_bufnr, pos)
      end
    end)
  end
end, { silent = true, buffer = true, desc = "Switch between source/header using Clangd & tags"})
