return {
    { 'tpope/vim-surround', },
    { 'tpope/vim-repeat' }, -- This is just for vim-surround,
    {
        'windwp/nvim-ts-autotag',
        config = function() require('nvim-ts-autotag').setup() end
    },
    { 'mhinz/vim-startify', },
    {
        "stevearc/oil.nvim",
        keys = { { "<leader>o", "<CMD>Oil<CR>" } },
        config = true,
    },

    {
        'mbbill/undotree',
        keys = { { "<leader>u", vim.cmd.UndotreeToggle } },
        config = function()
            vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
            vim.opt.undofile = true
        end

    },

    {
        'sbdchd/neoformat',
        config = function()
            vim.g.neoformat_try_node_exe = 1
            vim.cmd [[autocmd BufWritePre * silent! Neoformat]]
        end
    },
    {
        'christoomey/vim-tmux-navigator',
        keys = {
            { "<A-h>", ":TmuxNavigateLeft<CR>" },
            { "<A-j>", ":TmuxNavigateDown<CR>" },
            { "<A-k>", ":TmuxNavigateUp<CR>" },
            { "<A-l>", ":TmuxNavigateRight<CR>" },
        }
    },
}
