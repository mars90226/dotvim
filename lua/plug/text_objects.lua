local text_objects = {}

text_objects.setup_text_objects = function()
  -- ie = inner entire buffer
  onoremap("ie", ':exec "normal! ggVG"<CR>')
  xnoremap("ie", ':<C-U>exec "normal! ggVG"<CR>')

  -- iV = current viewable text in the buffer
  onoremap("iV", ':exec "normal! HVL"<CR>')
  xnoremap("iV", ':<C-U>exec "normal! HVL"<CR>')
end

text_objects.startup = function(use)
  text_objects.setup_text_objects()

  use({
    "wellle/targets.vim",
    config = function()
      -- Reach targets
      -- TODO: Other input method to avoid cursor moving?
      nmap("]r", [['vin'.v:lua.require("vimrc.utils").get_char_string()."o\<Esc>"]], "expr")
      nmap("[r", [['vil'.v:lua.require("vimrc.utils").get_char_string()."\<Esc>"]], "expr")
      nmap("]R", [['van'.v:lua.require("vimrc.utils").get_char_string()."o\<Esc>"]], "expr")
      nmap("[R", [['val'.v:lua.require("vimrc.utils").get_char_string()."\<Esc>"]], "expr")
    end,
  })

  use({
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
  })
  use({
    "kana/vim-textobj-function",
    config = function()
      -- Search in function
      map("<Space>sF", "vaf<M-/>")
    end,
  })

  use({
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
  })

  -- Should already be bundled in vim-sandwich, but not work
  -- So, explicitly install this plugin
  use({
    "machakann/vim-textobj-functioncall",
    config = function()
      vim.g.textobj_functioncall_no_default_key_mappings = 1

      xmap("id", "<Plug>(textobj-functioncall-i)")
      omap("id", "<Plug>(textobj-functioncall-i)")
      xmap("ad", "<Plug>(textobj-functioncall-a)")
      omap("ad", "<Plug>(textobj-functioncall-a)")
    end,
  })

  use("michaeljsmith/vim-indent-object")
  use("glts/vim-textobj-comment")
end

return text_objects
