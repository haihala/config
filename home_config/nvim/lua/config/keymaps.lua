vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Move through search terms in a way where they remain at the center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste over text without losing p buffer
vim.keymap.set("x", "<leader>p", '"_dP')

-- Copy to system clipboard with leader + y in visual mode
vim.keymap.set("v", "<leader>y", '"+y')
-- Copy the buffer path to system clipboard
vim.keymap.set("n", "<leader>Y", ":let @+=@%<CR>")

-- Paste from system clipboard
vim.keymap.set("i", "<C-v>", "<C-p>+")

-- Clear search highlights
vim.keymap.set("n", "<leader>n", ":noh<CR>")

-- Save without formating
vim.keymap.set("n", "<leader>w", ":noa w<CR>")

-- Search for selected text
-- Yoink highlighted text to s register, search for it
vim.keymap.set("v", "<leader>/", '"sy/<C-r>s')

-- Quick split operations
vim.keymap.set("n", "<a-q>", "<c-w>q")
vim.keymap.set("n", "<a-->", "<c-w>s")
vim.keymap.set("n", "<a-|>", "<c-w>v")

-- Line shimmy (Work funny in normal mode so don't bother for now)
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")

-- Exec/Eval
vim.keymap.set("n", "<leader>ef", ":!%:p<CR>") -- File (like a script)
vim.keymap.set("n", "<leader>es", ":so %<CR>") -- Source (in vim)
vim.keymap.set("n", "<leader>ec", "Vc<c-r>=trim(system('calc <c-r>\"'))<CR><Esc>") -- Calc math expression (line)
vim.keymap.set("v", "<leader>ec", "c<c-r>=trim(system('calc <c-r>\"'))<CR><Esc>") -- Calc math expression (selection)

-- Timestamp Snippets
local function timestamp(flags)
	-- Inserts an ISO timestamp after the current character
	return "a<c-r>=trim(system('date " .. flags .. "'))<CR><Esc>"
end
-- BSD date (macOS) has no -I, so build the ISO strings with strftime
local function iso_timestamp()
	local offset = vim.fn.strftime("%z"):gsub("(%d%d)$", ":%1")
	return vim.fn.strftime("%Y-%m-%dT%H:%M") .. offset
end
vim.keymap.set("n", "<leader>sti", function() -- ISO
	vim.api.nvim_put({ iso_timestamp() }, "c", true, true)
end)
vim.keymap.set("n", "<leader>std", function() -- Date
	vim.api.nvim_put({ vim.fn.strftime("%Y-%m-%d") }, "c", true, true)
end)
vim.keymap.set("n", "<leader>stt", timestamp("+%T")) -- Time
vim.keymap.set("n", "<leader>stm", timestamp("+%I:%m")) -- Time (minutes)

-- Markdown snippets
vim.keymap.set("n", "<leader>sml", "a[]()<ESC>i")
vim.keymap.set("v", "<leader>sml", 'di[<c-r>"]()<ESC>i')

-- Banner comments: ==== rules around centered text, 80 columns by default
-- (set vim.g.banner_width to change it). Running it on an existing banner
-- strips it again, so the mapping toggles.
local function banner_width()
	return tonumber(vim.g.banner_width) or 80
end

-- The contiguous run of comment lines around a row. Used for stripping, so a
-- banner sitting flush against code doesn't swallow the next statement.
local function comment_block(buf, row, commentstring)
	local left = vim.trim(commentstring:match("^(.-)%%s") or "#")
	local total = vim.api.nvim_buf_line_count(buf)
	local function commented(r)
		local l = vim.api.nvim_buf_get_lines(buf, r - 1, r, false)[1]
		return l ~= nil and left ~= "" and vim.trim(l):sub(1, #left) == left
	end
	if not commented(row) then
		return row, row
	end
	local from, to = row, row
	while from > 1 and commented(from - 1) do
		from = from - 1
	end
	while to < total and commented(to + 1) do
		to = to + 1
	end
	return from, to
end

-- The run of non-blank lines around a row, i.e. what `ip` selects.
local function paragraph(buf, row)
	local total = vim.api.nvim_buf_line_count(buf)
	local function blank(r)
		local l = vim.api.nvim_buf_get_lines(buf, r - 1, r, false)[1]
		return l == nil or vim.trim(l) == ""
	end
	if blank(row) then
		return row, row
	end
	local from, to = row, row
	while from > 1 and not blank(from - 1) do
		from = from - 1
	end
	while to < total and not blank(to + 1) do
		to = to + 1
	end
	return from, to
end

local function banner_toggle()
	local strings = require("utils.strings")
	local cs = vim.bo.commentstring
	local buf = 0
	local row = vim.api.nvim_win_get_cursor(0)[1]

	-- Strip an existing banner if the cursor is in one. This uses the comment
	-- block rather than the paragraph so a banner sitting flush against code
	-- doesn't swallow the next statement.
	local cfrom, cto = comment_block(buf, row, cs)
	local stripped = strings.unbanner(vim.api.nvim_buf_get_lines(buf, cfrom - 1, cto, false), cs)
	if stripped then
		vim.api.nvim_buf_set_lines(buf, cfrom - 1, cto, false, stripped)
		return
	end

	-- Otherwise wrap the paragraph, the same lines `ip` selects. Indentation
	-- is handled by strings.banner, which dedents the block and shifts it as a
	-- unit, so don't flatten the lines here.
	local from, to = paragraph(buf, row)
	local lines = vim.api.nvim_buf_get_lines(buf, from - 1, to, false)
	vim.api.nvim_buf_set_lines(buf, from - 1, to, false, strings.banner(lines, banner_width(), cs))
end

-- :Banner            toggle the banner around the cursor
-- :Banner Some text  insert a new banner here
vim.api.nvim_create_user_command("Banner", function(opts)
	if opts.args ~= "" then
		local row = vim.api.nvim_win_get_cursor(0)[1]
		local lines = require("utils.strings").banner(opts.args, banner_width(), vim.bo.commentstring)
		vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, lines)
	else
		banner_toggle()
	end
end, { nargs = "*", desc = "Toggle a ==== banner comment" })

vim.keymap.set("n", "<leader>sb", banner_toggle, { desc = "Toggle banner comment" })

-- TODO: Pane resizing
