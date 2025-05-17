-- Using fish is cool but for some reason doing it in vim makes everything very slow
vim.opt.shell = "/bin/bash"

-- Order here is important
require("config.keymaps")
require("config.lazy")
require("config.settings")
require("config.autocmds")

local lsp_conf = require("utils.lsp")

lsp_conf.setup()
