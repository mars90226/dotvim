local gitlab = require("vimrc.plugins.gitlab")

nnoremap("gm", function() gitlab.minimize_discussion() end, { silent = true, buffer = true, desc = "Minimize Gitlab.nvim discussion panel width" })
nnoremap("gr", function() gitlab.reset_discussion() end, { silent = true, buffer = true, desc = "Reset Gitlab.nvim discussion panel width" })
