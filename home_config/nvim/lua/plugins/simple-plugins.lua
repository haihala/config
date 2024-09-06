return {
    { 'tpope/vim-surround', },
    { 'tpope/vim-repeat' }, -- This is just for vim-surround,
    {
        'windwp/nvim-ts-autotag',
        config = function() require('nvim-ts-autotag').setup() end
    },
    {
        '3rd/image.nvim',
        event = "VeryLazy",
        opts = {
            backend = "kitty",
            integrations = {
                markdown = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
                },
                neorg = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    filetypes = { "norg" },
                },
            },
            max_width = nil,
            max_height = nil,
            max_width_window_percentage = nil,
            max_height_window_percentage = 50,
            kitty_method = "normal",

        },
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
