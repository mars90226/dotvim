local neorg = {}

neorg.setup = function()
  require("neorg").setup({
    -- Tell Neorg what modules to load
    load = {
      ["core.defaults"] = {}, -- Load all the default modules
      ["core.norg.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },
      ["core.norg.concealer"] = {}, -- Allows for use of icons
      ["core.norg.dirman"] = { -- Manage your directories with Neorg
        config = {
          workspaces = {
            my_workspace = "~/neorg",
            -- TODO: Wait for gtd config
            -- gtd = "~/gtd",
          },
        },
      },
      ["core.norg.qol.toc"] = {},
      -- TODO: Need to create workspace folder first
      -- ["core.gtd.base"] = {
      --   config = {
      --     workspace = "~/gtd",
      --   },
      -- },
    },
  })

  -- TODO: Add check for nvim-treesitter, and disable treesitter module
  require("nvim-treesitter.install").ensure_installed({
    "norg",
    "norg_meta",
    "norg_table",
  })
end

return neorg
