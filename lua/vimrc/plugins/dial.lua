local dial = {}

dial.setup = function()
  local augend = require("dial.augend")
  require("dial.config").augends:register_group({
    -- default augends used when no group name is specified
    default = {
      -- NOTE: Original default
      augend.integer.alias.decimal, -- non-negative decimal number (0, 1, 2, 3, ...)
      augend.integer.alias.hex, -- non-negative hex number (0x01, 0x1a1f, etc.)
      augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
      augend.date.alias["%Y-%m-%d"],
      augend.date.alias["%m/%d"],
      augend.date.alias["%H:%M"],
      augend.constant.alias.ja_weekday_full,

      -- Custom
      augend.date.alias["%H:%M:%S"],
      augend.constant.alias.bool,
      augend.constant.new({
        elements = { "and", "or" },
        word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
        cyclic = true, -- "or" is incremented into "and".
      }),
      augend.constant.new({
        elements = { "&&", "||" },
        word = false,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "yes", "no" },
        word = true,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "on", "off" },
        word = true,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "True", "False" }, -- Python bool
        word = true,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "DEBUG", "INFO", "WARN", "ERROR" }, -- Log level
        word = true,
        cyclic = true,
      }),
      -- Logseq
      augend.constant.new({
        elements = { "TODO", "DONE" },
        word = true,
        cyclic = true,
      }),
      augend.constant.new({
        elements = { "NOW", "LATER" },
        word = true,
        cyclic = true,
      }),
      augend.semver.alias.semver,
    },
  })

  vim.api.nvim_set_keymap("n", "<C-A>", require("dial.map").inc_normal(), { noremap = true })
  vim.api.nvim_set_keymap("n", "<C-X>", require("dial.map").dec_normal(), { noremap = true })
  vim.api.nvim_set_keymap("v", "<C-A>", require("dial.map").inc_visual(), { noremap = true })
  vim.api.nvim_set_keymap("v", "<C-X>", require("dial.map").dec_visual(), { noremap = true })
  vim.api.nvim_set_keymap("v", "g<C-A>", require("dial.map").inc_gvisual(), { noremap = true })
  vim.api.nvim_set_keymap("v", "g<C-X>", require("dial.map").dec_gvisual(), { noremap = true })
end

return dial
