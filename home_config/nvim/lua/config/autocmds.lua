-- LSP attach
local Lsp = require("utils.lsp")

vim.api.nvim_create_autocmd("LspAttach", {
	callback = Lsp.on_attach,
})

-- Unobvious file types
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "Jenkinsfile" },
	command = ":set filetype=groovy",
})
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.tf" },
	command = ":set filetype=terraform",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.wgsl" },
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})

-- Automatically wrap lines when writing markdown.
-- Use `gwip` to manually reformat a paragraph
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.md" },
	callback = function()
		vim.opt.textwidth = 80
		-- Marksman uses two spaces tabs by default
		vim.opt.tabstop = 2
		vim.opt.softtabstop = 2
		vim.opt.shiftwidth = 2
		vim.opt.expandtab = true
	end,
})

-- Use tabs instead of spaces in godot files, since godot defaults to tabs and you can't mix
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.gd" },
	callback = function()
		vim.opt.expandtab = false
	end,
})
