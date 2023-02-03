local symbols_outline = {}

symbols_outline.setup = function()
  require("symbols-outline").setup({
    -- NOTE: Should colortheme plugin fix the highlight?
    -- Ref: https://github.com/simrat39/symbols-outline.nvim/issues/185#issuecomment-1312618041
    symbols = {
      File = { hl = "@text.uri" },
      Module = { hl = "@namespace" },
      Namespace = { hl = "@namespace" },
      Package = { hl = "@namespace" },
      Class = { hl = "@type" },
      Method = { hl = "@method" },
      Property = { hl = "@method" },
      Field = { hl = "@field" },
      Constructor = { hl = "@constructor" },
      Enum = { hl = "@type" },
      Interface = { hl = "@type" },
      Function = { hl = "@function" },
      Variable = { hl = "@constant" },
      Constant = { hl = "@constant" },
      String = { hl = "@string" },
      Number = { hl = "@number" },
      Boolean = { hl = "@boolean" },
      Array = { hl = "@constant" },
      Object = { hl = "@type" },
      Key = { hl = "@type" },
      Null = { hl = "@type" },
      EnumMember = { hl = "@field" },
      Struct = { hl = "@type" },
      Event = { hl = "@type" },
      Operator = { hl = "@operator" },
      TypeParameter = { hl = "@parameter" },
    },
  })

  nnoremap("<F7>", [[<Cmd>SymbolsOutline<CR>]])
end

return symbols_outline
