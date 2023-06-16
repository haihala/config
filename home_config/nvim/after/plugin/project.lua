local projects = require('telescope').load_extension('projects')

vim.keymap.set('n', '<leader>fp', projects.projects, {})
