local mason = {}

mason.get_lsp_realpath = function(lsp)
 return vim.uv.fs_realpath(vim.fn.exepath(lsp))
end

mason.get_lsp_project_path = function(lsp)
  local lsp_path = mason.get_lsp_realpath(lsp)
  local lsp_folder = vim.fs.dirname(lsp_path)
  -- Check if the lsp folder is end with "/bin"
  if lsp_folder:sub(-4) == "/bin" then
    return vim.fs.dirname(lsp_folder)
  end
  return lsp_folder
end

return mason
