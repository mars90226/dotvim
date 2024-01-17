local mapx = {
  -- TODO: Replace this with builtin neovim vim.keymap
  {
    "b0o/mapx.nvim",
    lazy = false,
    priority = 1000, -- ensure we can use mapx in other places
    init = function()
      local has_mapx, mapx = pcall(require, "mapx")

      if has_mapx and mapx.globalized ~= true then
        mapx.setup({ global = true })
      end
    end,
  },
}

return mapx
