-- Treesitter integration: built-in vim.treesitter does the runtime work
-- (highlight, folds, incremental selection); nvim-treesitter's `main` branch
-- is used purely as a parser/query installer.

-- Custom filetype detection that needs to happen before highlight kicks in
vim.filetype.add({ extension = { wgsl = "wgsl" } })

-- Parser & query installation
local nts = require("nvim-treesitter")
nts.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

local ensure_installed = {
	"javascript",
	"typescript",
	"python",
	"rust",
	"c",
	"lua",
	"vim",
	"vimdoc",
	"query",
}
-- Async; safe to fire-and-forget at startup. Already-installed parsers are no-ops.
nts.install(ensure_installed)

-- Enable highlight + folds + indent on every buffer whose filetype has a parser.
-- Incremental selection is built-in in 0.12 (see v_an / v_in / v_]n / v_[n).
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf = args.buf
		local ft = vim.bo[buf].filetype
		local lang = vim.treesitter.language.get_lang(ft) or ft
		if not pcall(vim.treesitter.start, buf, lang) then
			return
		end
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
		-- nvim-treesitter (main) ships an experimental indent expression
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- Inspect the tree at cursor
vim.keymap.set("n", "<leader>ti", ":InspectTree<CR>")

-- ──────────────────────────────────────────────────────────────────────────
-- nvim-treesitter-textobjects (main branch)
-- ──────────────────────────────────────────────────────────────────────────

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
	},
	move = {
		set_jumps = true,
	},
})

local select = require("nvim-treesitter-textobjects.select")
local swap = require("nvim-treesitter-textobjects.swap")
local move = require("nvim-treesitter-textobjects.move")
local repeatable = require("nvim-treesitter-textobjects.repeatable_move")

-- Selects: af/if, at/it, al/il, aa/ia/la/ra, ab/ib
local select_map = {
	["af"] = "@function.outer",
	["if"] = "@function.inner",
	["at"] = "@class.outer",
	["it"] = "@class.inner",
	["al"] = "@loop.outer",
	["il"] = "@loop.inner",
	["aa"] = "@assignment.outer",
	["ia"] = "@assignment.inner",
	["la"] = "@assignment.lhs",
	["ra"] = "@assignment.rhs",
	["ab"] = "@block.outer",
	["ib"] = "@block.inner",
}
for lhs, query in pairs(select_map) do
	vim.keymap.set({ "x", "o" }, lhs, function()
		select.select_textobject(query, "textobjects")
	end)
end

-- Swaps
vim.keymap.set("n", "<leader>sp", function()
	swap.swap_next("@parameter.inner")
end)
vim.keymap.set("n", "<leader>sP", function()
	swap.swap_previous("@parameter.inner")
end)

-- Movements (next/prev start). For each entry, queries can be a string or
-- a list; lists are how the new API replaces the old `@loop.*` wildcard.
local goto_next_start_map = {
	["]f"] = "@function.outer",
	["]t"] = "@class.outer", -- T for type
	["]l"] = { "@loop.inner", "@loop.outer" },
	["]a"] = "@assignment.outer",
	["]b"] = "@block.outer",
	["]p"] = "@parameter.inner",
	["]aa"] = "@assignment.outer",
	["]ia"] = "@assignment.inner",
	["]la"] = "@assignment.lhs",
	["]ra"] = "@assignment.rhs",
}
local goto_previous_start_map = {
	["[f"] = "@function.outer",
	["[t"] = "@class.outer",
	["[l"] = { "@loop.inner", "@loop.outer" },
	["[a"] = "@assignment.outer",
	["[b"] = "@block.outer",
	["[p"] = "@parameter.inner",
	["[aa"] = "@assignment.outer",
	["[ia"] = "@assignment.inner",
	["[la"] = "@assignment.lhs",
	["[ra"] = "@assignment.rhs",
}
for lhs, query in pairs(goto_next_start_map) do
	vim.keymap.set({ "n", "x", "o" }, lhs, function()
		move.goto_next_start(query, "textobjects")
	end)
end
for lhs, query in pairs(goto_previous_start_map) do
	vim.keymap.set({ "n", "x", "o" }, lhs, function()
		move.goto_previous_start(query, "textobjects")
	end)
end

-- "Go to either start or end, whichever is closer" for conditionals
vim.keymap.set({ "n", "x", "o" }, "]c", function()
	move.goto_next("@conditional.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[c", function()
	move.goto_previous("@conditional.outer", "textobjects")
end)

-- Repeat last move with ; and , (always forward / always backward)
vim.keymap.set({ "n", "x", "o" }, ";", repeatable.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", repeatable.repeat_last_move_previous)
