local has_surroud, surround = pcall(require, "nvim-surround")

local my_nvim_surround = require("vimrc.plugins.nvim_surround")

vim.bo.expandtab = true
vim.wo.spell = false -- NOTE: Chinese is not supported

if vim.fn.executable("markdownlint") == 1 then
  vim.bo.makeprg = "markdownlint"
end

if has_surroud then
  -- NOTE: 2-characters cannot use default find & delete & change implementation
  surround.buffer_setup({
    surrounds = {
      ["*"] = my_nvim_surround.same_all("**"),
      ["_"] = my_nvim_surround.same_all("__"),
      ["~"] = my_nvim_surround.same_all("~~"),
      ["l"] = {
        add = function()
          return {
            { "[" },
            vim.split("](" .. vim.fn.getreg("*") .. ")", "\n"),
          }
        end,
        -- TODO: Implement find, delete, change
        find = function() end,
        delete = function() end,
        change = { target = function() end },
      },
    },
  })
end
