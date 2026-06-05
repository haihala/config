require("grapple").setup({
	scope = "git", -- also try out "git_branch"
})

vim.keymap.set("n", "<leader>m", "<cmd>Grapple toggle<cr>", { desc = "Grapple toggle tag" })
vim.keymap.set("n", "<leader>M", "<cmd>Grapple toggle_tags<cr>", { desc = "Grapple open tags window" })
for i = 1, 9 do
	vim.keymap.set("n", "<A-" .. i .. ">", "<cmd>Grapple select index=" .. i .. "<cr>")
end
