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
		vim.opt_local.textwidth = 80
		-- Marksman uses two spaces tabs by default
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true

		-- Continue bullet lists on <CR> (r) and o/O (o).
		-- $VIMRUNTIME/ftplugin/markdown.vim strips r/o and sets `fb:` comment
		-- flags, and it runs after our FileType autocmds. BufEnter/BufWinEnter
		-- fire after FileType, so undo its damage here.
		vim.opt_local.formatoptions:append("r")
		vim.opt_local.formatoptions:append("o")
		-- `b:` (not `fb:`) so the leader repeats on every line, not just the first
		vim.opt_local.comments = "b:*,b:-,b:+,n:>"
	end,
})

-- Use tabs instead of spaces in godot files, since godot defaults to tabs and you can't mix
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.gd" },
	callback = function()
		vim.opt.expandtab = false
	end,
})
