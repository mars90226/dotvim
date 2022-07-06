local fine_cmdline = {}

fine_cmdline.related_bufnr = 0

fine_cmdline.get_related_bufnr = function()
  return fine_cmdline.related_bufnr
end

fine_cmdline.set_related_bufnr = function(related_bufnr)
  fine_cmdline.related_bufnr = related_bufnr
end

return fine_cmdline
