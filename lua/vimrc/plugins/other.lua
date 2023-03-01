local other = {}

other.setup = function()
  require("other-nvim").setup({
    mappings = {
      -- builtin mappings
      -- "livewire",
      -- "angular",
      -- "laravel",
      -- "rails",

      -- custom mapping
      -- TODO: Simplify the pattern
      -- Same folder
      {
        pattern = [[/(.*).h$]],
        target = {
          {
            target = [[/%1.cpp]],
          },
          {
            target = [[/%1.c]],
          },
        },
      },
      {
        pattern = [[/(.*).cpp$]],
        target = [[/%1.h]],
      },
      {
        pattern = [[/(.*).c$]],
        target = [[/%1.h]],
      },
      -- 3-level folder
      {
        pattern = [[/src/include/(.*)/(.*)/(.*).h$]],
        target = {
          {
            target = [[/src/%1/lib/%2/%3.cpp]],
          },
          {
            target = [[/src/%1/lib/%2/%3.c]],
          },
        },
      },
      {
        pattern = [[/src/(.*)/lib/(.*)/(.*).cpp$]],
        target = [[/src/include/%1/%2/%3.h]],
      },
      {
        pattern = [[/src/(.*)/lib/(.*)/(.*).c$]],
        target = [[/src/include/%1/%2/%3.h]],
      },
      -- 3-level no src folder
      {
        pattern = [[/include/(.*)/(.*)/(.*).h$]],
        target = {
          {
            target = [[/%1/lib/%2/%3.cpp]],
          },
          {
            target = [[/%1/lib/%2/%3.c]],
          },
        },
      },
      {
        pattern = [[/(.*)/lib/(.*)/(.*).cpp$]],
        target = [[/include/%1/%2/%3.h]],
      },
      {
        pattern = [[/(.*)/lib/(.*)/(.*).c$]],
        target = [[/include/%1/%2/%3.h]],
      },
      -- 3-level no lib folder
      {
        pattern = [[/src/include/(.*)/(.*)/(.*).h$]],
        target = {
          {
            target = [[/src/%1/%2/%3.cpp]],
          },
          {
            target = [[/src/%1/%2/%3.c]],
          },
        },
      },
      {
        pattern = [[/src/(.*)/(.*)/(.*).cpp$]],
        target = [[/src/include/%1/%2/%3.h]],
      },
      {
        pattern = [[/src/(.*)/(.*)/(.*).c$]],
        target = [[/src/include/%1/%2/%3.h]],
      },
      -- 2-level folder
      {
        pattern = [[/src/include/.*/(.*)/(.*).h$]],
        target = {
          {
            target = [[/src/lib/%1/%2.cpp]],
          },
          {
            target = [[/src/lib/%1/%2.c]],
          },
        },
      },
      {
        pattern = [[/src/lib/(.*)/(.*).cpp$]],
        target = [[/src/include/*/%1/%2.h]],
      },
      {
        pattern = [[/src/lib/(.*)/(.*).c$]],
        target = [[/src/include/*/%1/%2.h]],
      },
      -- 1-level folder
      {
        pattern = [[/include/.*/(.*).h$]],
        target = {
          {
            target = [[/lib/%1.cpp]],
          },
          {
            target = [[/lib/%1.c]],
          },
        },
      },
      {
        pattern = [[/lib/(.*).cpp$]],
        target = [[/include/*/%1.h]],
      },
      {
        pattern = [[/lib/(.*).c$]],
        target = [[/include/*/%1.h]],
      },
      -- 2-level lib prefix folder
      {
        pattern = [[/src/include/.*/(.*)/(.*).h$]],
        target = {
          {
            target = [[/src/lib-%1/%2.cpp]],
          },
          {
            target = [[/src/lib-%1/%2.c]],
          },
        },
      },
      {
        pattern = [[/src/lib%-(.*)/(.*).cpp$]],
        target = [[/src/include/*/%1/%2.h]],
      },
      {
        pattern = [[/src/lib%-(.*)/(.*).c$]],
        target = [[/src/include/*/%1/%2.h]],
      },
      -- 2-level no src folder
      {
        pattern = [[/include/(.*)/(.*).h$]],
        target = {
          {
            target = [[/%1/%2.cpp]],
          },
          {
            target = [[/%1/%2.c]],
          },
        },
      },
      {
        pattern = [[/(.*)/(.*).cpp$]],
        target = [[/include/*/%1/%2.h]],
      },
      {
        pattern = [[/(.*)/(.*).c$]],
        target = [[/include/*/%1/%2.h]],
      },
    },
    transformers = {
      -- defining a custom transformer
      lowercase = function(inputString)
        return inputString:lower()
      end,
    },
  })

  nnoremap("<Leader>oo", "<Cmd>:Other<CR>", "silent")
  nnoremap("<Leader>os", "<Cmd>:OtherSplit<CR>", "silent")
  nnoremap("<Leader>ov", "<Cmd>:OtherVSplit<CR>", "silent")
  nnoremap("<Leader>oc", "<Cmd>:OtherClear<CR>", "silent")
end

return other
