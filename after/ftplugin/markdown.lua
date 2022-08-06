local surround = require("nvim-surround")
local surround_config = require("nvim-surround.config")

vim.bo.expandtab = true

-- NOTE: 2-characters cannot use default find & delete & change implementation
surround.buffer_setup({
  surrounds = {
    ["*"] = {
      add = { "**", "**" },
      find = "%*%*[^*]-%*%*",
      delete = "^(..)().-(..)()$",
      change = {
        target = "^(..)().-(..)()$",
      },
    },
    ["_"] = {
      add = { "__", "__" },
      find = "__[^*]-__",
      delete = "^(..)().-(..)()$",
      change = {
        target = "^(..)().-(..)()$",
      },
    },
    ["~"] = {
      add = { "~~", "~~" },
      find = "~~[^*]-~~",
      delete = "^(..)().-(..)()$",
      change = {
        target = "^(..)().-(..)()$",
      },
    },
    ["l"] = {
      add = function()
        return {
          { "[" },
          vim.split("](" .. vim.fn.getreg("*") .. ")", "\n"),
        }
      end,
      -- TODO: Implement find, delete, change
      find = function() end,
      delete = function() end,
      change = { target = function() end },
    },
  },
})
