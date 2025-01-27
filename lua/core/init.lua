local core = {}

core.setup = function()
  require("core.setting").setup()
  require("core.diagnostic").setup()
  require("core.mapping").setup()
  require("core.filetype").setup()
  require("core.syntax").setup()
  require("core.terminal").setup()
  require("core.autocmd").setup()
  require("core.float").setup()
  require("core.job").setup()
  require("core.cli").setup()
  require("core.tui").setup()
  require("core.clipboard").setup()
end

return core
