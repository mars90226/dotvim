vim.bo.expandtab = true

require("nvim-surround").buffer_setup({
  delimiters = {
    pairs = {
      ["l"] = function()
        return {
          "[",
          "](" .. vim.fn.getreg("*") .. ")",
        }
      end,
    },
  },
})
