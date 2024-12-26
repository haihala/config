-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Cursor visualization
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- Indents
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- Swap files
vim.opt.swapfile = false
vim.opt.backup = false

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true -- Searching with upper case character is case sensitive

-- Text wrapping
vim.opt.showbreak = "> "
vim.opt.breakindent = true
vim.opt.breakindentopt = { 'shift:2' }

-- Automatically reload and save files upon navigation
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.autowriteall = true

-- Spell checks
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Neovide
if vim.g.neovide then
    vim.o.guifont = "Source Code Pro:h10"
end

-- Misc
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

-- Unobvious file types
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "Jenkinsfile" },
    command = ":set filetype=groovy",
})
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.tf" },
    command = ":set filetype=terraform",
})


-- Automatically wrap lines when writing markdown.
-- Use `gwip` to manually reformat a paragraph
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.md" },
    callback = function()
        vim.opt.textwidth = 80
    end
})
