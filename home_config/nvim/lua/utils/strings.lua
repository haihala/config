local M = {}

M.trim = function(input)
    return input:gsub("^%s*(.*)%s*$", "%1")
end

return M
