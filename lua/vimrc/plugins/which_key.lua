local my_which_key = {}

my_which_key.setup = function(opts)
  require("which-key").setup(opts)

  ---@type integer?
  local previous_timeoutlen
  local function update_timeoutlen()
    if vim.bo.buftype == "nowrite" then
      if previous_timeoutlen == nil then
        previous_timeoutlen = vim.go.timeoutlen
        vim.go.timeoutlen = 600
      end
    elseif previous_timeoutlen ~= nil then
      vim.go.timeoutlen = previous_timeoutlen
      previous_timeoutlen = nil
    end
  end

  local group = vim.api.nvim_create_augroup("which_key_timeoutlen", { clear = true })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = update_timeoutlen,
  })
  vim.api.nvim_create_autocmd("OptionSet", {
    group = group,
    pattern = "buftype",
    callback = function()
      -- Changing a hidden buffer's option temporarily makes it current.
      vim.schedule(update_timeoutlen)
    end,
  })
  update_timeoutlen()
end

return my_which_key
