-- Using fish is cool but for some reason doing it in vim makes everything very slow
vim.opt.shell = "/bin/bash"

-- Order here is important: keymaps first so leaders are defined before any plugin keymaps,
-- then plugins (vim.pack.add + setup), then settings/autocmds, then LSP.
require("config.keymaps")
require("config.plugins")
require("config.settings")
require("config.autocmds")

require("utils.lsp").setup()
