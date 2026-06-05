-- Grab-bag of small plugins that don't need a file each.

-- mini.surround: sa/sd/sr/etc
require("mini.surround").setup()

-- nvim-ts-autotag: auto-close/auto-rename HTML/JSX tags via treesitter
require("nvim-ts-autotag").setup()

-- vim-startify: greeter screen. No Lua setup; defaults are fine.

-- oil.nvim: file explorer
require("oil").setup()
vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>")

-- undotree: persistent undo + visual tree
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- vimtex: LaTeX support. Settings go through vim globals, must be set before
-- the plugin loads. With vim.pack's eager load, set them here regardless and
-- vimtex will pick them up via its own ftplugin path.
vim.g.vimtex_view_method = "zathura"

-- flash.nvim: motion+treesitter jump
require("flash").setup({
	-- Disables fFtT repeatable overrides
	modes = { char = { enabled = false } },
})
-- n - normal
-- x - visual mode
-- s - select mode (kinda weird version of visual mode)
-- v - visual and select modes
-- i - insert (also used in replace mode)
-- o - operator pending (Waiting motion, such as after d, c or y)
-- c - command line (/ or :)
vim.keymap.set({ "n", "x", "o" }, "<leader>j", function()
	require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "<leader>tn", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter node" })
vim.keymap.set("o", "r", function()
	require("flash").remote()
end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function()
	require("flash").toggle()
end, { desc = "Toggle Flash Search" })
