local grapple = require("grapple")

vim.keymap.set("n", "<leader>m", grapple.toggle)
vim.keymap.set("n", "<leader>M", grapple.toggle_tags)

for i = 1, 9 do
    vim.keymap.set("n", "<A-" .. i .. ">", "<cmd>Grapple select index=" .. i .. "<cr>")
end
