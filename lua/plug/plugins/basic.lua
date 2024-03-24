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
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  }
}

return basic
