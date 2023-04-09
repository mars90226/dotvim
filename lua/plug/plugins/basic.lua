local basic = {
  {
    "folke/lazy.nvim",
    priority = 10000,
  },
  {
    dir = vim.env.HOME .. "/.vim_secret",
    lazy = false,
    priority = 1001,
  },
}

return basic
