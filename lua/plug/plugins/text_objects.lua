local text_objects = {
  {
    "wellle/targets.vim",
    event = { "VimEnter" },
    config = function()
      -- Reach targets
      -- TODO: Other input method to avoid cursor moving?
      -- FIXME: Setup which-key.nvim & lazy load
      -- TODO: Replace with mini.ai
      nmap("]r", [['vin'.v:lua.require("vimrc.utils").get_char_string()."o\<Esc>"]], "expr")
      nmap("[r", [['vil'.v:lua.require("vimrc.utils").get_char_string()."\<Esc>"]], "expr")
      nmap("]R", [['van'.v:lua.require("vimrc.utils").get_char_string()."o\<Esc>"]], "expr")
      nmap("[R", [['val'.v:lua.require("vimrc.utils").get_char_string()."\<Esc>"]], "expr")
    end,
  },

  -- vim-textobj-user
  -- TODO: Find nvim-treesitter replacement
  {
    "machakann/vim-textobj-functioncall",
    keys = {
      { "ad", mode = { "o", "x" }, desc = "around function call textobj" },
      { "id", mode = { "o", "x" }, desc = "inner function call textobj" },
    },
    dependencies = { "kana/vim-textobj-user" },
    config = function()
      vim.g.textobj_functioncall_no_default_key_mappings = 1

      xmap("id", "<Plug>(textobj-functioncall-i)")
      omap("id", "<Plug>(textobj-functioncall-i)")
      xmap("ad", "<Plug>(textobj-functioncall-a)")
      omap("ad", "<Plug>(textobj-functioncall-a)")
    end,
  },

  -- TODO: Find nvim-treesitter replacement
  {
    "glts/vim-textobj-comment",
    keys = {
      { "ao", mode = { "o", "x" }, desc = "around comment textobj" },
      { "io", mode = { "o", "x" }, desc = "inner comment textobj" },
      { "aO", mode = { "o", "x" }, desc = "around big comment textobj" },
    },
    dependencies = { "kana/vim-textobj-user" },
    config = function()
      vim.fn["textobj#user#plugin"]("comment", {
        ["-"] = {
          ["select-a-function"] = "textobj#comment#select_a",
          ["select-a"] = "ao",
          ["select-i-function"] = "textobj#comment#select_i",
          ["select-i"] = "io",
        },
        big = {
          ["select-a-function"] = "textobj#comment#select_big_a",
          ["select-a"] = "aO",
        },
      })
    end,
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    -- HACK: Load this first to allow other plugins to override the key mappings
    priority = 100,
    config = function()
      local various_textobjs = require("various-textobjs")

      -- TODO: Currently has key mapping conflicts:
      -- 1. nearEoL use `n` which is conflict with nvim-hlslens.
      -- 2. cssSelector use `ic`, `ac` which is conflict with nvim-treesitter-textobjects.
      various_textobjs.setup({
        useDefaultKeymaps = true,
        disabledKeymaps = {
          "an",
          "in",
          "r",
          "L",
          "gc",
        }
      })

      -- `aN` for outer number, `iN` for inner number
      vim.keymap.set({"o", "x"}, "aN", function() various_textobjs.number(false) end, { desc = "outer number textobj" })
      vim.keymap.set({"o", "x"}, "iN", function() various_textobjs.number(true) end, { desc = "inner number textobj" })

      -- restOfParagraph
      vim.keymap.set({"o", "x"}, "ir", function() various_textobjs.restOfParagraph() end, { desc = "restOfParagraph textobj" })

      -- url
      vim.keymap.set({"o", "x"}, "U", function() various_textobjs.url() end, { desc = "url textobj" })
    end,
  },
}

return text_objects
