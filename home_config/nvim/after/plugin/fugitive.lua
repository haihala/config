vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gd", ":Git diff<CR>")
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>")
vim.keymap.set("n", "<leader>ga", ":Gwrite<CR>")
vim.keymap.set("n", "<leader>gu", ":Gread<CR>") -- "Undo"
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>")
