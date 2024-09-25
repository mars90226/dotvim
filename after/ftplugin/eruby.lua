local choose = require("vimrc.choose")

if choose.is_enabled_plugin("nvim-surround") then
  local surround = require("nvim-surround")
  local my_nvim_surround = require("vimrc.plugins.nvim_surround")

  -- NOTE: 2-characters cannot use default find & delete & change implementation
  surround.buffer_setup({
    surrounds = {
      ["%"] = my_nvim_surround.create_all("<% ", " %>"),
      ["="] = my_nvim_surround.create_all("<%= ", " %>"),
    },
  })
end
