local M = {}

M.trim = function(input)
	return input:gsub("^%s*(.*)%s*$", "%1")
end

-- Builds a centered banner comment, e.g. for css:
--   /* ========================= */
--   /*        Section name       */
--   /* ========================= */
-- Driven by a commentstring so it works in any filetype. Filetypes without a
-- closing marker (-- , //, #) get the trailing padding trimmed instead.
M.banner = function(text, width, commentstring)
	width = width or 80
	local cs = commentstring
	if not cs or cs == "" or not cs:find("%%s") then
		cs = "# %s"
	end

	local left, right = cs:match("^(.-)%%s(.-)$")
	left, right = vim.trim(left), vim.trim(right)

	local inner = width - (#left + 1) - (right ~= "" and #right + 1 or 0)
	local rule = string.rep("=", inner)
	local lead = math.max(0, math.floor((inner - #text) / 2))
	local trail = math.max(0, inner - lead - #text)
	local middle = string.rep(" ", lead) .. text .. string.rep(" ", trail)

	local function wrap(line)
		if right ~= "" then
			return left .. " " .. line .. " " .. right
		end
		-- gsub also returns a substitution count, and this is the last value in
		-- a table constructor below, so parenthesise the extra return away.
		return ((left .. " " .. line):gsub("%s+$", ""))
	end

	return { wrap(rule), wrap(middle), wrap(rule) }
end

return M
