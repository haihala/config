vim.g.mapleader = " "

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

-- Clear search highlights
vim.keymap.set("n", "<leader>n", ":noh<CR>")

-- Quick split operations
vim.keymap.set("n", "<a-q>", "<c-w>q")
vim.keymap.set("n", "<a-->", "<c-w>s")
vim.keymap.set("n", "<a-|>", "<c-w>v")

-- Line shimmy (Work funny in normal mode so don't bother for now)
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")

-- Execute current file
vim.keymap.set("n", "<leader>e", ":!%:p<CR>")

-- Snippets
-- Inserts an ISO timestamp after the current character
local function timestamp(flags)
    return "a<c-r>=trim(system('date " .. flags .. "'))<CR><Esc>"
end
vim.keymap.set("n", "<leader>sti", timestamp("-Im"))    -- ISO
vim.keymap.set("n", "<leader>std", timestamp("-Idate")) -- Date
vim.keymap.set("n", "<leader>stt", timestamp("+%T"))    -- Time
vim.keymap.set("n", "<leader>stm", timestamp("+%I:%m")) -- Time (minutes)

-- While not a remap, I'm putting this here
vim.api.nvim_create_user_command("Upgrade", function()
    -- The order here doesn't seem to matter
    vim.cmd(":MasonUpdate") -- This may not work correctly
    vim.cmd(":TSUpdate")
    vim.cmd(":PackerSync")
end, {})

-- TODO: Pane resizing
-- TODO: Reload
