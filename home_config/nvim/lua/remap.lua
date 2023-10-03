vim.g.mapleader = " "

-- File Browser (telescope uses fe for it's file explorer)
vim.keymap.set("n", "<leader>fb", vim.cmd.Ex)

-- Move through search terms in a way where they remain at the center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste over text without losing p buffer
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Copy to system clipboard with leader + y in visual mode
vim.keymap.set("v", "<leader>y", "\"+y")
-- Copy the buffer path to system clipboard
vim.keymap.set("n", "<leader>Y", ":let @+=@%<CR>")

-- Paste from system clipboard
vim.keymap.set("i", "<C-v>", "<C-p>+")

-- Line shimmy (Work funny in normal mode so don't bother for now)
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")

-- Jumps
vim.keymap.set("n", "<leader>jp", "``") -- to Previous jump
vim.keymap.set("n", "<leader>jf", "gf") -- to File
vim.keymap.set("n", "gf", "<Nop>")      -- to File

-- Execute current file
vim.keymap.set("n", "<leader>e", ":!%:p<CR>")

-- TODO: Pane resizing
-- TODO: Reload
-- TODO: Import ordering
-- TODO: Git diff and change jumps
