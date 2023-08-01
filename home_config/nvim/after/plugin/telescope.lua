local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup {
    defaults = {
        file_ignore_patterns = { ".git/" }
    },
    pickers = {
        find_files = {
            hidden = true
        }
    }
}

-- Find files
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

-- Find git
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})

-- Search
vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})

-- Jumps
vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})

-- Help
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Find content
vim.keymap.set('n', '<leader>fc', function() builtin.grep_string({ search = vim.fn.input("Grep> ") }); end)

vim.keymap.set('n', '<leader>fr', builtin.resume, {})
