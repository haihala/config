-- vim-tmux-navigator: no Lua setup, just keymaps
vim.keymap.set("n", "<A-h>", ":TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<A-j>", ":TmuxNavigateDown<CR>")
vim.keymap.set("n", "<A-k>", ":TmuxNavigateUp<CR>")
vim.keymap.set("n", "<A-l>", ":TmuxNavigateRight<CR>")

-- Alternative (Zellij). Uncomment plugin in config/plugins.lua and swap keymaps above:
-- vim.keymap.set("n", "<A-h>", "<cmd>ZellijNavigateLeftTab<cr>",  { silent = true })
-- vim.keymap.set("n", "<A-j>", "<cmd>ZellijNavigateDown<cr>",     { silent = true })
-- vim.keymap.set("n", "<A-k>", "<cmd>ZellijNavigateUp<cr>",       { silent = true })
-- vim.keymap.set("n", "<A-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true })
