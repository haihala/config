local M = {}

M.trim = function(input)
	return input:gsub("^%s*(.*)%s*$", "%1")
end

-- Splits a commentstring into its trimmed left and right markers. Filetypes
-- with no closing marker (-- , //, #) return "" for the right one.
local function markers(commentstring)
	local cs = commentstring
	if not cs or cs == "" or not cs:find("%%s") then
		cs = "# %s"
	end
	local left, right = cs:match("^(.-)%%s(.-)$")
	return vim.trim(left), vim.trim(right)
end

-- Removes the common leading whitespace from a list of lines and strips
-- trailing whitespace, so relative indentation between them is kept. Returns
-- the dedented lines and the length of the longest one.
M.dedent = function(lines)
	local shallowest
	for _, line in ipairs(lines) do
		if vim.trim(line) ~= "" then
			local indent = #line:match("^%s*")
			if shallowest == nil or indent < shallowest then
				shallowest = indent
			end
		end
	end
	shallowest = shallowest or 0

	local out, longest = {}, 0
	for i, line in ipairs(lines) do
		local trimmed = (line:sub(shallowest + 1):gsub("%s+$", ""))
		out[i] = trimmed
		longest = math.max(longest, #trimmed)
	end
	return out, longest
end

-- Builds a centered banner comment, e.g. for css:
--   /* ========================= */
--   /*        Section name       */
--   /* ========================= */
-- Takes a single string or a list of lines. A block is centered as a unit:
-- the lines are dedented to the shallowest one, then shifted together by a
-- single offset, so relative indentation between them survives.
-- Driven by a commentstring so it works in any filetype. Filetypes without a
-- closing marker get the trailing padding trimmed instead.
M.banner = function(text, width, commentstring)
	width = width or 80
	local lines = type(text) == "table" and text or { text }
	local left, right = markers(commentstring)
	local inner = width - (#left + 1) - (right ~= "" and #right + 1 or 0)

	local function wrap(line)
		if right ~= "" then
			return left .. " " .. line .. " " .. right
		end
		-- gsub also returns a substitution count, and this is the last value in
		-- a table constructor below, so parenthesise the extra return away.
		return ((left .. " " .. line):gsub("%s+$", ""))
	end

	local body, longest = M.dedent(lines)
	local lead = math.max(0, math.floor((inner - longest) / 2))

	local out = { wrap(string.rep("=", inner)) }
	for _, line in ipairs(body) do
		local padded = string.rep(" ", lead) .. line
		table.insert(out, wrap(padded .. string.rep(" ", math.max(0, inner - #padded))))
	end
	table.insert(out, wrap(string.rep("=", inner)))
	return out
end

-- Strips a banner back to its plain text lines, or returns nil when the given
-- lines are not a banner. The inverse of M.banner, so the two can toggle.
M.unbanner = function(lines, commentstring)
	if #lines < 2 then
		return nil
	end
	local left, right = markers(commentstring)

	local function uncomment(line)
		local s = vim.trim(line)
		if left ~= "" and s:sub(1, #left) == left then
			s = s:sub(#left + 1)
		end
		if right ~= "" and s:sub(-#right) == right then
			s = s:sub(1, #s - #right)
		end
		-- Only the left marker's single space is removed here; the block's
		-- shared centering offset is taken off by M.dedent below, which keeps
		-- relative indentation between the lines intact.
		return (s:gsub("^ ", ""))
	end

	local function is_rule(line)
		return vim.trim(uncomment(line)):match("^=+$") ~= nil
	end

	if not (is_rule(lines[1]) and is_rule(lines[#lines])) then
		return nil
	end

	local body = {}
	for i = 2, #lines - 1 do
		table.insert(body, uncomment(lines[i]))
	end
	return (M.dedent(body))
end

return M
