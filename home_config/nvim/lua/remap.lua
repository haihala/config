vim.g.mapleader = " "

-- File Explorer
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)

-- Move through search terms in a way where they remain at the center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste over text without losing p buffer
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Explicitly copy to system clipboard with leader + y
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Paste from system clipboard
vim.keymap.set("i", "<C-v>", "<C-p>+")

-- Line shimmy (Work funny in normal mode so don't bother for now)
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")


-- Go back
vim.keymap.set("n", "gb", ":e#<CR>")

-- Movement between panes
vim.keymap.set("n", "<A-h>", "<C-w>h")
vim.keymap.set("n", "<A-j>", "<C-w>j")
vim.keymap.set("n", "<A-k>", "<C-w>k")
vim.keymap.set("n", "<A-l>", "<C-w>l")

-- Movement of panes
vim.keymap.set("n", "<A-H>", "<C-w>H")
vim.keymap.set("n", "<A-J>", "<C-w>J")
vim.keymap.set("n", "<A-K>", "<C-w>K")
vim.keymap.set("n", "<A-L>", "<C-w>L")

-- Execute current file
vim.keymap.set("n", "<leader>e", ":!%:p<CR>")

-- TODO: Pane resizing
-- TODO: Reload
-- TODO: Import ordering
-- TODO: Git diff and change jumps
