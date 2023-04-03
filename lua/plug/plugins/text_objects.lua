local text_objects = {
  {
    "wellle/targets.vim",
    config = function()
      -- Reach targets
      -- TODO: Other input method to avoid cursor moving?
      nmap("]r", [['vin'.v:lua.require("vimrc.utils").get_char_string()."o\<Esc>"]], "expr")
      nmap("[r", [['vil'.v:lua.require("vimrc.utils").get_char_string()."\<Esc>"]], "expr")
      nmap("]R", [['van'.v:lua.require("vimrc.utils").get_char_string()."o\<Esc>"]], "expr")
      nmap("[R", [['val'.v:lua.require("vimrc.utils").get_char_string()."\<Esc>"]], "expr")
    end,
  },

  {
    "kana/vim-textobj-user",
    config = function()
      -- FIXME Not working
      -- vim.fn["textobj#user#plugin"]("surroundunicode", {
      --   surroundunicode = {
      --     pattern = { "[^\x00-\x7F]", "[^\x00-\x7F]" },
      --     ["select-a"] = "au",
      --     ["select-i"] = "iu",
      --   },
      -- })

      vim.fn["textobj#user#plugin"]("comment", {
        ["-"] = {
          ["select-a-function"] = "textobj#comment#select_a",
          ["select-a"] = "am",
          ["select-i-function"] = "textobj#comment#select_i",
          ["select-i"] = "im",
        },
        big = {
          ["select-a-function"] = "textobj#comment#select_big_a",
          ["select-a"] = "aM",
        },
      })
    end,
  },
  {
    "kana/vim-textobj-function",
    dependencies = { "kana/vim-textobj-user" },
    config = function()
      -- Search in function
      map("<Space>sF", "vaf<M-/>")
    end,
  },

  {
    "coderifous/textobj-word-column.vim",
    config = function()
      vim.g.skip_default_textobj_word_column_mappings = 1

      xnoremap("au", ':<C-u>call TextObjWordBasedColumn("aw")<cr>', "silent")
      xnoremap("aU", ':<C-u>call TextObjWordBasedColumn("aW")<cr>', "silent")
      xnoremap("iu", ':<C-u>call TextObjWordBasedColumn("iw")<cr>', "silent")
      xnoremap("iU", ':<C-u>call TextObjWordBasedColumn("iW")<cr>', "silent")
      onoremap("au", ':call TextObjWordBasedColumn("aw")<cr>', "silent")
      onoremap("aU", ':call TextObjWordBasedColumn("aW")<cr>', "silent")
      onoremap("iu", ':call TextObjWordBasedColumn("iw")<cr>', "silent")
      onoremap("iU", ':call TextObjWordBasedColumn("iW")<cr>', "silent")
    end,
  },

  -- Should already be bundled in vim-sandwich, but not work
  -- So, explicitly install this plugin
  {
    "machakann/vim-textobj-functioncall",
    dependencies = { "kana/vim-textobj-user" },
    config = function()
      vim.g.textobj_functioncall_no_default_key_mappings = 1

      xmap("id", "<Plug>(textobj-functioncall-i)")
      omap("id", "<Plug>(textobj-functioncall-i)")
      xmap("ad", "<Plug>(textobj-functioncall-a)")
      omap("ad", "<Plug>(textobj-functioncall-a)")
    end,
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    config = function()
      -- TODO: Currently has key mapping conflicts:
      -- 1. nearEoL use `n` which is conflict with nvim-hlslens.
      -- 2. cssSelector use `ic`, `ac` which is conflict with nvim-treesitter-textobjects.
      require("various-textobjs").setup({ useDefaultKeymaps = true })

      -- `aN` for outer number, `iN` for inner number
      vim.keymap.del({"o", "x"}, "an")
      vim.keymap.del({"o", "x"}, "in")
      vim.keymap.set({"o", "x"}, "aN", function () require("various-textobjs").number(false) end, { desc = "outer number textobj"})
      vim.keymap.set({"o", "x"}, "iN", function () require("various-textobjs").number(true) end, { desc = "inner number textobj"})

      -- restOfParagraph
      vim.keymap.del({"o", "x"}, "r")
      vim.keymap.set({"o", "x"}, "ir", function () require("various-textobjs").restOfParagraph() end, { desc = "restOfParagraph textobj"})

      -- url
      vim.keymap.del({"o", "x"}, "L")
      vim.keymap.set({"o", "x"}, "U", function () require("various-textobjs").url() end, { desc = "url textobj"})

      -- toNextClosingBracket
      vim.keymap.del({"o", "x"}, "%")
      vim.keymap.set({"o", "x"}, "]b", function () require("various-textobjs").toNextClosingBracket() end, { desc = "toNextClosingBracket textobj"})
    end,
  },

  {
    "glts/vim-textobj-comment",
    dependencies = { "kana/vim-textobj-user" },
  },
}

return text_objects
