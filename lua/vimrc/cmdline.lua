local cmdline = {}

cmdline.delete_subword = function()
  local cmd = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos() - 1 -- getcmdpos() is cursor position, and may be larger than cmd
  local remaining = cmd:sub(pos + 1)
  local meet_non_sep = false

  local is_sep = function(char)
    return vim.tbl_contains({ " ", "-", "_" }, char) or string.match(char, "%u") ~= nil
  end

  for index = pos, 1, -1 do
    local char = cmd:sub(index, index)
    local char_is_sep = is_sep(char)
    vim.pretty_print("index: ", index, ", char: ", char, ", char_is_sep: ", char_is_sep)

    if not char_is_sep then
      meet_non_sep = true
    end

    if is_sep(char) and meet_non_sep then
      vim.fn.setcmdpos(index + 2)
      return cmd:sub(1, index - 1) .. remaining
    end
  end
  vim.fn.setcmdpos(1)
  return remaining
end

return cmdline
