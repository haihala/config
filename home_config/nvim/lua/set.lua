-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

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

-- TODO:
-- Go back when reopening a file (from old config)
-- if has("autocmd")
--     au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
--                 \| exe "normal! g'\"" | endif
-- endif

-- Misc
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
