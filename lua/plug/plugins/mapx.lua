local mapx = {
  {
    "b0o/mapx.nvim",
    init = function()
      local has_mapx, mapx = pcall(require, "mapx")

      if has_mapx and mapx.globalized ~= true then
        mapx.setup({ global = true })
      end
    end,
  },
}

return mapx
