local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup {
    defaults = {
        file_ignore_patterns = { ".git/", "node_modules" }
    },
    pickers = {
        find_files = {
            hidden = true
        }
    },
    extensions = {
        file_browser = {
            hidden = true,
            collapse_dirs = true
        },
    }
}

telescope.load_extension("ui-select")
telescope.load_extension("file_browser")
local projects = telescope.load_extension('projects')

vim.keymap.set('n', '<leader>fP', projects.projects, {})

-- File explorer (comes from the file browser extention)
vim.keymap.set("n", "<leader>fe", ":Telescope file_browser path=%:p:h<CR>")
vim.keymap.set("n", "<leader>fr", ":Telescope file_browser <CR>") -- r = root

-- Find files
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

-- Search
vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})

-- Jumps
vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})

-- Old (recently opened) files
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

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
