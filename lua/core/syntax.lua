local syntax = {}

syntax.setup = function()
  -- syntax
  -- Check if syntax is on and only switch on syntax when it's off
  -- due to git-p preview loses highlight after `:syntax on`
  -- TODO: Check if this is needed, because we're using treesitter
  if not vim.g.syntax_on then
    vim.cmd([[syntax on]])
  end

  -- lowering the value to improve performance on long line
  -- TODO: Remove this or check it in autocmd as it's buffer local option
  vim.o.synmaxcol = 1500 -- default: 3000, 0: unlimited

  if not vim.g.loaded_color then
    vim.g.loaded_color = 1

    vim.go.background = "dark"

    if not vim.g.gui_oni then
      if vim.g.colorscheme then
        vim.cmd("colorscheme " .. vim.g.colorscheme)
      end
    end
  end

  -- TODO: Need to test in Windows
  vim.go.termguicolors = true

  -- highlighting strings inside C comments.
  -- TODO: No way to set vim local variable in Lua?
  vim.cmd([[let c_comment_strings = 1]])
end

return syntax
