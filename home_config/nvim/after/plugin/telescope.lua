local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup {
    defaults = {
        file_ignore_patterns = { ".git/", "node_modules" },
        layout_strategy = "vertical"
    },
    pickers = {
        find_files = {
            hidden = true
        }
    },
    extensions = {
        file_browser = {
            hidden = true,
            hijack_netrw = true
        },
    }
}

telescope.load_extension("ui-select")
local fb = telescope.load_extension("file_browser")
local projects = telescope.load_extension('projects')

vim.keymap.set('n', '<leader>fP', projects.projects, {})

-- File explorer (comes from the file browser extention)
vim.keymap.set("n", "<leader>fe", function() fb.file_browser({ path = "%:p:h" }) end, {})
vim.keymap.set("n", "<leader>fE", function() fb.file_browser({ path = "%:p:h", hidden = true, no_ignore = true }) end, {})
vim.keymap.set("n", "<leader>fr", fb.file_browser, {})
vim.keymap.set("n", "<leader>fR", function() fb.file_browser({ hidden = true, no_ignore = true }) end, {})

-- Find files
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fF', function() builtin.find_files({ no_ignore = true }) end, {})

-- Search
vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fS', function() builtin.live_grep({ additional_args = { "--no-ignore" } }) end, {})

-- Jumps
vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})

-- Old (recently opened) files
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})

-- Help
vim.keymap.set('n', '<leader>fvm', builtin.help_tags, {}) -- Find vim manual
vim.keymap.set('n', '<leader>fm', builtin.man_pages, {})  -- Find man

-- Find previous
vim.keymap.set('n', '<leader>fp', builtin.resume, {})

-- Git
vim.keymap.set('n', '<leader>fgf', builtin.git_files, {})    -- Files not in gitignore
vim.keymap.set('n', '<leader>fgb', builtin.git_branches, {}) -- Branches
vim.keymap.set('n', '<leader>fgc', builtin.git_commits, {})  -- Commits
vim.keymap.set('n', '<leader>fgs', builtin.git_status, {})   -- Status (lists changed files)
