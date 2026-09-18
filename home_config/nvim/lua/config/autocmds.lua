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

-- Matches a markdown list marker: leading indent + bullet/number + a space.
-- Captures the full leader so we know where the item's text starts.
local function md_list_leader(line)
	return line:match("^%s*[-*+]%s+") or line:match("^%s*%d+[.)]%s+")
end

-- Automatically wrap lines when writing markdown.
-- Use `gwip` to manually reformat a paragraph
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.md" },
	callback = function(args)
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

		local opts = { buffer = args.buf, silent = true }

		-- <Tab>/<S-Tab> indent and dedent list items by 'shiftwidth'.
		-- Insert mode only acts while the cursor is still inside the list
		-- leader (indent + marker); past that you're writing prose, so a Tab
		-- stays a Tab. <C-t>/<C-d> are the built-in insert-mode shifts and
		-- keep the cursor where it is.
		local function in_leader()
			local line = vim.api.nvim_get_current_line()
			local leader = md_list_leader(line)
			if not leader then
				return false
			end
			return vim.fn.col(".") <= #leader + 1
		end

		vim.keymap.set("i", "<Tab>", function()
			return in_leader() and "<C-t>" or "<Tab>"
		end, vim.tbl_extend("force", opts, { expr = true }))

		vim.keymap.set("i", "<S-Tab>", function()
			return in_leader() and "<C-d>" or "<S-Tab>"
		end, vim.tbl_extend("force", opts, { expr = true }))

		-- Normal mode. Note this shadows <Tab>'s default jumplist-forward
		-- (<C-i>) in markdown buffers only; <C-i> itself still works.
		vim.keymap.set("n", "<Tab>", function()
			return md_list_leader(vim.api.nvim_get_current_line()) and ">>" or "<Tab>"
		end, vim.tbl_extend("force", opts, { expr = true }))

		vim.keymap.set("n", "<S-Tab>", function()
			return md_list_leader(vim.api.nvim_get_current_line()) and "<<" or "<S-Tab>"
		end, vim.tbl_extend("force", opts, { expr = true }))

		-- Visual mode shifts the whole selection and keeps it selected.
		vim.keymap.set("v", "<Tab>", ">gv", opts)
		vim.keymap.set("v", "<S-Tab>", "<gv", opts)
	end,
})

-- Use tabs instead of spaces in godot files, since godot defaults to tabs and you can't mix
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.gd" },
	callback = function()
		vim.opt.expandtab = false
	end,
})
