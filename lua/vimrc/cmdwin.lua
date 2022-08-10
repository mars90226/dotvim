local cmdwin = {}

cmdwin.setup = function()
  -- Removing any key mapping for <CR> in cmdline-window
  nnoremap("<CR>", "<CR>", "<buffer>")
end

return cmdwin
