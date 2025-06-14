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
vim.opt.expandtab = true -- Make spaces instead of tabs when pressing tab
vim.opt.smarttab = true  -- Always put tabs at the start of the line

vim.opt.autoindent = true
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
