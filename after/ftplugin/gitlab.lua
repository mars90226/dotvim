local gitlab = require("vimrc.plugins.gitlab")

nnoremap("gm", function() gitlab.minimize_discussion() end, "<silent>", "<buffer>")
nnoremap("gr", function() gitlab.reset_discussion() end, "<silent>", "<buffer>")
