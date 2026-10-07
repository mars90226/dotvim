local Flash = require("flash")

local flash = {}

---@param opts Flash.Format
local function format(opts)
  -- always show first and second label
  return {
    { opts.match.label1, "FlashMatch" },
    { opts.match.label2, "FlashLabel" },
  }
end

flash.jump_word = function()
  -- Ref: https://github.com/folke/flash.nvim
  Flash.jump({
    search = { mode = "search" },
    label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
    pattern = [[\<]],
    action = function(match, state)
      state:hide()
      Flash.jump({
        search = { max_length = 0 },
        highlight = { matches = false },
        label = { format = format },
        matcher = function(win)
          -- limit matches to the current label
          return vim.tbl_filter(function(m)
            return not m.fold and m.label == match.label and m.win == win
          end, state.results)
        end,
        labeler = function(matches)
          for _, m in ipairs(matches) do
            m.label = m.label2 -- use the second label
          end
        end,
      })
    end,
    labeler = function(matches, state)
      local labels = state:labels()
      local m = 0
      for _, match in ipairs(matches) do
        -- Folded words share one screen position, so do not assign them labels.
        match.label = false
        match.label1 = nil
        match.label2 = nil
        if not match.fold then
          m = m + 1
          match.label1 = labels[math.floor((m - 1) / #labels) + 1]
          match.label2 = labels[(m - 1) % #labels + 1]
          match.label = match.label1
        end
      end
    end,
  })
end

return flash
