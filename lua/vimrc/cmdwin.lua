local surround = require("nvim-surround")

local my_nvim_surround = require("vimrc.plugins.nvim_surround")


local cmdwin = {}

cmdwin.setup = function()
  -- Removing any key mapping for special keys in cmdline-window
  nnoremap("<CR>", "<CR>", "<buffer>")
  nnoremap("<C-P>", "<C-P>", "<buffer>")
  nnoremap("<C-N>", "<C-N>", "<buffer>")

  surround.buffer_setup({
    surrounds = {
      ["*"] = my_nvim_surround.create_all([[\<]], [[\>]]),
      ["B"] = my_nvim_surround.create_all([[\b]], [[\b]]),
    }
  })
end

return cmdwin
