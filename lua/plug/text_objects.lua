local text_objects = {}

text_objects.startup = function(use)
  use({
    "wellle/targets.vim",
    config = function()
      -- Reach targets
      nmap("]r", [['vin'.vimrc#getchar_string()."o\<Esc>"]], "expr")
      nmap("[r", [['vil'.vimrc#getchar_string()."\<Esc>"]], "expr")
      nmap("]R", [['van'.vimrc#getchar_string()."o\<Esc>"]], "expr")
      nmap("[R", [['val'.vimrc#getchar_string()."\<Esc>"]], "expr")
    end,
  })

  use({
    "kana/vim-textobj-user",
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/textobj_user.vim")
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
