vim.bo.expandtab = true

require("nvim-surround").buffer_setup({
  delimiters = {
    pairs = {
      ["*"] = { "**", "**" },
      ["_"] = { "__", "__" },
      ["~"] = { "~~", "~~" },
      ["l"] = function()
        return {
          "[",
          "](" .. vim.fn.getreg("*") .. ")",
        }
      end,
    },
  },
})
