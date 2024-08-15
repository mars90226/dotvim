local utils = require("vimrc.utils")

local other = {}

local function generate_table(template)
  local result = {}

  for _, config in pairs(template) do
    local levels = config.level
    local mappings = config.mappings

    for _, level in ipairs(levels) do
      for _, mapping in ipairs(mappings) do
        local new_mapping = {}

        -- Process pattern
        new_mapping.pattern = mapping.pattern:gsub("%%s", "(.*)", 1) -- Replace first %s with (.*)
        new_mapping.pattern = new_mapping.pattern:gsub("%%s", ("(.*)/"):rep(level - 1):sub(1, -2)) -- Replace remaining %s with (.*)/ and remove the last /

        -- Process target
        local function process_target(target)
          local new_target = target:gsub("%%s", "%%1", 1) -- Replace first %s with %1
          return new_target:gsub("%%s", function() -- Replace remaining %s with %2, %3, ...
            local captures = {}
            for i = 2, level do
              table.insert(captures, "%" .. i)
            end
            return table.concat(captures, "/")
          end)
        end

        if type(mapping.target) == "table" then
          new_mapping.target = {}
          for _, t in ipairs(mapping.target) do
            table.insert(new_mapping.target, {
              target = process_target(t.target),
            })
          end
        else
          new_mapping.target = process_target(mapping.target)
        end

        table.insert(result, new_mapping)
      end
    end
  end

  return result
end

other.generate_mappings = function()
  -- TODO: Handle 1 level cases
  local mappings_template = {
    -- C/C++
    -- src-lib folder
    ["src-lib"] = {
      level = { 2, 3, 4 },
      mappings = {
        {
          pattern = [[/src/include/%s/%s.h$]],
          target = {
            {
              target = [[/src/%s/lib/%s.cpp]],
            },
            {
              target = [[/src/%s/lib/%s.c]],
            },
          },
        },
        {
          pattern = [[/src/%s/lib/%s.cpp$]],
          target = [[/src/include/%s/%s.h]],
        },
        {
          pattern = [[/src/%s/lib/%s.c$]],
          target = [[/src/include/%s/%s.h]],
        },
      },
    },
    ["lib"] = {
      level = { 2, 3, 4 },
      mappings = {
        {
          pattern = [[/include/%s/%s.h$]],
          target = {
            {
              target = [[/%s/lib/%s.cpp]],
            },
            {
              target = [[/%s/lib/%s.c]],
            },
          },
        },
        {
          pattern = [[/%s/lib/%s.cpp$]],
          target = [[/include/%s/%s.h]],
        },
        {
          pattern = [[/%s/lib/%s.c$]],
          target = [[/include/%s/%s.h]],
        },
      },
    },
    ["raw"] = {
      level = { 2, 3, 4 },
      mappings = {
        {
          pattern = [[/include/%s/%s.h$]],
          target = {
            {
              target = [[/%s/%s.cpp]],
            },
            {
              target = [[/%s/%s.c]],
            },
          },
        },
        {
          pattern = [[/%s/%s.cpp$]],
          target = [[/include/%s/%s.h]],
        },
        {
          pattern = [[/%s/%s.c$]],
          target = [[/include/%s/%s.h]],
        },
      },
    },
    ["src-core"] = {
      level = { 2, 3, 4 },
      mappings = {
        {
          pattern = [[/src/include/%s/%s.h$]],
          target = {
            {
              target = [[/src/core/%s/%s.cpp]],
            },
            {
              target = [[/src/core/%s/%s.c]],
            },
          },
        },
        {
          pattern = [[/src/core/%s/%s.cpp$]],
          target = [[/src/include/%s/%s.h]],
        },
        {
          pattern = [[/src/core/%s/%s.c$]],
          target = [[/src/include/%s/%s.h]],
        },
      },
    },
    ["src-lib-prefix"] = {
      level = { 2, 3, 4 },
      mappings = {
        {
          pattern = [[/src/include/.*/%s/%s.h$]],
          target = {
            {
              target = [[/src/lib-%s/%s.cpp]],
            },
            {
              target = [[/src/lib-%s/%s.c]],
            },
          },
        },
        {
          pattern = [[/src/lib%-%s/%s.cpp$]],
          target = [[/src/include/*/%s/%s.h]],
        },
        {
          pattern = [[/src/core/%s/%s.c$]],
          target = [[/src/include/*/%s/%s.h]],
        },
      },
    },
  }

  return generate_table(mappings_template)
end

other.setup = function()
  local generated_mappings = other.generate_mappings()

  require("other-nvim").setup({
    mappings = utils.table_concat({
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
    }, generated_mappings),
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
