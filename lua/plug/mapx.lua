local mapx = {}

mapx.load_mapx = function()
  local has_mapx, mapx = pcall(require, "mapx")

  if has_mapx and mapx.globalized ~= true then
    mapx.setup({ global = true })
  end
end

mapx.startup = function(use)
  use("b0o/mapx.nvim")

  mapx.load_mapx()
end

return mapx
