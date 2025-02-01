local M = {}

--- Check if the character immediately before the cursor is whitespace.
--- @return boolean True if the cursor is at the beginning of the line or the previous character is whitespace.
function M.check_backspace()
  local col = vim.fn.col('.') - 1
  if col == 0 then
    return true
  end
  local line = vim.fn.getline('.')
  -- In VimScript, string indexing is 0-based; in Lua it’s 1-based.
  -- The previous character (at Vim index col-1) is at Lua index (col-1)+1 = col.
  local prev_char = line:sub(col, col)
  return prev_char:match("%s") ~= nil
end

--- Trim the current command-line input to a specified length.
--- Prompts the user for the desired length and returns the trimmed command-line.
--- @return string The trimmed command-line string.
function M.trim_cmdline()
  local length = tonumber(vim.fn.input("length: ", "", "expression"))
  local cmd = vim.fn.getcmdline()
  -- In VimScript, slicing [0 : length - 1] corresponds to Lua's substring from 1 to length.
  return cmd:sub(1, length)
end

--- Delete the whole word in the command-line before the cursor.
--- This function deletes characters from the command-line up to the previous space
--- that follows a non-space character and adjusts the command-line cursor position.
--- @return string The modified command-line string after deletion.
function M.delete_whole_word()
  local cmd = vim.fn.getcmdline()
  -- getcmdpos() returns a 1-based position; subtract 1 to work in 0-based indexing (like VimScript).
  local pos = vim.fn.getcmdpos() - 1
  local meet_non_space = false

  -- Iterate backwards from (pos - 2) to 0.
  for i = pos - 2, 0, -1 do
    -- Convert 0-based index to Lua's 1-based index.
    local ch = cmd:sub(i + 1, i + 1)
    if ch ~= " " then
      meet_non_space = true
    end

    if ch == " " and meet_non_space then
      -- setcmdpos() expects a 1-based position.
      vim.fn.setcmdpos(i + 2)
      -- VimScript's cmd[0:i] corresponds to Lua's substring from 1 to i+1.
      -- Similarly, cmd[pos:] corresponds to Lua's substring from pos+1 to the end.
      return cmd:sub(1, i + 1) .. cmd:sub(pos + 1)
    end
  end

  vim.fn.setcmdpos(1)
  return cmd:sub(pos + 1)
end

return M
