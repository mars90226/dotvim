local choose = require("vimrc.choose")

local cmdwin = {}

cmdwin.setup = function()
  if choose.is_enabled_plugin("nvim-surround") then
    local surround = require("nvim-surround")
    local my_nvim_surround = require("vimrc.plugins.nvim_surround")

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
end

return cmdwin
