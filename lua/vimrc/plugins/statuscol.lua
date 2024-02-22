local statuscol = require("statuscol")
local builtin = require("statuscol.builtin")

local my_statuscol = {}

my_statuscol.setup = function()
  statuscol.setup({
    -- Segments: (sign -> line number -> gitsigns -> fold -> separator )
    -- Similar to Visual Studio Code
    -- Ref: https://github.com/ofseed/nvim/blob/e0edff34c98e5ac57360273b0d0161b04fc32765/lua/plugins/ui/statuscol.lua
    bt_ignore = { 'help', 'nofile', 'terminal' },
    segments = {
      {
        sign = {
          name = { ".*" },
          text = { ".*" },
        },
        click = "v:lua.ScSa",
      },
      {
        text = { builtin.lnumfunc },
        condition = { true, builtin.not_empty },
        click = "v:lua.ScLa",
      },
      {
        sign = {
          namespace = { "gitsigns" },
          colwidth = 1,
          wrap = true,
        },
        click = "v:lua.ScSa",
      },
      {
        text = {
          function(args)
            args.fold.close = ""
            args.fold.open = ""
            args.fold.sep = "│"
            return builtin.foldfunc(args)
          end,
        },
        click = "v:lua.ScSa",
      },
      {
        text = { " " },
        hl = "Normal",
      },
    },
  })

  vim.api.nvim_create_user_command("ResetStatusColumn", function()
    vim.wo.statuscolumn = ""
    vim.wo.statuscolumn = "%!v:lua.StatusCol()"
  end, {})
end

return my_statuscol
